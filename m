Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7F547CA79;
	Thu, 20 Aug 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244100; cv=none; b=h2eANNpnVsD5ANxCdH5fepRBUneJMq7myeSlS+TNdYoCiieoN+QLub2qjnKyMfNncqxiYX5YlLV1k+cUaEBm5Osyb9bU3yTpTSGNYeA7DhjDtKd/5jjHCMVrZt5iYrRliy7Jw0+ZMd1FAqWmmnT/5ZDuFjVHkZKRdPMHwPbD/M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244100; c=relaxed/simple;
	bh=5L1/uiWcTYnj+9vjGYyJmGzO/KPkolGuozF2rM/395M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7f3CK97dANGABqAn06yGWNinP4kmCSJvk8kZ73Va+HMN8NzDs2U2hmjcEaOn/+JszBpQ8Iuix1yO3AWznJC+nLD4gwRS0r2TnXBfzbkLJmPVzFWBEspycOIdEz+d55yCgSn3cJ2WcHdfU50YlZqLy25GCVinc4ESHIkbt9dpP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hT3qJ+dU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hT3qJ+dU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D0A1F000E9;
	Thu, 20 Aug 2026 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244099;
	bh=cmWQuYQNlV89rZoDuqePB2eUn41CPGuQt8cJkAWJEyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hT3qJ+dUI3d4tQzKeqRJlPGyJSCYDI4YlXbkvRsHuP7TcJdXF8mUTId+TopueVtg5
	 43n+Vd7bGmqqqyEVt5/Srd2F4nmKebEH7GXEbfai9BBQBtpL6Or0YjrOrEaiAvyQvn
	 N42MehPWjxUrSczqJyZW7M7zUMGdlpYT1B9fHDXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhefu Zhang <a723356@gmail.com>,
	Andrew Zhou <zhoulol888@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 014/235] Input: atkbd - skip deactivate for Xiaomi Book Pro 14s internal keyboard
Date: Thu, 20 Aug 2026 16:54:10 +0200
Message-ID: <20260820145216.873998378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhefu Zhang <a723356@gmail.com>

commit 3a046db33bb9f28b43a951a7a090db771dc0f8b3 upstream.

The internal keyboard of the Xiaomi Book Pro 14 does not work unless
atkbd skips deactivating it at the end of atkbd_probe().

Using 'i8042.dumbkbd=1' also makes the keyboard work, but then the driver
never writes to the keyboard at all, so the Caps Lock LED is lost. The
atkbd_deactivate_fixup quirk fixes both without a boot parameter.

DMI: XIAOMI Xiaomi Book Pro 14/TM2424, BIOS XMAPT4B0P0909 05/06/2026

Signed-off-by: Zhefu Zhang <a723356@gmail.com>
Reviewed-by: Andrew Zhou <zhoulol888@gmail.com>
Link: https://patch.msgid.link/20260802031559.19701-1-a723356@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1954,6 +1954,14 @@ static const struct dmi_system_id atkbd_
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
+	{
+		/* Xiaomi Book Pro 14 (TM2424) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "XIAOMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Xiaomi Book Pro 14"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
 	{ }
 };
 


