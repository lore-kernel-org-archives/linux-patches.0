Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CC11C3BE9;
	Wed, 19 Feb 2025 08:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954709; cv=none; b=Ez3sgvqQGDG591RkJzOuE5Bd9+O0SgMvDzd/ZvezJ15ibI/QgHVynjHtLvszA/dIdEKcr3se90J5dXOkxfPGRANzXDaNe7fiRUqdifgeVroG+1H+mjLhToroRR002SFYsddAFNImTdXtGiJzgsz0aBxd9JkjOPoP4CXUv0LLaIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954709; c=relaxed/simple;
	bh=wnMmWrt61OWjcpYgQMGMKaROdNWBOIyqbARXPZBxn1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGdrP8+wt6PHpuphdIQK0m4s3mJ3fFkkiMkWANv08OQdwKUJG8C/n5pzhIGwwINXVar40JH1SvJF+cxKwblyoW9oTWAtoU7eZhaeuRmvpnsLOqVyCZ9Cl0mDmMGr8mymOB/kzu2JlEgwoAnxIbl6OCI6dVP1K9N3KWdNdW/ydaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqxFtofM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqxFtofM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A773AC4CED1;
	Wed, 19 Feb 2025 08:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954709;
	bh=wnMmWrt61OWjcpYgQMGMKaROdNWBOIyqbARXPZBxn1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqxFtofMYHPIHMyOgkvFbuZEhb+FmjRtp9+E653RE/Ex76xglqpItln6t2wiohvyJ
	 rdoKv4zQbPtYOhAYeAc4p+nj7BVMc4lsoGTR0/f4SzwsNzbDObl2v9ehF+X80InRBd
	 s15ao4Gdd4a96z9tUZ+XR2IM2+zzWs0xoLTkdOv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c9179ac46169c56c1ad@syzkaller.appspotmail.com,
	=?UTF-8?q?T=C3=BAlio=20Fernandes?= <tuliomf09@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/230] HID: hid-thrustmaster: fix stack-out-of-bounds read in usb_check_int_endpoints()
Date: Wed, 19 Feb 2025 09:25:30 +0100
Message-ID: <20250219082602.219392742@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tulio Fernandes <tuliomf09@gmail.com>

[ Upstream commit 0b43d98ff29be3144e86294486b1373b5df74c0e ]

Syzbot[1] has detected a stack-out-of-bounds read of the ep_addr array from
hid-thrustmaster driver. This array is passed to usb_check_int_endpoints
function from usb.c core driver, which executes a for loop that iterates
over the elements of the passed array. Not finding a null element at the end of
the array, it tries to read the next, non-existent element, crashing the kernel.

To fix this, a 0 element was added at the end of the array to break the for
loop.

[1] https://syzkaller.appspot.com/bug?extid=9c9179ac46169c56c1ad

Reported-by: syzbot+9c9179ac46169c56c1ad@syzkaller.appspotmail.com
Fixes: 50420d7c79c3 ("HID: hid-thrustmaster: Fix warning in thrustmaster_probe by adding endpoint check")
Signed-off-by: Túlio Fernandes <tuliomf09@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index 6c3e758bbb09e..3b81468a1df29 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -171,7 +171,7 @@ static void thrustmaster_interrupts(struct hid_device *hdev)
 	b_ep = ep->desc.bEndpointAddress;
 
 	/* Are the expected endpoints present? */
-	u8 ep_addr[1] = {b_ep};
+	u8 ep_addr[2] = {b_ep, 0};
 
 	if (!usb_check_int_endpoints(usbif, ep_addr)) {
 		hid_err(hdev, "Unexpected non-int endpoint\n");
-- 
2.39.5



