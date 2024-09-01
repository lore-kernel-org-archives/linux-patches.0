Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6058A381BD;
	Sun,  1 Sep 2024 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210236; cv=none; b=epFOEbYFG0tjMc1sOOJLRFVdXMdwL/IvlV26dLDl7aQ/hIftJGbRfHVzr0bb7t5aEc7mAoxAK8fzpWORFnERpR/0rXjn2bO27tolDrxOuhELjavgABGfa2LY+VpepjSZEFMi5RzwFjKs9TZshDtLdMH2pfWJhyKCGSxK6WdYv9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210236; c=relaxed/simple;
	bh=XcBmceHjW7h10VFMLcERiz491Wjnu4CJiluDtjJT4Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJyb6SK5ZY/FST3ZwEnoeNms5C5u0RNhcmasEddO21Lpta6SFusDiXg+JxtgOMD12Usao/YoRpdBrXN8YtARTRpDbKur5FNQ+mswQM+Otxvpp+hCKLgRwxxBPae+izHsMzee+vuGMODL86/fmC3vRGCr5Z26WFzbVhfCH7ky9Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwIGl86P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwIGl86P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF755C4CEC3;
	Sun,  1 Sep 2024 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210236;
	bh=XcBmceHjW7h10VFMLcERiz491Wjnu4CJiluDtjJT4Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwIGl86PHQpI/qq+y3OD73yI/J2zby48c1ZvCZpshiT3x3c5FKfKlawPAcUK6/B4h
	 U5qqXguZP/ibJaQry4qsTZUqS2O5nnFbHo+1SMykg31zue9Tnyio10aYSbrWln0u8A
	 i7zwkt133pBH112v/W75DdejWdd/DSLMdV9qwbRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/215] dm suspend: return -ERESTARTSYS instead of -EINTR
Date: Sun,  1 Sep 2024 18:17:21 +0200
Message-ID: <20240901160828.242360679@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 1e1fd567d32fcf7544c6e09e0e5bc6c650da6e23 ]

This commit changes device mapper, so that it returns -ERESTARTSYS
instead of -EINTR when it is interrupted by a signal (so that the ioctl
can be restarted).

The manpage signal(7) says that the ioctl function should be restarted if
the signal was handled with SA_RESTART.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fd9bb8b53219a..8199166ca8620 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2255,7 +2255,7 @@ static int dm_wait_for_bios_completion(struct mapped_device *md, unsigned int ta
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
@@ -2280,7 +2280,7 @@ static int dm_wait_for_completion(struct mapped_device *md, unsigned int task_st
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
-- 
2.43.0



