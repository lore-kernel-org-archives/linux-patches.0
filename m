Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E7046E00E;
	Tue, 21 Jul 2026 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657295; cv=none; b=erFIGwic1GqNNkMnCyFFEnMdLQUuA2FKNqGJuFllJnDuAFWmwfIFUEXWBVSnjB+hfFB3mS0sPkAqsfzSXhEzqL5Nmej1OFU0ZCst4cyN3r2Z51z5BCuN5V5JPylUTdIYgCLzE6Pbuooks3VR+h/NJxA5325qghUfxl9NCB/8j6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657295; c=relaxed/simple;
	bh=vX1t7GoHu5pKhrYcPQM4WHSg+fj2K00oQtSrQMQmQwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUDh4157y8/QeaIUoutCRL1S7iWuJo/lABdU0ecprGzIQEb6yGilVP4Vq9lFwpW+c8NNEwyrjBfevVGObkBOHDKQNzRr7O+oARl4Zth1BRFk61oRkRMeHdjYq54Pyxse5yfe6CbrnfE2+FN/4EoSlMGV80tIV8VBAEEEW0KqIsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+kah97W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+kah97W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D75D1F000E9;
	Tue, 21 Jul 2026 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657290;
	bh=5s0Zi3A9deKvSs7UGULoXwoZjxnZhPIsDGYLO1xpUvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+kah97Wu80eQepAJRcjWDK4Nwjo5KKJ6b4pNxOFfMr3RpLItWGf7QLVbVJCtNc/8
	 al1N70kUR0eovcACNtMEDS9BwBXr+kSTdeoS5cI+q6Og8oPE14AblIPlhwPMe6ZPVs
	 +y4lRn322+otQQ2R1htiF8J9WiEPN4ptR1TOaI74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0710/1611] perf symbols: Fix signed overflow in sysfs__read_build_id() size check
Date: Tue, 21 Jul 2026 17:13:46 +0200
Message-ID: <20260721152531.352727220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 6eaa8ee3e2abe5112e80e94c27196bb175689469 ]

sysfs__read_build_id() reads ELF note headers from sysfs files.  The
note's namesz and descsz fields are used to compute the skip size:

    int n = namesz + descsz;
    if (n > (int)sizeof(bf))

Both namesz and descsz are size_t from NOTE_ALIGN() of 32-bit note
header fields.  Their sum can exceed INT_MAX, overflowing the signed
int n to a negative value.  The check n > sizeof(bf) then evaluates
false (negative < positive in signed comparison), and read(fd, bf, n)
reinterprets the negative n as a huge size_t count — the kernel writes
up to MAX_RW_COUNT bytes into the 8192-byte stack buffer.

In practice the overflow is bounded by the sysfs file's actual size,
so a real sysfs notes file won't trigger it organically.  But crafted
input (e.g. via a mounted debugfs/sysfs image) could.

Fix by validating namesz and descsz individually against the buffer
size before summing, and change n to size_t to avoid the signed
overflow entirely.

Fixes: f1617b40596cb341 ("perf symbols: Record the build_ids of kernel modules too")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 9602cc51dcc65b..0de9439ae2dcd7 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -962,14 +962,17 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
 			} else if (read(fd, bf, descsz) != (ssize_t)descsz)
 				break;
 		} else {
-			int n = namesz + descsz;
+			size_t n;
 
-			if (n > (int)sizeof(bf)) {
+			/* int sum of namesz+descsz can overflow negative, bypassing size check */
+			if (namesz > sizeof(bf) || descsz > sizeof(bf) - namesz) {
 				n = sizeof(bf);
 				pr_debug("%s: truncating reading of build id in sysfs file %s: n_namesz=%u, n_descsz=%u.\n",
 					 __func__, filename, nhdr.n_namesz, nhdr.n_descsz);
+			} else {
+				n = namesz + descsz;
 			}
-			if (read(fd, bf, n) != n)
+			if (read(fd, bf, n) != (ssize_t)n)
 				break;
 		}
 	}
-- 
2.53.0



