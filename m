Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD7A2B9C7;
	Sun,  1 Sep 2024 16:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208822; cv=none; b=MiL/Qw7G7lzo5znFqNrDaC4ZzBjhAR7Lpm7kuZRnZfU471HKd0gvKDwZYoYgf9+qiXWZoJ2rGrPTPQZrdvdQji+YjCkWySDQB11CDkhfI8Vp3aKPlP1lwjsX/MAHG5oCOgy/Br89ggaDKjpOv6n3oDTAFEspgAe9x2GhL67gPDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208822; c=relaxed/simple;
	bh=EQdYFzsn1Xv9YGwiu6QDIYSJ1fEYyrQSlDEpWr4lSnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUMIdivWOYgfTFsndd086yGKuu65a38WnFiu56pp+O22Om+d38lrm/vIvQhOWh7mK1n6cY+jN6xTs2MblKQLV0j0Oofvs18GDXELBPcXUgyuAJOyO7KNffocVtlyu/a1OCcO+anUNO3sSdCpF3Bh97/otTQOTGQ4eufwg0o5V34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FU4zDf63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FU4zDf63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3891BC4CEC3;
	Sun,  1 Sep 2024 16:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208821;
	bh=EQdYFzsn1Xv9YGwiu6QDIYSJ1fEYyrQSlDEpWr4lSnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FU4zDf637RV3i+x6G3aK7Q6bbj8/2qwzTRAh/zeiMZXbSjOU/4UtuEwSEN6DbEkEI
	 hNU0XrjaH/bq7oTm2HZNH/foRr1jz/ZWz3CmVVpTQ0Jyq5ORZQdey+Ej5HkTeegd7m
	 E9V/uTwjyzV3JOXXXImTfIgzHXqqNGUBmETR+d6A=
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
Subject: [PATCH 5.4 048/134] net/sun3_82586: Avoid reading past buffer in debug output
Date: Sun,  1 Sep 2024 18:16:34 +0200
Message-ID: <20240901160811.916014005@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1a86184d44c0a..e0c9fee4e1e65 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -990,7 +990,7 @@ static void sun3_82586_timeout(struct net_device *dev)
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



