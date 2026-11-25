Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621048;
	b=Sm6bcbWeAvq/CHOGwz+CQRSJ0IWX/ZcjJeXC8ah+f5ydTuifsXX/9lcB/VuzF5SfPY0e
	 pb0we2QXHsP+K/1EW0bNsa5teh0Wn8wm+80A1igwv9upUqn/ripSsSm3d+vnTP0GStiSc
	 LUo8eeHv9oFpgFGfXKL8bzmlfq+cHdbF3ktL/Z0B12jSJW2rIuAVx1sksXDlqxi4J5RDn
	 ZG96eBbdwI5j8XJeVK/8bNMvHiP6hkdbxALWYjDixQRJm2iql6dmRGpYSjjjzzSMmzd4G
	 +Cc5KzE7yQ7/EjtaS3dM3AO/XNiFntlJIh4FS7QfQOcSC8R/4EK+IdJRTjqhoWwvstg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=icA2uXMrdf6bm74X/Sl71MFVm/YmfZi0zx1mDVLMNSY=;
	b=yvW4FsyooTcYXsS0o3V4zgUAP14rTMSWInweHqVSgG70+uhxjNVxheH72ZOnAjBXNNiA
	 Fd6DxYtPox8nE1EAr1mz6mpay/CgV0x10P3QvGR0HkYoDEYfel+WDFUuAEAoTydpAA0Fd
	 +ZLm6Wg2arqR8uSN1Y7d9TE42sj54M1P5UxMF4BpPYBe51GUg8zTnDWu/yCRvEQ/bo1Yw
	 t45p+Nx7CD+SA99V3On+qC1FSRJdHAF2SEyQh5TjOFK1HDV2mVt3q9w14R9eHKRdgOteI
	 prDn3NdGRvdiVXL+I5cbKAxxqyt6AYZdlslTj68oGwrOGch54QoqlTzy76ktVRIPnsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPHtz+6Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B533606A69C;
	Wed, 25 Nov 2026 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPHtz+6Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37D61F000ED;
	Wed, 25 Nov 2026 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621048;
	bh=icA2uXMrdf6bm74X/Sl71MFVm/YmfZi0zx1mDVLMNSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPHtz+6QaiWDR6Kkb+s+6tAAviHX9p/4ecLLtJTK5A1lskvHw9gpFOIjQKexQXv9M
	 jg7hCvdgn+vTIhsx778WCB+hVbFfPBZfrtDjt3208juxh8U+qBu4o5rKDo7NhNVl2t
	 TXpKDO8l79iNyl5SQnNeylzbQpEe7ODOrLP7nbMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/990] net/smc: fix limit_smc_hs sysctl on big-endian architecture
Date: Wed, 25 Nov 2026 15:24:29 +0100
Message-ID: <20261125143824.479144173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 162cf592b577cccf04515100563e819d9eba5c4a ]

net->smc.limit_smc_hs is a bool, but its sysctl entry uses
proc_dointvec_minmax() with .maxlen = sizeof(int), so the handler
accesses four bytes at the address of a one-byte field.

On little-endian this works with the extra bytes being written in struct
padding. On big-endian (tested on s390x) the bool sits at the most
significant byte of the int therefore the bool stays false and the "1"
goes into padding. The sysctl reads back 1 but SMC sockets created
afterwards see limit_smc_hs as disabled.

Fix this by using proc_dobool() handler and adjust the maxlen to the
right value.

Fixes: f8406a2fd279 ("net/smc: add sysctl for smc_limit_hs")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20261028225350.3753-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_sysctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index 2fab6456f7654..7da98bd5287ae 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -93,11 +93,9 @@ static struct ctl_table smc_table[] = {
 	{
 		.procname	= "limit_smc_hs",
 		.data		= &init_net.smc.limit_smc_hs,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(bool),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.proc_handler	= proc_dobool,
 	},
 };
 
-- 
2.53.0



