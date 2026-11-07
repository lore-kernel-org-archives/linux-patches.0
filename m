Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060972;
	b=aqtQQaJ4l1qAXGu5ichYSjSxNvmpByk3PNJTB0hbDoUxZONVlcH4lK+tct09DHnjtJu2
	 10y3RyV3ak4Eou+W7OdeeguLc1RaS6fXYBJGHTaTRnvsi1Pqfy18pCfGRr4ZLki3EiODO
	 aO9OiYX8QYg+qmRCoRYESqALB4D6lhC5cr9Px6SKor0TmaHRRQG84SD53chFV5y/sAzSH
	 7zSXCcq6j+OJD1+V+bZIJ8GO0t7ZdkANu+dV8OmAUKdEMGbq9azanT4xBtYObVInzjYof
	 pTmbJs5IPqswZxMOZMtg77LsHeJMNdXKANlYl7gdasRSXQ0cCB+rkbGpMAL7R+NjUYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=En8ss1IexT2DdvUjicn+KyUl5FWoaDpvGJBvaWEJnwg=;
	b=HVKLQJEOrAvnu6JBQ7MIXG9jQoK9SlKSiehu19N9qERl3vtMZ0Gj9Yq3tvHPaktE7Wlr
	 FHfVvtEjTNDpx71G9QmhJb1c6XeQpxiMSb75rCsPKMEXXZ0cQzyD4dt9ABJzzGWz8RkrS
	 2y1ggqABb9iuz9uIVuVavYr3Gd+bXeVNQst8aYsLrlxvCU54uvEGPh1i5a3a1Ee/Yl6Qt
	 OeU8v24NPT1ELCu1+Ubj75vhS8lZ7oHgqyVi1AALKvxoUd1u/hBdXLhoQReEi/0R5EceA
	 wRs3Lz+5R+qBs87awvo3r8GfMhbkPVBgyQnh8+pyTEg4Pi8Fc3PBrecyOtCBbI5qDjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fm16wjvE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B64A606D82F;
	Sat,  7 Nov 2026 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fm16wjvE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7741F008A2;
	Sat,  7 Nov 2026 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060972;
	bh=En8ss1IexT2DdvUjicn+KyUl5FWoaDpvGJBvaWEJnwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fm16wjvEYmEQuATgALZ5DS6HA2zfN0wvnMpLKI9nnAK0f61D+zlBXwWpr5clI3bPb
	 cfhlOZ7H74YNQjmsIKGGgrHuIy+hSsqNQg7ejB85Q+XDBvYgXMo++RC+OWE+arf0JB
	 viXwodXaCzSvvCPsjBm7fuTG1UK4j4lU0766r4ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Tatas <michail.tatas@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0325/1536] ipmi: Fix leak in __ipmi_bmc_register
Date: Sat,  7 Nov 2026 08:39:01 -0500
Message-ID: <20261107135006.844402553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa0a17ca07f01..bd4bfcfc65fd7 100644
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



