Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF043E06C;
	Tue, 21 Jul 2026 22:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671886; cv=none; b=Pv1paRzxOVEujRcxgiFrMUPFbxIOxK4IOO0w5XDpaHOyZbw8V1IQ6MV3blC5TbTi6yKnT8TW41f9SSkfSsTqUconwVruwDJFsyOTIooLIFf8f2VtLvTmAvgDWeaCnu7fKhRycatVKwZ0iCWZlqVYxDX2GX3IY8UBSlpZy+LYgzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671886; c=relaxed/simple;
	bh=auHiNH+P/8AhH6A+PGk+U1GQR60LEP6nkutLz1epaUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDHVzradoEXT9IdH1eGBiAu29VphDtP9KYzOtAeTCMt+jg7/xYinmHklYT5LLQfyHDKpJGRGEs0al8wuZOxSJRikRfJTXk1Anv8AT1xxJRaBxM3lJam4GrFOzJLKY11S/gC2m+KbPZyYcisjGgWcBTbxPiXe0KcK+bD48t1OjM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbxid7GA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbxid7GA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BF91F000E9;
	Tue, 21 Jul 2026 22:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671885;
	bh=PcemfR9UgCOvk+Ba8kLLtSHed1/lXz6FSnbXBwiE/ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbxid7GAqm1F2Aag6Iypv8eLmMuUKHeyoBNJNYdCxWuUNU3I0HfB+DpFFlN1NRhxm
	 sCZm58k+hD3wc+ecD/ftfxPvYsziSE8sPdJMkFTYJTAN8CtTBtbnyoNvxQu5zeoqIc
	 XVJYJBGhOAy16VlY7aybeAtbkxfPsBzxKOW2zSk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 417/843] perf intel-pt: Fix snprintf size tracking bug in insn decoder
Date: Tue, 21 Jul 2026 17:20:52 +0200
Message-ID: <20260721152415.416628650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9f29cf7210773b..1c377f2454b06e 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
@@ -198,7 +198,6 @@ const char *dump_insn(struct perf_insn *x, uint64_t ip __maybe_unused,
 {
 	struct insn insn;
 	int n, i, ret;
-	int left;
 
 	ret = insn_decode(&insn, inbuf, inlen,
 			  x->is64bit ? INSN_MODE_64 : INSN_MODE_32);
@@ -207,13 +206,9 @@ const char *dump_insn(struct perf_insn *x, uint64_t ip __maybe_unused,
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



