Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C1146E01C;
	Tue, 21 Jul 2026 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657301; cv=none; b=bowxn/Ax2c63B9Owsl4CGmrVmu5QdBPoJXMnjo86/NPHJomqyoZkT908U8Ba6hQSkuZUABvJq01AZTCbnFF/U/NVEpWQr33a5LK6glX2kG795hDIkiLQdMp5RM+qMm+8eGUR6AQklliHGiWFHe786lOrMBEapF0VQEaucEg03xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657301; c=relaxed/simple;
	bh=FGUm76KDVudKjz7EkqccFJAhOZfnMkzUkqKAft2D/eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmgMngKcIfksmnZYEkobBRqDM9bBBefaI68falX8o5ETnD6qvqf6NNNnSR5VNrWk3H5avvU7rvzOmCJ3cvulR9kYLMPfI6GXtgENIUOzPQ76iJZn4J9XZgj2XcxiQM2rmRLT7EZ5NFFng5Bf4rjQuO2KQnk9WFMfGPfGiJiIO/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skyya1yy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skyya1yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4FC1F00A3D;
	Tue, 21 Jul 2026 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657296;
	bh=ejX+q9chwqjGMfB/EF1ZoPvCZpGD9GceGsB7LP8NNIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skyya1yy3r/bZqxDMwZ1+gtWZJKobPNOUgC96vxolrzQqcYAAe1nZ1G7qY+smHRUX
	 KxYRXk1xi9EkVlV/TJFMEXBqB7vfEhZd8pIAUPbF8O5rCIryfMRKMi5MPwXWBIESw/
	 GzVB9jVmeT0UyyMhhspH5dDOdcjVXj/fcponH8ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0712/1611] perf intel-pt: Fix snprintf size tracking bug in insn decoder
Date: Tue, 21 Jul 2026 17:13:48 +0200
Message-ID: <20260721152531.396861531@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b6bb3b005dcdd960b8e0b7f9d6869132b3de08d5 ]

dump_insn() tracks remaining buffer space with a 'left' variable,
but the loop subtracts the cumulative offset 'n' each iteration
instead of just the per-iteration delta:

    n += snprintf(x->out + n, left, "%02x ", inbuf[i]);
    left -= n;  /* BUG: n is cumulative, not the delta */

After two iterations left goes massively negative, wrapping to a
huge value when passed as size_t to snprintf(), disabling all bounds
checking for the rest of the loop.

Switch to scnprintf() accumulation using sizeof(x->out) - n as the
remaining space, which is always correct and eliminates the separate
'left' variable entirely.

Fixes: 48d02a1d5c137d36 ("perf script: Add 'brstackinsn' for branch stacks")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../util/intel-pt-decoder/intel-pt-insn-decoder.c     | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
index 72c7a4e15d617b..f90fcbc4302df5 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
@@ -220,7 +220,6 @@ const char *dump_insn(struct perf_insn *x, uint64_t ip __maybe_unused,
 {
 	struct insn insn;
 	int n, i, ret;
-	int left;
 
 	ret = insn_decode(&insn, inbuf, inlen,
 			  x->is64bit ? INSN_MODE_64 : INSN_MODE_32);
@@ -229,13 +228,9 @@ const char *dump_insn(struct perf_insn *x, uint64_t ip __maybe_unused,
 		return "<bad>";
 	if (lenp)
 		*lenp = insn.length;
-	left = sizeof(x->out);
-	n = snprintf(x->out, left, "insn: ");
-	left -= n;
-	for (i = 0; i < insn.length; i++) {
-		n += snprintf(x->out + n, left, "%02x ", inbuf[i]);
-		left -= n;
-	}
+	n = scnprintf(x->out, sizeof(x->out), "insn: ");
+	for (i = 0; i < insn.length; i++)
+		n += scnprintf(x->out + n, sizeof(x->out) - n, "%02x ", inbuf[i]);
 	return x->out;
 }
 
-- 
2.53.0



