Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243CE7BB1E;
	Wed, 21 Feb 2024 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524578; cv=none; b=PCsFk+hzkdCQMdbO+8WQYx755Fuy4clLd/93tG57Z6jpeAPfg2JcKNE9WjxUP0fBw53oM9KiClIMtf7u7QINklzkYZLbZhpKyq3J467M3LNogdWseNXftJQCBH9liD5DFTQbNFtRVL7wSPD5vCpwc6W22MPWSMKwWf1fSVl3vqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524578; c=relaxed/simple;
	bh=dFo5akkvB4FaFc7jbFYuoWYsAwVuKktPC/GBi8w4Jro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7XAlFddfDyuKEE6QCFU29SZoKfj0egawemDpC0fHthm873HSOwzy8802WSjcb02V4moVH6zVou5fAW7pfG7CHN+THiLm58j6K+jtDa0mYtFvkvIummmhIBX82Hww84sH2MYjxViLgcuiwS0oa2kz9P1izDGyP+/c6I8IaWdBSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mmg6Lwmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mmg6Lwmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4B0C433F1;
	Wed, 21 Feb 2024 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524577;
	bh=dFo5akkvB4FaFc7jbFYuoWYsAwVuKktPC/GBi8w4Jro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mmg6LwmuMtGuO9G4ooOe9KQDpODa8S3FehHigrHT2qV8SGu1bH52xknpfzkxUyXP+
	 ELmhMjbQhpCuFkGCJkBfvtLGjj/gKirfPPuEOudtUDAHTyiCN1O9vj9gNGRZLwweIc
	 DqvHKsglqIHlzDATzVEMJRuRufauUYkCcW6lhyAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 279/379] Input: i8042 - fix strange behavior of touchpad on Clevo NS70PU
Date: Wed, 21 Feb 2024 14:07:38 +0100
Message-ID: <20240221130003.157654976@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit a60e6c3918d20848906ffcdfcf72ca6a8cfbcf2e upstream.

When closing the laptop lid with an external screen connected, the mouse
pointer has a constant movement to the lower right corner. Opening the
lid again stops this movement, but after that the touchpad does no longer
register clicks.

The touchpad is connected both via i2c-hid and PS/2, the predecessor of
this device (NS70MU) has the same layout in this regard and also strange
behaviour caused by the psmouse and the i2c-hid driver fighting over
touchpad control. This fix is reusing the same workaround by just
disabling the PS/2 aux port, that is only used by the touchpad, to give the
i2c-hid driver the lone control over the touchpad.

v2: Rebased on current master

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231205163602.16106-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1181,6 +1181,12 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "NS5x_7xPU"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOAUX)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NJ50_70CU"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |


