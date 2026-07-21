Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B40639A7FD;
	Tue, 21 Jul 2026 19:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660519; cv=none; b=e1R3hY0a2f1ZtMJat5LsBt1BRjFYcnhU+LCZVakhKZ5Prj208YUwnY7XU5eBqQeR4soU5LzhJwIye/GMTKfcJtrXdW83Y4GQgTvOtUP2N0Ic9nu2fpQcVcclbgNH1LnEts8YPCTsH36Y/byvAvB9H2wa73hfsx2n/QIcOg47dQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660519; c=relaxed/simple;
	bh=Lmq4KmrTRvkqhqGAzSnMsyA96PyJsBhxtZLYw8iViGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VnI6GpdJORYoytdoQoRo4vtj2wBGeAgbDUrb0pPYD/1cR9ZW4/US49iRDUjlW8Lssn4Z0d+SQzq0kRcdb+5kNOVS9qab2mKVQIJ1k4SwWZPMR387NWPcnW23rJn0CVjCSHMD9wgrq/Yzjc08/hDoqJSW70NJSLXlwpmi1aVA/gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoVyTfz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoVyTfz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95AB1F00A3D;
	Tue, 21 Jul 2026 19:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660515;
	bh=KNE9Uyx7VR9tWhRnFP40YDLoiT9NgYKQVTo5f281s3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XoVyTfz5cAkyOcd5MarX55sMDyuyOjdrb6J9+03sAp4y/vXs0F6TKGsz8ZNKF85mR
	 XMT1aE4brZmSCjemtt6cgUxZkEw12uTPrYeNTOFudalxOA6p8NZHvJVndH1LJ/dvkW
	 U89Yr/zUrim4xImdlHo4WeNtffFqoo3W1yn1A8IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1007/2077] perf symbols: Fix signed overflow in sysfs__read_build_id() size check
Date: Tue, 21 Jul 2026 17:11:20 +0200
Message-ID: <20260721152616.567881768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0ba2c60ea5aaba..792d270c3a70da 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -963,14 +963,17 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
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



