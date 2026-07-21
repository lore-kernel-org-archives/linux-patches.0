Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884AF2D8376;
	Tue, 21 Jul 2026 20:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666449; cv=none; b=tSk7Q9s7NrkxGNq+K6nPugb4G3fD2URpbCu773XNIZEsuR2imfCi4qmGVH5VhxzpGNu+ukC6AhCFXKEw9kSJ4rCZhHtWzydW7s0LxFsEE/hiefEwIIqKCkKURLy4n3fZXTbOab4T/aHY8VIYUZfr+mSMkj+foPuXttCfUsSWnHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666449; c=relaxed/simple;
	bh=5I0/irSLndocKk9I1EP8OUDOnJ8+T6O5eaG6rk9KGPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2Yq1D+nv5WGeHG9pog6zy09VOFgADucw3SIXUkDW7QeE5viOY9LgZH/kK4os6X876pk2CjmkwrqUWfF4TROs3jVOFMYVSldY4kHxgm6icWHTPjKNewLVzu+CrcdVpaFE5NsCTOFuynjFuvy7IVj6AyAi56H2rDN1HobHUrDZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnCYflvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnCYflvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED4D1F000E9;
	Tue, 21 Jul 2026 20:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666448;
	bh=3nw6akWrkUOEGNC3YNFXhZoMM/9vI2D7lK/8LQ6RqrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnCYflvBbB+THvfT0Co5c/b+0Me5szGGeekt4Yz6AThVujhdSjXpbQmg+ijezK8o8
	 XD5dgbDOKF4JClYTdbsV63RVvox1vVCJt96D1PU/y4CcUUIlNF5hfNRnmxAOEqSVSb
	 DvURCnaI67Dc89M89VGb8K5lVL6GhkAJuYyh+C+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0685/1266] perf intel-pt: Fix snprintf size tracking bug in insn decoder
Date: Tue, 21 Jul 2026 17:18:42 +0200
Message-ID: <20260721152457.181116106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c5d57027ec23d3..03a143a02d40db 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
@@ -213,7 +213,6 @@ const char *dump_insn(struct perf_insn *x, uint64_t ip __maybe_unused,
 {
 	struct insn insn;
 	int n, i, ret;
-	int left;
 
 	ret = insn_decode(&insn, inbuf, inlen,
 			  x->is64bit ? INSN_MODE_64 : INSN_MODE_32);
@@ -222,13 +221,9 @@ const char *dump_insn(struct perf_insn *x, uint64_t ip __maybe_unused,
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



