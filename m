Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1164864CF8;
	Tue, 23 Jan 2024 01:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975061; cv=none; b=W/xUnl9FlEqxqwTORjNlS4jac4pGfXMgq+4LS0H8rYKoqza+BLQXfS2GzP4dDFF5/0t3R++6eWAb3vBHuskTme+y0MfJK0wZBBL60mD/n4mHLdMv1WVq4OwbrvUr5kLh6WcMR0qYBhGrLswP2F/T6ZZxX1J9NC4gXXgHvADWzz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975061; c=relaxed/simple;
	bh=C8AATrsp6tPzT/ZlyzzF8GUEF07sJ1o4vtqacV/mRws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7fT4aP3/v+o3VN7vl0j352RtNgMz/x5R7iRhgtdj+OgQv2xnVLgfl3WOiF9SSWrZKssRMEVddKddi+TptAAqotJgDVzaM42Twgjd/ZeK0RDMDnG1NtKbWVtlaDidwVocYAHV1mbu4PChUUrcrjs6oUaoBgFj+F+bYZaoIccyd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+CfvGzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+CfvGzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8714C433C7;
	Tue, 23 Jan 2024 01:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975060;
	bh=C8AATrsp6tPzT/ZlyzzF8GUEF07sJ1o4vtqacV/mRws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+CfvGzgqa5+GBEb+KtkPpFlTU1gTscB+nNDai6I1ep6s9DbqVULHxaO0bWq0rAl4
	 wje+7N3T8GQxv8TJLutS1ZDkADszZU3YTjxNszJWfXHscmtFUN4MrXqVOiTR5MAc47
	 VGYtURCerWc0UM7plwPD3Rq6cupWhX0UDPRcEQF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/374] usb: cdc-acm: return correct error code on unsupported break
Date: Mon, 22 Jan 2024 15:59:36 -0800
Message-ID: <20240122235756.020021292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 66aad7d8d3ec5a3a8ec2023841bcec2ded5f65c9 ]

In ACM support for sending breaks to devices is optional.
If a device says that it doenot support sending breaks,
the host must respect that.
Given the number of optional features providing tty operations
for each combination is not practical and errors need to be
returned dynamically if unsupported features are requested.

In case a device does not support break, we want the tty layer
to treat that like it treats drivers that statically cannot
support sending a break. It ignores the inability and does nothing.
This patch uses EOPNOTSUPP to indicate that.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 9e98966c7bb94 ("tty: rework break handling")
Link: https://lore.kernel.org/r/20231207132639.18250-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c        | 3 +++
 drivers/usb/class/cdc-acm.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 82b49aa0f9de..d5191065b6e9 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2514,6 +2514,9 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 	if (!retval) {
 		msleep_interruptible(duration);
 		retval = tty->ops->break_ctl(tty, 0);
+	} else if (retval == -EOPNOTSUPP) {
+		/* some drivers can tell only dynamically */
+		retval = 0;
 	}
 	tty_write_unlock(tty);
 
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index adc154b691d0..f21fd809e44f 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -896,6 +896,9 @@ static int acm_tty_break_ctl(struct tty_struct *tty, int state)
 	struct acm *acm = tty->driver_data;
 	int retval;
 
+	if (!(acm->ctrl_caps & USB_CDC_CAP_BRK))
+		return -EOPNOTSUPP;
+
 	retval = acm_send_break(acm, state ? 0xffff : 0);
 	if (retval < 0)
 		dev_dbg(&acm->control->dev,
-- 
2.43.0



