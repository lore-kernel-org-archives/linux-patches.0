Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480CD145A05;
	Fri,  6 Dec 2024 15:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498252; cv=none; b=YmG6kyTWVqSOlzbuA/jhPwL9CM7HmKzRzfjRct9u/U0yUbzBTozHy/K+UMKqvaLs/aSumDQpEiNZg+0dF9MwRGWxera9NEH/J6B75X5MFHm76ejwg3oa1ZS1jsf13k8wjoOJlArV0DloNBE65XFUzLDWKt7xeJxfQ3iE2aQroAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498252; c=relaxed/simple;
	bh=Y8li/D3q5v/HWF46hukf+HZP5PxDb8CKGtsRfc1xZcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NejErDfADH7R8oOg6/YGiJUa10+vJwCN3EgiM2yPUd4GFWCfc+/zk9fLEa1rXmO0gFG7jSffVIb89RFQx2MZRLeqeVo3mS4MmWjpY/KPRFfZoeEgK7gYNHPvfFvXvTFoGCPORNA3lVpBLCpzKFCkxEXlc+NX4D7dTjzPjU6MgnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOYVNc/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOYVNc/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDDBC4CED1;
	Fri,  6 Dec 2024 15:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498251;
	bh=Y8li/D3q5v/HWF46hukf+HZP5PxDb8CKGtsRfc1xZcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOYVNc/Gx77hw29FOebWfLP6l1X0mIynsz55X6EyS3L/YUMj4GV5boeC/ZEn7qY24
	 UiNEzc7EAym60ahkAmvSx7I/xaCJXuZ71syEreEblocRHmsoSaL/SuRzQMoYmkwIpx
	 BZHuYJbOl8G2zPp3pxRaoAcRh05Jf7oT8bZeHUpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 530/676] HID: wacom: Interpret tilt data from Intuos Pro BT as signed values
Date: Fri,  6 Dec 2024 15:35:49 +0100
Message-ID: <20241206143714.063443232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 49a397ad24ee5e2c53a59dada2780d7e71bd3f77 upstream.

The tilt data contained in the Bluetooth packets of an Intuos Pro are
supposed to be interpreted as signed values. Simply casting the values
to type `char` is not guaranteed to work since it is implementation-
defined whether it is signed or unsigned. At least one user has noticed
the data being reported incorrectly on their system. To ensure that the
data is interpreted properly, we specifically cast to `signed char`
instead.

Link: https://github.com/linuxwacom/input-wacom/issues/445
Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
CC: stable@vger.kernel.org # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1399,9 +1399,9 @@ static void wacom_intuos_pro2_bt_pen(str
 					rotation -= 1800;
 
 				input_report_abs(pen_input, ABS_TILT_X,
-						 (char)frame[7]);
+						 (signed char)frame[7]);
 				input_report_abs(pen_input, ABS_TILT_Y,
-						 (char)frame[8]);
+						 (signed char)frame[8]);
 				input_report_abs(pen_input, ABS_Z, rotation);
 				input_report_abs(pen_input, ABS_WHEEL,
 						 get_unaligned_le16(&frame[11]));


