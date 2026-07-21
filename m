Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD283E49EF;
	Tue, 21 Jul 2026 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655032; cv=none; b=YnLIlG29mUv8jZBh7uuqn9fb9z9PUacLHAgUL6UDUl4K93lD//VrX2KWTYigJGtAp3LHihJNI2ZynqB1JmjTd16BEyUFCGwARTp7wU+ZyJXHlG41gx6Jv+nrSN2J+nmD2c/NJJHQrqbYvm+h79rK1n2mhp95xmHNTyiIjMc9nws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655032; c=relaxed/simple;
	bh=l+vc3upEJT7gmsb91BjUsgSdFx2DAfHuG2r4psWKr90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3p8kEDnoMpjlvQpyqKRCLqhlvJOERR4J0ZzVr/Lr/x9LvrVEHpI/WQRNUDfL7ut4f5cyxDXvXv89eayqL40HLy3vHlIO9kMcmF6ZNoWPdJSG8DL+iFWmibG0Qx246EJtd7jNvAUJBV1HaUbzZafXSDhDpgaCRzUgmwmQh78cmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0I3HTZIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0I3HTZIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF3D1F000E9;
	Tue, 21 Jul 2026 17:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655031;
	bh=TmMAAFv0nukQ0M256ghtljPsaolpGDTWtHXpGWO26So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0I3HTZILH1VY2liZPcR/Rjr2EQaPpY4WcPfx9NNDTb19WzaD/4DgiDCM864RFPJhS
	 1+Fmh7cm5RAp7A1LrcMip7fft0Wx4CSE+9keRqkHKMGgA87zR1ERQp1Ns92FNT1HtV
	 BBhjOBCqAumjIQ1AVlq/zIgAGKpgEgk3cnwwP6cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1929/2077] netfilter: nfnetlink_cthelper: cap to maximum number of expectation per master
Date: Tue, 21 Jul 2026 17:26:42 +0200
Message-ID: <20260721152638.209090309@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit bf5355cfdede3e30b30e63a5a74f6bdaafb26082 upstream.

If userspace helper policy updates sets maximum number of expectation to
zero, cap it to NF_CT_EXPECT_MAX_CNT (255) on updates too.

Fixes: 397c8300972f ("netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nfnetlink_cthelper.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -163,6 +163,8 @@ nfnl_cthelper_expect_policy(struct nf_co
 		    tb[NFCTH_POLICY_NAME], NF_CT_HELPER_NAME_LEN);
 	expect_policy->max_expected =
 		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
+	if (!expect_policy->max_expected)
+		expect_policy->max_expected = NF_CT_EXPECT_MAX_CNT;
 	if (expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
 		return -EINVAL;
 


