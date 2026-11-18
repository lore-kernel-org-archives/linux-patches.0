Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024057;
	b=4olAxdC3r4hybZ2P47+jZu9yO7W5nGsepgpXXy77L2bIBcacHyjCojZr/fA87iPn/Ght
	 JqeQWecuGcgOu6zoGNfVmAVJWJmQlbCcChELLP4QNwnfAl0lnPSFWp233Aao4A20/EZuC
	 lyq1rg7j6aDDZx8CmG9tvqcjCyjKZ2dkEH7LwByfJEjMGb2NoDlJqNvbIAVVWu5NOx8H1
	 B/sogoSMFmHEMNiCuoDJBmCFiAf4v7DI3R0BwVfieyQFt9WsLrkYBsasKMy8ucDSqM1f1
	 X/O2D5Z3XplZpw6xta2ghKbH6gnG6WY8g7dlN1ePqPa7sLS0r0/LTcSeRhaL/esv8yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Irqy47sZYQOg7PA/sFc/HGaXMVUU4+OSUag4nlFZGTs=;
	b=WadCU3MdnfUMA67Da53+uBkJ9+afSiXIYZPqzqIrzfuQvp0tyipXjKt9p9pUPWBbIcpS
	 QnArGEy6oDGfeRpDs9uOT+FYMAbvo5bD7LFLpshdbpQamuoM3Sd8gI6lkl+euODooe4q+
	 wfI10CWKh0MKJaXyAZtja5ucVzmOqN8ol3qnsThkj8TPCQaTCLP0EmjBiVQ/FTO9VIXW8
	 /YB4DTUpDrnHUKr09YRr15AYT0uThr5LHwdpv4JVHiUkmKzBOrxUHdv5QGtxXbqDsRe3J
	 vSAcrVL+Zdbrn9m88MPP2xkK2kvqwMt709qVQtmIb0hSvScjG47hy15ktGoEoQEr8Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Re4sP/G7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E6D606A31C;
	Wed, 18 Nov 2026 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Re4sP/G7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE6D1F000C4;
	Wed, 18 Nov 2026 17:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024057;
	bh=Irqy47sZYQOg7PA/sFc/HGaXMVUU4+OSUag4nlFZGTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Re4sP/G7TEeyRL0u9FIbrKXiKIOd6Exyf9wlHLJN5c8ZxTM3rNpenVVQdQUWOTP4K
	 sLMheTw2itQgTFuWyTyNmdHqccIESJeQxcPp4sfsp4LWi0gk+RAk02MM2YSfgZk4Ov
	 lJdAudaFyhMqWHwo7/KBwflve3MTBfwOT+Cfms7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0589/2151] RDMA/irdma: Fix erroneous -ENOMEM for large MR registration
Date: Wed, 18 Nov 2026 15:38:44 +0100
Message-ID: <20261118150143.409985203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 28dfad7f940c2..14318af97d581 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -482,7 +482,7 @@ int irdma_get_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 
 		status = get_lvl1_lvl2_pble(pble_rsrc, palloc, lvl);
 		/* if level1_only, only go through it once */
-		if (!status || lvl)
+		if (!status || lvl == PBLE_LEVEL_1)
 			break;
 	}
 
-- 
2.53.0



