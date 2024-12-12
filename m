Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0053223C48;
	Thu, 12 Dec 2024 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020217; cv=none; b=MxmA+hpApx3Jrj5b5QuwyG9+tw+i+wF3TYLXOnTfg5ntWOBg4D9pleG7jSMSs69OPZsEJZwv0dhWR9fo4UJFcWvqOdFBho8Zcj89a3fOF2+5aDpRja7XnmkD/CpNkNbS7p3dHywZGriZuE0ubdi50tPD1X4iJgib2kCMQjlr17k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020217; c=relaxed/simple;
	bh=Pp20x9WpFUTbTg7V6uWg4QKDRQfKiFLy5CBFMEeaEmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4OxeVd/eEWyj/AXq2tVUTLQlyW37qt/h/PAo38r6ZPnPl38xJbLN3UvmTYo4ZWjK6E8nq8Tbljdy1gh9sIFWKX2SQkASJpIOCABI8cf53UEkP0hqvQ4KRtucRIuccm7cEvsvBHHuUd7HSbPeBa3ABzztS1U7u1NfrKTaLM1m5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Tbhr3fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Tbhr3fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD7AC4CECE;
	Thu, 12 Dec 2024 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020217;
	bh=Pp20x9WpFUTbTg7V6uWg4QKDRQfKiFLy5CBFMEeaEmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Tbhr3fwfUVo9PUSTq3j9++yPFhZG3Knbi4aSRJbnG57P6PUeq+zyhu0ojoG8MRIx
	 VgGOvaPzKr8VfnGjw1M7WJvsAuhzEVWSOjHJQRt4upgMo5uHebDsFSzANa4CYPOnK4
	 uhCowJUBBhl7uhOFj4/eV+ud9N1Ox7xvzR68b3Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 408/772] HID: wacom: Interpret tilt data from Intuos Pro BT as signed values
Date: Thu, 12 Dec 2024 15:55:53 +0100
Message-ID: <20241212144406.786021896@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
@@ -1396,9 +1396,9 @@ static void wacom_intuos_pro2_bt_pen(str
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


