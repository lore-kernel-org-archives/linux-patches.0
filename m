Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D75749C;
	Tue, 26 Aug 2025 11:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208906; cv=none; b=YmiVnhVRtShmBzruaRBfX3+yiPU6boUOPW8tt3t8/yKAlColvhUUpcahOP4gAG7PN/A8ei9/xGtQl+lB2LrhUNM7kP8eKJEhwNRHNWDB8meF1u+if5ffz2jWponBhpIOYu9XJ6gDSgJUlR6gLIoZd3Ehr4a0GM0N3Xca/5yprQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208906; c=relaxed/simple;
	bh=KYXxTBks21uVp+5VKoCrsKW9rE2DCNVDR0uVo+Qd38U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ls2nZmRJ9luZkNbedBMNQsw/1txXLB8xf+2hmTpgK35f2R91/5LaHsnITR2FQ5R6TnyBOnb4u1P9/Q0RdsE1RGgzZeAIIRXmSFzUlzCMEkzng6QRCzD1ADR5W7hUWW2EuGsABafgqZH4z1hIv7nzKyBRsHEqz8Kx2W2QCwMsW2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5QuxSi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5QuxSi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FFCC4CEF4;
	Tue, 26 Aug 2025 11:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208905;
	bh=KYXxTBks21uVp+5VKoCrsKW9rE2DCNVDR0uVo+Qd38U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5QuxSi5TKsA4yPjZcIG3mkcCX6Yr1mRamZ5hBlDVxFJyL/ZQy1xr/xfTbYetQAaw
	 U3dFMaZBOyIRC46FAiz43Oup9iY2AYbY7MDmVAnExVU3TCot6C1n0/cgKYcS1oWnXJ
	 wtoc01vsc3ltaZiwppsatdvqfWDQScDSm3RXT9MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/322] ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add
Date: Tue, 26 Aug 2025 13:11:46 +0200
Message-ID: <20250826110923.094171042@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit 84967deee9d9870b15bc4c3acb50f1d401807902 ]

The seg6_genl_sethmac() directly uses the algorithm ID provided by the
userspace without verifying whether it is an HMAC algorithm supported
by the system.
If an unsupported HMAC algorithm ID is configured, packets using SRv6 HMAC
will be dropped during encapsulation or decapsulation.

Fixes: 4f4853dc1c9c ("ipv6: sr: implement API to control SR HMAC structure")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250815063845.85426-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_hmac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index e955008e732b..5d21a74c1165 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -296,6 +296,9 @@ int seg6_hmac_info_add(struct net *net, u32 key, struct seg6_hmac_info *hinfo)
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 	int err;
 
+	if (!__hmac_get_algo(hinfo->alg_id))
+		return -EINVAL;
+
 	err = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
 					    rht_params);
 
-- 
2.50.1



