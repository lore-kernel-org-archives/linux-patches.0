Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039962;
	b=zOyA4i6ij+wYfDmDTcKWUTk1YbmZ2gdDkQcKdq4woO5RUo+xuYk1gthR7exC482aIQuV
	 nNEfiZNdyfNHY9NdO0r9rf9l6kx8WmOWdq8MYyDLSnIoFGV4B+eoE2AJhB3g/f2Zp6FCc
	 78ZaUc7mubuKtDytxj9oyzuSSzh6+v6OvnaDcQgSVr2eHQhMSN0FMrWdPYg3dxXHri8sL
	 ZDdSHsdTG2G12rZO39ksYeupFPxGof8ktSTkvThVId6mU+zDfGoD+W66vQ6JrkI3KpcF5
	 6a/ZDNOxta0O/wQa8fJeQVfxXA7bBFs5kHZJHx4bu6xzzRfv9r6J+3/CgY2dN0a9yZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0eFPB8Yj+vsuWahLjYRJmHJlIUTrg4Nmxl1cdR8i5E=;
	b=wE9rqqVIomfuEwJrxdjCVPTrQO2nZsQMSRgCP9hsLepfbTAm5joS6UBOH/bAZ40PD31p
	 xUXRKridpc8y12auu1tSDWHkM33+QjMnhaA+gOnwkN0uPjuDuQ6ke/xQmvkTl0gIPoBBS
	 BCLv44JOA5YNoKUIi20mWXFq3MSf7LBN+8Y0VCmjLWl+W4gcibOaL4djPMQK5fPv10Ou8
	 6tJgTaf+ODcydJ4tB4M96tCanGqbKB0pcnPckELfiMl+t/MUnRdQpFSaSuK8vr7PTZkJ+
	 Irr82W8hTDbblTv6Wd1gFR02ae9tovNn0UjYfaNYoqwTai+elqKIfT14NuPo47crMrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVC22uPF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9ED606A31C;
	Wed, 18 Nov 2026 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVC22uPF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9CB1F000C4;
	Wed, 18 Nov 2026 22:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039961;
	bh=h0eFPB8Yj+vsuWahLjYRJmHJlIUTrg4Nmxl1cdR8i5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVC22uPF8rmAtlg7ZK22sZYuYzsL7/HPeqndCMqfUxv83vTEaXPx+L8wrLTxCFjaQ
	 136vFUBKqbWwrLHfILRotEVOg1qemU2nubOD3ew9iYG2uC59UCnPgGepopEgAidLXz
	 X8L9j/6fd1r/FB9xrjbsw0FgecdEuZtgh6OnJlG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2288/3318] RDMA/irdma: Fix erroneous -ENOMEM for large MR registration
Date: Wed, 18 Nov 2026 15:48:30 +0100
Message-ID: <20261118150430.393778243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 5bb710151753fe53047b1d34b1b54d0f179cec68 ]

Commit cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
replaced the explicit level1_only boolean with a bit mask
but did not properly convert the "if (level1_only)" check
in irdma_get_pble() to be "lvl == PBLE_LEVEL_1" and instead
left it as "if (lvl)".

User MR registration passes "lvl = PBLE_LEVEL_1 | PBLE_LEVEL_2"
so this check always evaluates to true and causes the
loop to bail after grabbing a single SD even if the region
actually requires more than one SD (as is the case for
regions larger than 1 GiB with 4k pages). As a result, these
registrations can fail with -ENOMEM even if there are
sufficient PBLE resources.

Fixes: cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260915170317.2901672-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index c7bcdc1bf9319..6fb3424b45331 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -474,7 +474,7 @@ int irdma_get_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 
 		status = get_lvl1_lvl2_pble(pble_rsrc, palloc, lvl);
 		/* if level1_only, only go through it once */
-		if (!status || lvl)
+		if (!status || lvl == PBLE_LEVEL_1)
 			break;
 	}
 
-- 
2.53.0



