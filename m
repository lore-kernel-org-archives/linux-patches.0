Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87AB133435;
	Tue, 23 Jan 2024 01:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971897; cv=none; b=i3QIHa63tpMLjaV4geJWEPXC0uiJUvChj0z/2d3M6q9r6cnijbQsXvzArYSGy971veka47SoDSLF70rFa2Uyh6k1jxX+rNfKjCtrrpTOyhJEpG3ejxgcFkfkNUXRF6XHRjiRVKlEuIi/1PFy3H7oRnpdXfAuCNexTgQj89J3Aqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971897; c=relaxed/simple;
	bh=hNAmJQTfZZANgKCYQ5hiflbCTEKPNgpqLgd98YnHWXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPj+xtEEgWwZdlfD/EJP0iFHjSYOQQDzQVRRSMVw8sjAfhz7kqKpXpx2uqLNX7DzJX3sF9YqbPZA1dWlGfZ8fV8NLJhd2k6KQ8F/w64io5l/+x7wD+Qucw0XCXZ0cB5R0m5bx2S9MY7u48MwRC3QaYTpLbSXg7RWsRr0X0qicks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNcdSpC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNcdSpC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ADFC433C7;
	Tue, 23 Jan 2024 01:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971897;
	bh=hNAmJQTfZZANgKCYQ5hiflbCTEKPNgpqLgd98YnHWXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNcdSpC7Gqmmtij2PBtLXSddVHjoq7pbpwWcO4Jxylqi/lhJFR4hbciPjSoYWju2A
	 DqZfX/FBkidfaDKOM7T0fisoqUCJJrQrd8fPJh/GM+HsbkUfSiS8exRbG8qXptXnZU
	 Xk/FIq0rPHrE6rLZTzpVwjOPBLmMsYxIez9dCQY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/286] usb: cdc-acm: return correct error code on unsupported break
Date: Mon, 22 Jan 2024 15:59:23 -0800
Message-ID: <20240122235741.928414540@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 1c76e77e2d07..984e3098e631 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2480,6 +2480,9 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 	if (!retval) {
 		msleep_interruptible(duration);
 		retval = tty->ops->break_ctl(tty, 0);
+	} else if (retval == -EOPNOTSUPP) {
+		/* some drivers can tell only dynamically */
+		retval = 0;
 	}
 	tty_write_unlock(tty);
 
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 070b838c7da9..4e4a71307d63 100644
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



