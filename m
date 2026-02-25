Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85A22D3EEE;
	Wed, 25 Feb 2026 06:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002733; cv=none; b=eNJBtnNA7TqNi2DMRR//xlv2YPQENzvHI29UoumWMFH3xZskofMBaEfy30f0vW1EpuLD+OWD+Fv8tiNw8+QDWWxLAZXfmOZ+SmPnp4D8wKeUKHnGL2iWbHDaXlRq9HivfGaDgvXRdmeQD0g+7Kq6bxArXdHn7cK8dSR/hMzLUj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002733; c=relaxed/simple;
	bh=1qBglaaCz/JRoiv/bzKzsqD8/0nnaFVclscpoV0DEUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gu0xOAmrHN4wIY3epipv5aDw5ZqQHSE0uTk971s2o6MMNqc3xdqIOMnD1hnmf2MYz+Hb2bSuTtdcdUd3YSnZDOQwi/iwDRaGLRS8t9IG71NdAHDNA/1RBc/PAlXfBWfiie6QCVKgSMQAJ6VWqqgVTgP/M9T0LXUzGodIPQp5f3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwI6rpuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwI6rpuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF99CC116D0;
	Wed, 25 Feb 2026 06:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002732;
	bh=1qBglaaCz/JRoiv/bzKzsqD8/0nnaFVclscpoV0DEUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwI6rpuDQtnT/znr7AfHJhADp5087fssQFkZfenDhkKGx+/C/1GnTEiumLfd2RT4m
	 IsXbl+l7KpZSboTg3GLk54r5NjWxtkOhYeg65zoqvx0R6192PeTdFalUwjJ3d9hSGF
	 5AMA1bz3I14chzD1DhoPD9NGwvC4GIq0qND3dSH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Simon Horman <horms@kernel.org>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 547/641] net: psp: select CONFIG_SKB_EXTENSIONS
Date: Tue, 24 Feb 2026 17:24:33 -0800
Message-ID: <20260225012401.783119615@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6e980df452169f82674f2e650079c1fe0aee343d ]

psp now uses skb extensions, failing to build when that is disabled:

In file included from include/net/psp.h:7,
                 from net/psp/psp_sock.c:9:
include/net/psp/functions.h: In function '__psp_skb_coalesce_diff':
include/net/psp/functions.h:60:13: error: implicit declaration of function 'skb_ext_find'; did you mean 'skb_ext_copy'? [-Wimplicit-function-declaration]
   60 |         a = skb_ext_find(one, SKB_EXT_PSP);
      |             ^~~~~~~~~~~~
      |             skb_ext_copy
include/net/psp/functions.h:60:31: error: 'SKB_EXT_PSP' undeclared (first use in this function)
   60 |         a = skb_ext_find(one, SKB_EXT_PSP);
      |                               ^~~~~~~~~~~
include/net/psp/functions.h:60:31: note: each undeclared identifier is reported only once for each function it appears in
include/net/psp/functions.h: In function '__psp_sk_rx_policy_check':
include/net/psp/functions.h:94:53: error: 'SKB_EXT_PSP' undeclared (first use in this function)
   94 |         struct psp_skb_ext *pse = skb_ext_find(skb, SKB_EXT_PSP);
      |                                                     ^~~~~~~~~~~
net/psp/psp_sock.c: In function 'psp_sock_recv_queue_check':
net/psp/psp_sock.c:164:41: error: 'SKB_EXT_PSP' undeclared (first use in this function)
  164 |                 pse = skb_ext_find(skb, SKB_EXT_PSP);
      |                                         ^~~~~~~~~~~

Select the Kconfig symbol as we do from its other users.

Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20260216105500.2382181-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/psp/Kconfig b/net/psp/Kconfig
index 371e8771f3bd3..84d6b0f254606 100644
--- a/net/psp/Kconfig
+++ b/net/psp/Kconfig
@@ -6,6 +6,7 @@ config INET_PSP
 	bool "PSP Security Protocol support"
 	depends on INET
 	select SKB_DECRYPTED
+	select SKB_EXTENSIONS
 	select SOCK_VALIDATE_XMIT
 	help
 	Enable kernel support for the PSP Security Protocol (PSP).
-- 
2.51.0



