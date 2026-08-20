Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A17547ACE2;
	Thu, 20 Aug 2026 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243213; cv=none; b=ODfDoHwYUR5AAwaNzUT4VftZOF3Q844FaVxitoMADIYGgpIcphEol5tZrZy1CqJjMZHoxWDeGKUm/WfpwyAdaEBuyyiHpaUSwPRbMvms6goKVEUaruQlYuAXuB5IBVyCePdhhMsO9dwPTGUTB8rExmh6h/Ip9y00+/s5ZyLPbmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243213; c=relaxed/simple;
	bh=i9xODJXcFTUYJRzSC3uOuESCBYLqeilaXrM51J9juI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJnmfcsnnxgxFPzvprKcdc3GtZgD7HETFz2vrSFCUzdQQfXJs3ROzB3H9rvxvqSV7it0z/ttK5sCh0WceHW0OQWDPd4RDMiVp2sI337pjswWoiaOe9XaBEyIWgHdSKfOZRzOI1IiDe3rMxpbS31VfafArTNfZ25yLTxhotFrkLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SMGpstx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SMGpstx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2811F000E9;
	Thu, 20 Aug 2026 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243211;
	bh=l7kOij499yPpyBTQphIdr9bkolGyn2bZjiIJM9JwBUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SMGpstxDG1G1Sg6WzsXZuG65Y+P1AK6U0nOfAXFXxL5LnqxS0O8PnpR1hQmnICrJ
	 SmI1zSE4MEWyZDwUpwGqStnJpFY6Ja8lb0jTQ5gSk64X8lsTA9+D07DDsyjZHr9pzW
	 cPFlqylIOR/Rm9LhM50CP/5tK9ZSQS0yLBCuU5qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhefu Zhang <a723356@gmail.com>,
	Andrew Zhou <zhoulol888@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 017/272] Input: atkbd - skip deactivate for Xiaomi Book Pro 14s internal keyboard
Date: Thu, 20 Aug 2026 16:53:21 +0200
Message-ID: <20260820145231.751552287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
 


