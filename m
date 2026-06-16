Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC6543E4A1;
	Tue, 16 Jun 2026 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624099; cv=none; b=WceshwyUjH/hD/1ehRAJ7pqEqHUfnvVT5piCxkMaNm8ipS+KiofSfLX/Z92LaTj9j1JqzwgGMn5gflFSpB7PsE2V60gH0e+edujuPZSSJKwoA1pT79DqoBt5gqh4DdGKzTM10Jd2o8LUdcdfCRf5f5Mrs60+hN4F9AbF8SthWTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624099; c=relaxed/simple;
	bh=PXnPBlKTrMsRM6/BR3rsKJBnDxQCetarlGxt3vSPlCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buFqBrpIUmGstS7aWk5XWWdnhdwkQVdOe7ydfUBI8/fe49z/ALdIUv+mKSqWjZ7NKUDqEPVggp8CV7kDjRfLt0JWva/nbpQKKiTAzM0dlQnqUwLgqIh+tO/wjDIgX+xkd4+pMlGwmxGKmtuzAx+ejKXbuGdyhTQb+13+AA6jMjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gz2EZQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gz2EZQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF15E1F000E9;
	Tue, 16 Jun 2026 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624098;
	bh=o/4EJzGNA+4rcVhh7ZxYkr7ELsAG5H2d2+34RBhJVW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gz2EZQATCvYL75FbI1nm3twbv9KrzJ44EWxqoH6hyvrAos2J9qXci4zh5n3runvv
	 kMsyIv+wwdu5YOiTffWbzUvqtd8n55GhHtqOafjjsuiVO/uLxBkh/6JlfDbjH+u8Pp
	 RF2YkT6Fq2gYGU1uf96MJrcQ3OJQPT4MvPEDE6tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeyu WANG <zeyu.thomas.wang@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 274/378] Input: atkbd - add DMI quirk for Lenovo Yoga Air 14 (83QK)
Date: Tue, 16 Jun 2026 20:28:25 +0530
Message-ID: <20260616145124.534146922@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeyu WANG <zeyu.thomas.wang@gmail.com>

commit ad0979fe053e9f2db82da82188256ef6eb41095a upstream.

The Lenovo Yoga Air 14 (83QK) laptop keyboard becomes unresponsive
after the standard atkbd init sequence. Controlled testing on the
actual hardware shows the F5 (ATKBD_CMD_RESET_DIS / deactivate)
command specifically corrupts the EC state, causing zero IRQ1
interrupts after init.

Skipping only the deactivate command (while keeping F4 ENABLE)
resolves the issue completely: both keystroke input and CapsLock
LED toggle work correctly. The reverse test - skipping only F4
while keeping F5 - makes the problem worse (zero keystroke
interrupts), confirming F5 is the sole culprit.

Add a DMI quirk entry for LENOVO/83QK using the existing
atkbd_deactivate_fixup callback, consistent with the existing
entries for LG Electronics and HONOR FMB-P that address the
same EC F5 deactivate issue.

Signed-off-by: Zeyu WANG <zeyu.thomas.wang@gmail.com>
Link: https://patch.msgid.link/20260602170909.14725-1-zeyu.thomas.wang@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1944,6 +1944,14 @@ static const struct dmi_system_id atkbd_
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
+	{
+		/* Lenovo Yoga Air 14 (83QK) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83QK"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
 	{ }
 };
 


