Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DEC32ED40;
	Mon, 17 Aug 2026 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973995; cv=none; b=pQb3YYDLTQfVXyXQd++YrwiYdqfP/zUL1ECu7EasXojdnWGLr1EOIArS5adtNjb1biEZT9BElcvd7KWNSK4tXjDdEvMAiyZ6Yq+oCy4jno4YL8UdDonqcMlzYlslJ2A1XzX8KcBfq2+CvQmM+p/2AIhIjqxyal3sV/mmblFfmC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973995; c=relaxed/simple;
	bh=Ex4oeGNEC4cIrib6ftqoOihFHtKyMdldK0z0SAAg/iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPoSUjnVEdf5bN8fgP4s/GPQEgpsg0tEA/SnWV6D+lm2p0SOr4vlVZ+DInZ/g3zC86ot5qAmDvdnFV6fru/dpL5PgeKE/DjezVe0otm3JuHtZ1J6b59ZOsZAwYTaCmuAiPzzFIjilPtc0v1uMejQCMdujr0i8jRQCIjjdZSqmzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckFCTjm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckFCTjm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E28C1F000E9;
	Mon, 17 Aug 2026 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973994;
	bh=3W+JFat1KRsIDvemNHASkzb1dtA8qs3IovJTSf7hDMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckFCTjm0C9k/6hyGTKoL2MrEKQOlkf79XdY4vejD8MR/Cv3uccsma/8D2uVpcG249
	 1fP4msYZIknjpcN18VFmZ2b2B/DOIqezch0uEDpDIKVdC1u7afLQRcQcWnfI9pw1rn
	 S+5WVJbHKh5XWrgPNCsrPGShjpFEFtLuDfzhf2y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Daniel Wade <danjwade95@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 053/271] bpf: Propagate untrusted pointer state in commuted arithmetic
Date: Mon, 17 Aug 2026 15:29:38 +0200
Message-ID: <20260817132538.922638755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit cdf19b1b3c01791de074ce282089131026f52261 ]

The untrusted PTR_TO_MEM early return skips pointer offset tracking
because accesses go through probe-read handling. Moving it after full
pointer-state propagation ensures scalar += untrusted_pointer leaves the
destination as PTR_TO_MEM instead of an unrelated scalar.

Fixes: f2362a57aeff ("bpf: allow void* cast using bpf_rdonly_cast()")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Tested-by: Daniel Wade <danjwade95@gmail.com>
Link: https://patch.msgid.link/20260729-c3-035-public-bpf-v4-v4-3-8ee297e2346b@mails.tsinghua.edu.cn
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ab88988d483d2..5bad71f003dcc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13801,13 +13801,6 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	/*
-	 * Accesses to untrusted PTR_TO_MEM are done through probe
-	 * instructions, hence no need to track offsets.
-	 */
-	if (base_type(ptr_reg->type) == PTR_TO_MEM && (ptr_reg->type & PTR_UNTRUSTED))
-		return 0;
-
 	switch (base_type(ptr_reg->type)) {
 	case PTR_TO_CTX:
 	case PTR_TO_MAP_VALUE:
@@ -13844,6 +13837,13 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	if (dst_reg != ptr_reg)
 		*dst_reg = *ptr_reg;
 
+	/*
+	 * Accesses to untrusted PTR_TO_MEM are done through probe
+	 * instructions, hence no need to track offsets.
+	 */
+	if (base_type(ptr_reg->type) == PTR_TO_MEM && (ptr_reg->type & PTR_UNTRUSTED))
+		return 0;
+
 	if (!check_reg_sane_offset_scalar(env, off_reg, ptr_reg->type) ||
 	    !check_reg_sane_offset_ptr(env, ptr_reg, ptr_reg->type))
 		return -EINVAL;
-- 
2.53.0



