Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA1617C64;
	Sat,  3 Feb 2024 04:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933603; cv=none; b=p/N4GWdpAa87mVYm3SuJelfG0XAkwlfIQGI1hQkQKJPaJgY9FDbVA5VijpT3aUBka/RK7hiZfOZcPeOGYmmocH5IEqLxylXjTNQ0pU1e2VcLdeS2i0Hf7F+K06RZ/KQ62BpspuPCD/kbxk97Y395ASlA6pTx+oJOYfVOlq4xWxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933603; c=relaxed/simple;
	bh=56UJMT+ykNLn6ZvWkx4d1869VadeNFAwAPfhlX8a5aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipFCyOTodEvg3gNJClBrT8Md1ICsVXw2tI1KtEgTM6Mo6Qo7DgQ/MjqSJ2nV10nFUypszcC/CIl0RWdxLSS5Rf/C4eS+EEQsMIbNxy4xhSpawGuiarNt+4t4fIVFE3cc/4vtAoYEomXYm4w9v1jdr5g3KYeSCLOfXg2377twIn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6+hY1ND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6+hY1ND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEEFC433F1;
	Sat,  3 Feb 2024 04:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933603;
	bh=56UJMT+ykNLn6ZvWkx4d1869VadeNFAwAPfhlX8a5aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6+hY1ND8KPbAtcrd3/4YrKJ5NTv/vVtO5n+D9kHnG8QCzMfJu9D7+kxHGR5Dh76/
	 4cRQU4oxYIrEMDNYeJaZulIsG+w0zvxWisc4cAsD+AklfvTTD+pieFomm/bw/zxMEX
	 ixYbLP+tm7M3qujoMVAgIkENNQ8o+AkeUk1F/v84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Potter <phil@philpotter.co.uk>,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/322] media: stk1160: Fixed high volume of stk1160_dbg messages
Date: Fri,  2 Feb 2024 20:04:29 -0800
Message-ID: <20240203035404.802324920@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit b3695e86d25aafbe175dd51f6aaf6f68d341d590 ]

The function stk1160_dbg gets called too many times, which causes
the output to get flooded with messages. Since stk1160_dbg uses
printk, it is now replaced with printk_ratelimited.

Suggested-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/stk1160/stk1160-video.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 4e966f6bf608..366f0e4a5dc0 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -107,8 +107,7 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 
 	/*
 	 * TODO: These stk1160_dbg are very spammy!
-	 * We should 1) check why we are getting them
-	 * and 2) add ratelimit.
+	 * We should check why we are getting them.
 	 *
 	 * UPDATE: One of the reasons (the only one?) for getting these
 	 * is incorrect standard (mismatch between expected and configured).
@@ -151,7 +150,7 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 
 	/* Let the bug hunt begin! sanity checks! */
 	if (lencopy < 0) {
-		stk1160_dbg("copy skipped: negative lencopy\n");
+		printk_ratelimited(KERN_DEBUG "copy skipped: negative lencopy\n");
 		return;
 	}
 
-- 
2.43.0



