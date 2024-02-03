Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62085101C1;
	Sat,  3 Feb 2024 04:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933400; cv=none; b=U6PrR0h6+uDpxtNjrn2g+sthoCPWfb4bHj40Zdwg6preN5CU342N7MpT1ZuC2WsAtuDbbTPtF1duJ7nTZ260RbEd7ywag+pQE0VWRHoKep+r98fS/8coiMvF/XpN26j5xBr3WQfNTCDtetJRetn00eHXm5x5LVZ+1jE7E3CQBZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933400; c=relaxed/simple;
	bh=RuyO6NHgT/Eqm3/+Sb6k6JszX/VdV7sBbcN2nQN49pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMbrbe0iyHifNEQKp2ezOkKGQgsQY9OWzOMfqlXSZdbB3jk4NjuchasFxMz/guGFFpyOorC+KRkuTkZhJrQDL/lFwxjzb3LGeV+E16g7/oG00rvWe+xnwkvCIUWTWEl74gCFnS3qwZn2OWeIuS0h8WWNQxmuOdBckx15QLGawdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YANeg6Z7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YANeg6Z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E13C433C7;
	Sat,  3 Feb 2024 04:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933400;
	bh=RuyO6NHgT/Eqm3/+Sb6k6JszX/VdV7sBbcN2nQN49pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YANeg6Z7C6m1jyRQpXj58gwytHxtlRmVtOnd8vn6Cidr4geP3HqN33gsJsEsfl5pj
	 +Sce+EV3RdRon6+aEzS3T1fHBWgRBEfQQaaZkjTbel46Wk58+R0I9tQimKYqbWMvW7
	 NLFgGTjIMyfN/ZtwpHzDzOnoF6n/oYvBfHWni0vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Potter <phil@philpotter.co.uk>,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/219] media: stk1160: Fixed high volume of stk1160_dbg messages
Date: Fri,  2 Feb 2024 20:04:50 -0800
Message-ID: <20240203035333.961526352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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



