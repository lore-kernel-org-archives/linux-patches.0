Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E181C5792;
	Tue, 27 Aug 2024 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772340; cv=none; b=XVf0zFN9kTMUGMYRjiy4zwtz4USsuWiFZrHuu9FVzAGJoR5CIGKTlO7bTEoO9JyDhDb9Fs+hQAD6EPUSO7vDwfe47rufZKJyzDalINm/vzEyThg8/QfrlnwJuseqZpiPZyckkIIC0UavZf+nxqd+AOD8HKCdfMHjoMot908DfaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772340; c=relaxed/simple;
	bh=QudX2prelyG4mCFCLJNHTNfH83cwbhUCPrNLYFL9QNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cERdY+Lhv1V8p2wLugI5LH2rVQ9wFUG0JNUzlPRNBadE9YVMaghNIYPZLVlxzjdG9WXxuzt+zQjvAUguQz1w51g/r12+RAHOaL+lJBywZSUZWtB2FVgx8fI8s4UnVQQh5ERO8vDrmINMxuxW2WHwsuP/S3yfGGJ7ZcF+8tlNhpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=schROpee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="schROpee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E033C61071;
	Tue, 27 Aug 2024 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772340;
	bh=QudX2prelyG4mCFCLJNHTNfH83cwbhUCPrNLYFL9QNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=schROpeemQYUFPBC2+wVU66DLlAcmXHyDCkY/XCxoR4QClnfldZnAjZsDWOMB5Cpx
	 7aoYWUkH+CtVOSvh5SdH59YIakl1Zs4gviNOYPVF+LwwB3GoPSPQzYeVLF8zhFZIt9
	 gewD8ONBGhvKv+1rZEpWoeyzUfc6k3ur3mFwBsvs=
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
Subject: [PATCH 6.1 168/321] net/sun3_82586: Avoid reading past buffer in debug output
Date: Tue, 27 Aug 2024 16:37:56 +0200
Message-ID: <20240827143844.624888261@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3909c6a0af89f..72d3b5328ebb4 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -986,7 +986,7 @@ static void sun3_82586_timeout(struct net_device *dev, unsigned int txqueue)
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



