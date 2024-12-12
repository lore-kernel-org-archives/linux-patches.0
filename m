Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B241E215762;
	Thu, 12 Dec 2024 17:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024375; cv=none; b=MRYrb6K8dOsv9T6O7iCyYNqChfeJ5UPCAbKgfJRFEnQ/hcfki6ohNT1J6/7c3B8YPPp0O3SMt5pvXUqXnrDye09ilo6inGdPxO2qj0bJZZWlgLVZDwS4csOsT1jdFr8RLwnm9QFgchl1Y2+u2Motvp/OjMC7bzRPRSz44lYeCwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024375; c=relaxed/simple;
	bh=eklZFBKSMZ/dayt7lSPuBPMuZHhcJnp4MGCcbyzuFpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JouWW5t+rYjv99UiTHX58P0tdvzgG2U6KSW0049CLUJlBDdHKeUKLJKS77utA7TiX8rEK+8fJxk42neYdd069mUcTMhV2fnYUCxelLnpz2Ifchk/SCX14lKiw3IaReV+Ve9S8/hBmVAJjKvJiM1thWrBS2Rm2lnuYVesELsh5LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxhHvOyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxhHvOyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CF5C4CED0;
	Thu, 12 Dec 2024 17:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024375;
	bh=eklZFBKSMZ/dayt7lSPuBPMuZHhcJnp4MGCcbyzuFpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxhHvOyOtdV/bnCCkoNik+RjsRTSX6ORyIQ0eAXoGMU7LfoRvDLlF9MqKMblio795
	 yB5YXPnJ2so7EQSPmuiJWlxgcJB/bpomce21Y4Jh04v8MKXYgJJcQNjdt3/gz7EqiN
	 s/RHd4wWm3nvnElsX0L4Y1jZ+ND3YqWULfoe3iWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 275/459] HID: wacom: Interpret tilt data from Intuos Pro BT as signed values
Date: Thu, 12 Dec 2024 16:00:13 +0100
Message-ID: <20241212144304.476083923@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
@@ -1394,9 +1394,9 @@ static void wacom_intuos_pro2_bt_pen(str
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


