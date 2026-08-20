Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AD837CD47;
	Thu, 20 Aug 2026 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238887; cv=none; b=EQrVkphsjuM5+9mPz4wsJaSVQ8V5luMYS5K7Z0mApbCO7Z6z8neVYTB7Z86uqp6Xeft6MlWwK6F/CIko8UHKXwC4HQQPjmEpr8xXIQX3JVwsnoWd+IV2W1mi3brmJbwix7bMr3+iWx/Q/MR8svAeXDzsgih6N0G4rCjBvn/9hl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238887; c=relaxed/simple;
	bh=vMyGs3cSa8251gnty9oAxRHhOST1CjURbQz0zsJYbI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vfln8+UJH/EA9BOW2eFbYEzzlFByQg2pjJti38vd58erbWlXsZOM5CwBljSoPVxjkH5IaytoQbZaUr8amyrKcxdwSwmG62rdW7R6mhqFk7XdVHIgMjmIvfYuvP5h0LfS3yECgKt4zCjAd7Gvu1jbiXvp8jHDiY6OE3d9p8boER8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yY7dDMni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yY7dDMni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4601F000E9;
	Thu, 20 Aug 2026 15:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238886;
	bh=oWkc1UeMyDW+ECEVXCn7C5siW0MEOC5tMkoFIx6ZNyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yY7dDMniv0ZkKMcPBMIat6Db/wK5ka2K0gSGbRcvYfJbfKcWstWNWt0sDu9PeSC21
	 bFJYulmjBgheR+i4CWzaVfs9gBhkJKn+3CaD51Q59Dkub2PdwriWx1iiCihDLVq91a
	 4cM6j6BnhT2Pq8S8JIcRjUw/mi6SzgtiNh5n5+b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhefu Zhang <a723356@gmail.com>,
	Andrew Zhou <zhoulol888@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 038/217] Input: atkbd - skip deactivate for Xiaomi Book Pro 14s internal keyboard
Date: Thu, 20 Aug 2026 16:53:26 +0200
Message-ID: <20260820145238.763414371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1952,6 +1952,14 @@ static const struct dmi_system_id atkbd_
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
 


