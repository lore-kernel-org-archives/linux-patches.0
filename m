Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043629;
	b=vrDOARhPsyjHDj5UTovJmT+DAyO7UIJtBPFxi7cwGjJZN5iITx0QWskqa4Rc9hMdcbTa
	 sd7S8Y62MM/VpNAh2HHodrWVHePcdzjQs41tWSPJj0yPG2LUcc2pKTFVzNgfxz4H+Hrt6
	 t3En2Xl0GXeOXa/4t3lIqLmMabYnrfGGR7XqN/hsXKF5khyNRzJ+r7Jlc+T905wxLMp8X
	 FMz7hteRPSL4ixqhsQQ2dFNfmlMFEUHBFbB3oDDyN5EIzZkgK++dk8OxLtIxRG5rPAsp5
	 rbXl/Nk7t4/KzRZKHlv2Ma3ZtG+mT9Q1nlEWIHoLWAyq7B7hK143DGZz6KaVdOFtqMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7SPEl17Uw35NKR3DBk4sXdBBlm0/6GZ79HQAsjDf1TI=;
	b=j+u/GFuZmhrRBi+7M5GADGWXuGlMDbEChbihMxjH+j2ZMUTNQCTAsIM1AVmSOjL++fGG
	 ApxWgphbvUNvsXATsKtq9S9kUrDBM/+wSLjWvEhZlE68wekN4UIDlq3eoQ75VZxONeBvC
	 IAhKEpG/Bqcfk6wX2mJa6C75HJehFcKxFT2r/V8E465AthZsby/ZlF8yUYzImg9TSc3pO
	 /N1+GdnXLIDJ9VA6CWfWVf5198D9W7ykttxxjKT3BxxAcOMN278Mk1Ivd4SHAo6B7MMyM
	 jbu+lat59SY2UlV6N2Bwg8RwGqwarSfLA61uEsaoRABD/UURJ9L/QMIfU3FL+yk3e9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1d4Jolc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6EF606A325;
	Wed, 18 Nov 2026 23:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1d4Jolc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935751F000C4;
	Wed, 18 Nov 2026 23:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043629;
	bh=7SPEl17Uw35NKR3DBk4sXdBBlm0/6GZ79HQAsjDf1TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1d4Jolc44+y6J1UL8VobunOhAjMfSaX98M6piNWXRsvNC1Frs+puPWNGEaKJ8se0
	 qyws5IY4A0Sbx44SigPIECW7EdnzflVl2XvDgs6W/AkM4IzsSsKF8ODC3m+q6F34kP
	 qPE2CVylwz8cbHJa9R8wanXXoyG5UMIp+xJ0KP9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Tatas <michail.tatas@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0237/2857] ipmi: Fix leak in __ipmi_bmc_register
Date: Wed, 18 Nov 2026 15:21:11 +0100
Message-ID: <20261118150209.983044435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 18e633dd9674c8bf118ea8583bb5a531edc2728a ]

In case that ida_alloc(&ipmi_bmc_ida,...) succeeds and then
platform_device_register() fails, ipmi_bmc_ida is leaked.
Fix by freeing the error path

Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Message-ID: <anUK_HOy_pCgvsBm@michalis-linux>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 98a92af5b1d8c..d8b63b26c7938 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3257,6 +3257,7 @@ static int __ipmi_bmc_register(struct ipmi_smi *intf,
 	list_del(&intf->bmc_link);
 	mutex_unlock(&bmc->dyn_mutex);
 	intf->bmc = &intf->tmp_bmc;
+	ida_free(&ipmi_bmc_ida, bmc->pdev.id);
 	put_device(&bmc->pdev.dev);
 	goto out;
 }
-- 
2.53.0



