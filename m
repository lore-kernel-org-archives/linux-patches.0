Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2FD7B3ED;
	Wed, 21 Feb 2024 13:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521409; cv=none; b=pzyeA7drh9aqgnO3SNpv+0I0KQuBML/V1ZUIeJV+0kAEMy4ZYEjUBaFlNrMyIiZA++dgvv5od5HPlXrsEaioQDhcxsLkHPiJKnk9grgK6SA/UIY2JZ9ITfwAm3dh73HVHJPoU3ub5u4eDB/e4KY3ZbqrlKTh4dLjkLwcPdaOAG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521409; c=relaxed/simple;
	bh=UO8CwfT6M8vRFgaLLCzGCGCGlLqsISTKCJqQGi6CgPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNAJb+ZeL7+0umBp7GbEVfwHgkNYVSCIvWVkzDdglyzM5YtzGjr7HGoviEfJE4dgVj8sEsZDXaTVGhhu5EeHOU9xwGtNVr/rpjeEd2r9YRPFCcrkGlsGiIJFx8vNo3TLYXyxTxaCJscC+cATUVmocm87P1cBQuOx0wlCnYRJTxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIAOqFtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIAOqFtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91730C433C7;
	Wed, 21 Feb 2024 13:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521409;
	bh=UO8CwfT6M8vRFgaLLCzGCGCGlLqsISTKCJqQGi6CgPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIAOqFtUjQ8WNdHAmoUNR6Z7X4PAwKIztI1nktCc/HOmc0yRynyKOdU6bNFQ5/a2a
	 dzlZbPlt0WzDN+m58euOQN/JVdRSehzSFBTsLNAoACTV41rZvmrP1LvfEKjQ3vWrqr
	 PEoDGYv+ZXJH79BnGDyKjONKr1oY9GHQgV4FBAOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Potter <phil@philpotter.co.uk>,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/202] media: stk1160: Fixed high volume of stk1160_dbg messages
Date: Wed, 21 Feb 2024 14:06:44 +0100
Message-ID: <20240221125935.092075409@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2811f612820f..0e98b450ae01 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -117,8 +117,7 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 
 	/*
 	 * TODO: These stk1160_dbg are very spammy!
-	 * We should 1) check why we are getting them
-	 * and 2) add ratelimit.
+	 * We should check why we are getting them.
 	 *
 	 * UPDATE: One of the reasons (the only one?) for getting these
 	 * is incorrect standard (mismatch between expected and configured).
@@ -161,7 +160,7 @@ void stk1160_copy_video(struct stk1160 *dev, u8 *src, int len)
 
 	/* Let the bug hunt begin! sanity checks! */
 	if (lencopy < 0) {
-		stk1160_dbg("copy skipped: negative lencopy\n");
+		printk_ratelimited(KERN_DEBUG "copy skipped: negative lencopy\n");
 		return;
 	}
 
-- 
2.43.0



