Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1416237A498;
	Thu, 20 Aug 2026 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238147; cv=none; b=my6teK3npItGLi0fR5vRQbajQ/MXYeFWBQj2ClSlyGzXYU1k92iuZrM6MMLpi3ferXWbGr1Etd12g/T3YJG+lwpKe55076Sdahhsy4ijug/FwIi+qYdPdJObgvf+NY3Yb91F9UhuJpPsIKHeYxDwY+erfoyNkExLxTIN7eMqdG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238147; c=relaxed/simple;
	bh=tFKMWqwFhqm5MnPTI3tl6a0m4SWzVgQuRQvoJm5IWTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U47LWWk0xd6+DzGkiWdsXsu2NPhoJ7Fr8K61ZbCDiqCW+CB84GIS3OMeEyrbWSnaWii0AWgcpL782eZyDZEQBRKYFAjXcECkwGDSumXAGetQ03/PaRkxr3SvcuT84xqCLB50eKekz87NrHaZhfwB3AmDZjvvkySMZ3Q1jYyOp6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEduVBef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEduVBef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5BC1F000E9;
	Thu, 20 Aug 2026 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238146;
	bh=4mr6UMxpNv1FcO6ng1EBHzSet2kbrd3FQIeEi1EtEwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEduVBefYhjmW1knWBCYZFnhbH4YO3kpptT9UZbcj0ZFXN6CWNuiJKjSg5FsEHToV
	 sWlbhJef36rW52eQloe163F5Lrpb2LjJuVwt3EL8fdaWlDSUXinIEKm4MyzpHrZGqa
	 VbxdZjsO1SUIKEPS/oaeEC8hSAU1Un2PGuOGh3rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhefu Zhang <a723356@gmail.com>,
	Andrew Zhou <zhoulol888@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 046/228] Input: atkbd - skip deactivate for Xiaomi Book Pro 14s internal keyboard
Date: Thu, 20 Aug 2026 16:53:08 +0200
Message-ID: <20260820145245.869074854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1938,6 +1938,14 @@ static const struct dmi_system_id atkbd_
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
 


