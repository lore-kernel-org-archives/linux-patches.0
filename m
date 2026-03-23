Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32A03ACF03;
	Mon, 23 Mar 2026 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274164; cv=none; b=kPsAzjtoKAyknjQcezx1FKXiXV5QhrQujlV2vDzPKHjybbgzWu+4yimNkbLhraO4AHjB1hTm7sCpZIqx04JygO5kBgbhaKwfAeGFT37hKpjKGH3Uq3LwM9RQxAZaw0J7U9nokpesmOy2YjUjLmRTvCoUkTvjLHPywLVVR3Cjp1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274164; c=relaxed/simple;
	bh=hNLdmjTOH64/CroviRLDwnpDE70o1U10oNbI6uKWEtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P00p8+nualcaRhOSu5ap25QjZBOAg5eHWjKKU7q6LMZ4mn0w5pcQnmPaXkY/PioPmFleXUYc3fRmBkRqr6rmawMcF8EunaErp96F1wJvmYvZVfVWvVzsuK+/sCkc6ckrGgJpHUmj9qnrAwox80CRahBz/vKv7xXoDChuigDD8aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYujgROt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYujgROt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ECFC4CEF7;
	Mon, 23 Mar 2026 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274164;
	bh=hNLdmjTOH64/CroviRLDwnpDE70o1U10oNbI6uKWEtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYujgROtT6hk9lh4X0bYGaUcoZCDrn0ULzQqR8qJAr56f32NNkxqBsnWhmFyEBVre
	 vD2LAX8yBl6DQQAf5zauFsm3NTo79cYQY/PX7P5Dc/jCAWdi/29SqbNDv1bevHhRma
	 es3Jkl7S6gbUR8PebYhlfnwD2wJyevJvuDC0/mmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 131/220] mpls: add missing unregister_netdevice_notifier to mpls_init
Date: Mon, 23 Mar 2026 14:45:08 +0100
Message-ID: <20260323134508.724192937@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 99600f79b28c83c68bae199a3d8e95049a758308 ]

If mpls_init() fails after registering mpls_dev_notifier, it never
gets removed. Add the missing unregister_netdevice_notifier() call to
the error handling path.

Fixes: 5be2062e3080 ("mpls: Handle error of rtnl_register_module().")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/7c55363c4f743d19e2306204a134407c90a69bbb.1773228081.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 580aac112dd21..c57f10e2ef269 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2854,6 +2854,7 @@ static int __init mpls_init(void)
 	rtnl_af_unregister(&mpls_af_ops);
 out_unregister_dev_type:
 	dev_remove_pack(&mpls_packet_type);
+	unregister_netdevice_notifier(&mpls_dev_notifier);
 out_unregister_pernet:
 	unregister_pernet_subsys(&mpls_net_ops);
 	goto out;
-- 
2.51.0



