Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022062;
	b=V2IKWq6mr6UmHMmqWOdBHX4Z7ROSlN7y68OmZwOVtzTCuKBUWgcwedjDeWrKdfFY1liS
	 s9itb80XqTYcCIq+uTV4TxB/uoeuwoUJuqTJq9pCtG9Ud77MXwp7a7UdP+w+vczgMERIk
	 bSjJ0wOP5Me1+Bfv8H3kHT9ZP9tpbdohsVMKP8n5HRLmvsLBCGsN/ZWVF3bLvTRgv2muC
	 AZ/40m0rcWFJ6yc1yJlpzTS8cbJoZLjtyv0kGOuLbIPfLZhFZPMllY9KvBI71a07nMZ/3
	 shabxwamt4eHyR7LQuUWiprUofSg0G9glmNHzEPqrJJNRdVirf42+NiqrTQvPfeg2wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HaJcE1qMmvVG7vONlTIeQ8dPV7CkhvOFygCx6/2EDP8=;
	b=CFYnI+9Oe7CXzxsGNpcHNMcxVqcRciWZwvjHJqDcWkS6+Q8OZuUdYajvr6b8zuZAQ1iy
	 xgPO2BWBUNMhNBFiGLl7CsA52N32UFRpTRClpabYiMjayeJMxgCrb7EbL1Uu+K7ckn6T8
	 zQX/9dYiN0L6tB02aLAEHJNH+8jKKSCL0ZjCxV+N5L2MHAys579jGgrrlpB29Z7apvPr4
	 trAeKEl8CQCwkKh/Y7dTr+Qt76bX8j2q0OZ0AE0c822AwMoPOwMiPjmjPhiJDlYMObQkj
	 pCxXV07kQbmSRgxpN943H/DT93S9auNL4/nOg8O+d5v10gzNMuO7nfynGn8ObxSL7mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgKdoHzF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169B4606A31C;
	Wed, 18 Nov 2026 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgKdoHzF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD1B1F000C4;
	Wed, 18 Nov 2026 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022061;
	bh=HaJcE1qMmvVG7vONlTIeQ8dPV7CkhvOFygCx6/2EDP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgKdoHzFIQzpYG5DwxZTXmPlnzNGKj7D7iqj++8zbRMHc5arrtUYeynMaErzFguJr
	 /ObwXS8i25RLJ4tlu66K1xd94exQnon3OLxxJ9hdiVuQJf9gQd1psDGd0VA3Ya2ce7
	 T0508sLok2l4eGhVRJiogvtbEfexdkR0BW0r3/GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2527/2651] nvme-pci: fix early boot hang with nvme.quirks parameter
Date: Wed, 18 Nov 2026 16:02:47 +0100
Message-ID: <20261118150415.618436522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit ed75528c095bc7760a3cf34a3f3e2ec7a59eb285 ]

Passing nvme.quirks on the kernel command line causes a silent boot
hang when the NVMe driver is compiled as a built-in module.

This happens because the parameter is currently registered using
module_param_cb(). For built-in modules, this macro flags the parameter
to be evaluated at initcall level -1. Consequently, quirks_param_set() is
called before the memory allocators are initialized.

Fix this by replacing module_param_cb() with device_param_cb(). This
defers the parameter parsing to initcall level 6, guaranteeing that
the system memory allocators are fully functional before the quirk
string is parsed and allocated.

Fixes: 7bb8c40f5ad8 ("nvme: add support for dynamic quirk configuration via module parameter")
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b7c5a18b899b9..eb74bd8838f2a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -243,7 +243,7 @@ static struct kparam_string quirks_param_string = {
 	.string = quirks_param,
 };
 
-module_param_cb(quirks, &quirks_param_ops, &quirks_param_string, 0444);
+device_param_cb(quirks, &quirks_param_ops, &quirks_param_string, 0444);
 MODULE_PARM_DESC(quirks, "Enable/disable NVMe quirks by specifying "
 						"quirks=VID:DID:quirk_names");
 
-- 
2.53.0



