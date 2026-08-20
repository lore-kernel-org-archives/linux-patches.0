Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4595A373BEC;
	Thu, 20 Aug 2026 17:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247385; cv=none; b=jfpoTAwhXkblyR5qPtKu+Gs9Ohzu7daZqmXkYjvUdTRQXDaD8j9q7EeE2f8/HzDC/zrmc87zYYceZxc7ZuDP3Xb2g6K5F+knBLIm6SGWb4OmybEdN+6EV7pRs0X9Jj6W2JKvUAkWqL/xZGSTmDPPSNQW/4Yky0nxr1RMbs7xMGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247385; c=relaxed/simple;
	bh=YLygN1fs88tHwkBZXCrbxa0IZ3TydRJAntlL8tzGGDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVcorJ5Pwg4f1jajdYOH773CAb1DTZy4MQ7b5Yf+wG2FPGCfS9ZERGiX5v+vubQW6cWWWE/UFrNcarJ5MHDd5KWXOxc+BuHVbrvLVQp3rzgfNl5S1JCwa6LD7La8yK8nOj5cxCWXBF1pnEC3EJOjUVfEE0gktfuBx75D9ccnfMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uB0W8/yS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uB0W8/yS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E441F000E9;
	Thu, 20 Aug 2026 17:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247380;
	bh=59Fpf/MMWZJfd7TQa80hZ0Q5L96EeDk0utCFMqT9au4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uB0W8/ySVt1AMLbbuowSfdxg82h5XoG5IKvpkwj+m4osvIg3PA9McwCBBAz0+mC4m
	 Tu473cVMU/WMl1+YaOsKp81qU0fleIFIdg3Ieq+L7MTu0e8Xy6+J794nMQVB1Qt78S
	 kExM1igeSPj9TzTpqj4gEmq1mVBPWMHRezwROlkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhefu Zhang <a723356@gmail.com>,
	Andrew Zhou <zhoulol888@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 026/166] Input: atkbd - skip deactivate for Xiaomi Book Pro 14s internal keyboard
Date: Thu, 20 Aug 2026 16:54:45 +0200
Message-ID: <20260820145211.971532316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1959,6 +1959,14 @@ static const struct dmi_system_id atkbd_
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
 


