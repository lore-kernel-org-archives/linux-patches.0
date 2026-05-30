Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F8A341AC7;
	Sat, 30 May 2026 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164271; cv=none; b=HqcDIO7ONKlYZU5qjTpcXiKHnp3oyYBecnmQxsZKtEEyXSo6ZUNvyU5tE3Ca2RdJQEG0hDH8Wr5sAj2Qbx+5WhbSYXSCgdrmXP0f0DVHCUIhE+QgKpIK5U9FJhycykfqeYTgojc2eyVbWKxrENHV2+HnQsex/x2YlaqZv1LHeiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164271; c=relaxed/simple;
	bh=DYGnMJjaHau73R/5i8QnA34hI0+5LM2/WdRiK6apneE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kds9ioCd9bETB4vhv3Huchx6JryJws0xRQndWA698yN+e09uaeuz4CU1e/sVj+Rs6zgCPPWLlFJVdp6c5/H+HExmtsqLv1ozHJbePIHG27uVybhqUlICX1qmLpAfr0TZXLQc8PqduOKHfiymiaBfMQcywtP05lpjdL42MNXKyLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iy0YLsNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iy0YLsNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071851F00893;
	Sat, 30 May 2026 18:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164270;
	bh=UHc8Mk0Tu3bdhLqjKo7Pc5YKzclgjWrqwB9nnfaGxH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iy0YLsNtYhJ/OOVblOdxn2nwKw6lKMSSPA13/xRaDQj1mtKWGg9PHBayWdzQhpqCa
	 sQUvOEfXrdjnyT+uKMWM3BOrE0nm3HniAkRYzmMkh2WlOvI6l4iyenibJ6aN7VV+e6
	 beaP6Nr0XmDCjIoNE4LwFXagcY6bX05rrOW+5OfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 505/776] HID: asus: do not abort probe when not necessary
Date: Sat, 30 May 2026 18:03:39 +0200
Message-ID: <20260530160253.332515120@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 7253091766ded0fd81fe8d8be9b8b835495b06e8 ]

In order to avoid dereferencing a NULL pointer asus_probe is aborted early
and control of some asus devices is transferred over hid-generic after
erroring out even when such NULL dereference cannot happen: only early
abort when the NULL dereference can happen.

Also make the code shorter and more adherent to coding standards
removing square brackets enclosing single-line if-else statements.

Fixes: d3af6ca9a8c3 ("HID: asus: fix UAF via HID_CLAIMED_INPUT validation")
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 5c7306fb57b1d..df12b75d2fa2b 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1142,22 +1142,17 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 * were freed during registration due to no usages being mapped,
 	 * leaving drvdata->input pointing to freed memory.
 	 */
-	if (!drvdata->input || !(hdev->claimed & HID_CLAIMED_INPUT)) {
-		hid_err(hdev, "Asus input not registered\n");
-		ret = -ENOMEM;
-		goto err_stop_hw;
-	}
-
-	if (drvdata->tp) {
-		drvdata->input->name = "Asus TouchPad";
-	} else {
-		drvdata->input->name = "Asus Keyboard";
-	}
+	if (drvdata->input && (hdev->claimed & HID_CLAIMED_INPUT)) {
+		if (drvdata->tp)
+			drvdata->input->name = "Asus TouchPad";
+		else
+			drvdata->input->name = "Asus Keyboard";
 
-	if (drvdata->tp) {
-		ret = asus_start_multitouch(hdev);
-		if (ret)
-			goto err_stop_hw;
+		if (drvdata->tp) {
+			ret = asus_start_multitouch(hdev);
+			if (ret)
+				goto err_stop_hw;
+		}
 	}
 
 	return 0;
-- 
2.53.0



