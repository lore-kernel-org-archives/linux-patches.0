Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632081A841F;
	Wed, 19 Feb 2025 08:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955508; cv=none; b=JkQRriKDYoSAAIm9rGuaysmdIhAnSaDkY9ngfNKJNqO6Q0IRhOJvpgg9M+uVaJ8NGw/9VGsPv512vgVYyjEow/1FxjmptNy2q2pd3TPcEM+eikxXe7vBGx1zrxweXad8a2tcNiuAQWnpXG8CvmOA/dOdhoxLTGN0pf36cJb0SYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955508; c=relaxed/simple;
	bh=7ydquqqzcfsehK1OnjgC9TtFt1GkVDeo6tnxiLNwZBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R4xGMI/N+Bx8zQs1DN/SFeHfqttDLODSRPT3fen2yREv5F0esjcUgldCQ0aD+xyuoOWZ6FL2PdPdC3UkLMX5uFYdw0gupowp3PsHRXopkQHsfm9HciaqHpLZQc+l28XsE9kc0gr46BPbK65cNOv3yfgeYVQXd2ruDkcjLqbbfcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrMRSmZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrMRSmZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E32C4CED1;
	Wed, 19 Feb 2025 08:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955508;
	bh=7ydquqqzcfsehK1OnjgC9TtFt1GkVDeo6tnxiLNwZBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrMRSmZgSyeqXxenYDBOsFaq7KUkYUK/xJqkp2H7azZp1P7nAtD2cfUndngS5cIlC
	 i5BhQzPNMPgjzVGywhsxObpljtCeqx5o6HR6bqDqrjWWiCwbywhepRaIM4oMg8SCfN
	 T5P29CGYp8kV2I1BDWfZXKsOliG+RDxbjugVV4NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c9179ac46169c56c1ad@syzkaller.appspotmail.com,
	=?UTF-8?q?T=C3=BAlio=20Fernandes?= <tuliomf09@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/152] HID: hid-thrustmaster: fix stack-out-of-bounds read in usb_check_int_endpoints()
Date: Wed, 19 Feb 2025 09:26:58 +0100
Message-ID: <20250219082550.237320190@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



