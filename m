Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C341DFD1;
	Sun,  1 Sep 2024 16:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209496; cv=none; b=jc7jRypiqQdn6voSSqAmTcrci4i97BWBIFyvSXYHVMYwCjPG+LlxZJP2+DNznA8El+JHfGgts24yJW2qfIXij7DqhAIxLrIwqZmkgQrsUc5onZ7Nq/+DqXj6Hf6X4/M7Y7JVR4llxPMb79WGOGMF9YVb+1geK+EtzrWaCsrMy5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209496; c=relaxed/simple;
	bh=B2vPQ0ieU62tx3tluclJ96801ZupA/DL+OBTYLTjLzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjM8KVvD2KcduPA1IWzUbtDXZpP1Qn1eu+ci7Z6DiQrUyWJWWcv7yTjbR0TeFA7GecsVMClexFEMvQOPK8/cFmLEzBWYp7zWjBDy6qjQTpHvI9VsuRcOt0wt7R1NEGiGbYd/MNWNzgEPPFTnadNPurwZYfsy1MoSgYpjCkwUn6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWMIsiUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWMIsiUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2707DC4CEC3;
	Sun,  1 Sep 2024 16:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209496;
	bh=B2vPQ0ieU62tx3tluclJ96801ZupA/DL+OBTYLTjLzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWMIsiUEoyldx3gO9Tdq7ZMSkZkU+/CQHfVUWm4VugJTSrbC/vsxLo9H+3Dl6YRJ0
	 Uu/xDkTTIufytHEagsFxOKKS/k4FHuV52oFlt0VlbmblF6BE2ropiQoawPgESCadtA
	 ywn5v2gKitFG//PaTFL2EV+rX1T1PkkhZ72ExoT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Creasey <sammy@sammy.net>,
	Kees Cook <keescook@chromium.org>,
	Simon Horman <horms@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/151] net/sun3_82586: Avoid reading past buffer in debug output
Date: Sun,  1 Sep 2024 18:16:54 +0200
Message-ID: <20240901160816.151199414@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 4bea747f3fbec33c16d369b2f51e55981d7c78d0 ]

Since NUM_XMIT_BUFFS is always 1, building m68k with sun3_defconfig and
-Warraybounds, this build warning is visible[1]:

drivers/net/ethernet/i825xx/sun3_82586.c: In function 'sun3_82586_timeout':
drivers/net/ethernet/i825xx/sun3_82586.c:990:122: warning: array subscript 1 is above array bounds of 'volatile struct transmit_cmd_struct *[1]' [-Warray-bounds=]
  990 |                 printk("%s: command-stats: %04x %04x\n",dev->name,swab16(p->xmit_cmds[0]->cmd_status),swab16(p->xmit_cmds[1]->cmd_status));
      |                                                                                                               ~~~~~~~~~~~~^~~
...
drivers/net/ethernet/i825xx/sun3_82586.c:156:46: note: while referencing 'xmit_cmds'
  156 |         volatile struct transmit_cmd_struct *xmit_cmds[NUM_XMIT_BUFFS];

Avoid accessing index 1 since it doesn't exist.

Link: https://github.com/KSPP/linux/issues/325 [1]
Cc: Sam Creasey <sammy@sammy.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org> # build-tested
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20240206161651.work.876-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/sun3_82586.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
index 4564ee02c95f6..83a6114afbf90 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -990,7 +990,7 @@ static void sun3_82586_timeout(struct net_device *dev, unsigned int txqueue)
 	{
 #ifdef DEBUG
 		printk("%s: xmitter timed out, try to restart! stat: %02x\n",dev->name,p->scb->cus);
-		printk("%s: command-stats: %04x %04x\n",dev->name,swab16(p->xmit_cmds[0]->cmd_status),swab16(p->xmit_cmds[1]->cmd_status));
+		printk("%s: command-stats: %04x\n", dev->name, swab16(p->xmit_cmds[0]->cmd_status));
 		printk("%s: check, whether you set the right interrupt number!\n",dev->name);
 #endif
 		sun3_82586_close(dev);
-- 
2.43.0



