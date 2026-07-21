Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10ED845BD4E;
	Tue, 21 Jul 2026 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657313; cv=none; b=scvpQgRgo7H01ztmXo8wJRcH6WRiZgIHLIgMLHarGeDtrv2SmKI4L1LpEOeNkKXHSih/KwaqKT+WB34W8SZii1n0ZfgRHIxHhwFUSYVsQWsQ3Ee4m2BkW1yx5nw73eFZ49ph1w6hzUe6krTU0wne4A+3dZdOxgWmWgBFJUMIYPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657313; c=relaxed/simple;
	bh=Rs9IYlZ38XnukBh8zt/gicOZ3hpcHK39DPvL753YF/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fGDwwwDidXgC3SoCZaCK/9V+JRfN8kRw8yMOopHkVoO8jDlrY7quxe2ckE5lRthOF57ZVDfcaylFbSn/WVocygEvv+us76Xnsh5Q3fhvZD0vOTZYx4YYw81IE2TQfe7ELTFZ2vDj6qW60WLsg2FB38C70uR/I/cO3S5fDsB5ZIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJ04ehjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJ04ehjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D241F000E9;
	Tue, 21 Jul 2026 18:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657312;
	bh=sWflF0DasTEOMk8XqdliOSjRjDB/TtDu6gIJaTkuH1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJ04ehjLHtc9wqj8TFgNDLzKB/w1+7KPPWqRiIv0X6wakvVQwX9Ww1Dp/AZyBwxHU
	 +O3wI9we+08OzwseEeDOn0uIIMjUlGXYGW830Qs0JY9AT6UVxQRPiMt7Bc/AdWa9wq
	 ICZcv+r1JwdfZV4gHZOYP+Vz6PRax+MOCp1vK0Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0717/1611] perf symbols: Bounds-check descsz in sysfs__read_build_id() GNU fallback
Date: Tue, 21 Jul 2026 17:13:53 +0200
Message-ID: <20260721152531.508275188@linuxfoundation.org>
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

[ Upstream commit 1b4e9fbdeabc549965e70ac0cd8095d57ff6df06 ]

When sysfs__read_build_id() matches NT_GNU_BUILD_ID with the right
namesz but the name content is not "GNU", it falls back to reading
descsz bytes into the stack buffer bf[BUFSIZ]:

    } else if (read(fd, bf, descsz) != (ssize_t)descsz)

Unlike the else branch which validates namesz + descsz against
sizeof(bf), this path passes descsz directly to read() without any
bounds check.  A crafted sysfs file with a large n_descsz overflows
the 8192-byte stack buffer.

Add a descsz > sizeof(bf) check before the read, breaking out of
the loop on oversized values.

Fixes: e5a1845fc0aeca85 ("perf symbols: Split out util/symbol-elf.c")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 2b91255123c340..f96aec292ade23 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -959,8 +959,13 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
 					err = 0;
 					break;
 				}
-			} else if (read(fd, bf, descsz) != (ssize_t)descsz)
-				break;
+			} else {
+				/* descsz from untrusted file — clamp to buffer */
+				if (descsz > sizeof(bf))
+					break;
+				if (read(fd, bf, descsz) != (ssize_t)descsz)
+					break;
+			}
 		} else {
 			size_t n;
 
-- 
2.53.0



