Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164DE1A072D;
	Tue, 27 Aug 2024 15:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772718; cv=none; b=KM/DWpYFf6UQMKJsStWjspCmTBA/fa9qZtOkQuK9U3cLU5qjEj0uYImW43vd0SiXKGzwIwmo3to2OVwcLznuij/aP/Jz930VkfbOUEXoJYXxleTYaCwqb22Xqzo5voN/oJw3/5LpsvKe9wv1Dtv+2/Gw/z8YTCYfIglLt3SC5eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772718; c=relaxed/simple;
	bh=tTUDVnCxqNAPuG6VXvXMv9y7dxmKaUQAm190KX9agrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXxNrw5kVYTbTjk3b/+pDa1n0dF3EMk1Fzm00uDH2gidKGh7mM1Tx0rteu9pV8hwLGOTPiWU3aD7FFad1DoL+8L8oiBtnj4ciBxzxAZO3nx7EERaJBqav8Gfc3brkdpQdRmlK0fq7moe8oTf5QusmI2jSjFTzPCORUTjBGy/zc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tf95m+sO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tf95m+sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DF4C4DDFC;
	Tue, 27 Aug 2024 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772717;
	bh=tTUDVnCxqNAPuG6VXvXMv9y7dxmKaUQAm190KX9agrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tf95m+sOUh+YLLPKvb6A9FzdlF212XxDIVV2jLy1HZfcW8RcDnJtM/lJL2PJ42cLt
	 ResLEAJfLsPZj9lzSWX9m1EbLG7Qgu09eL78pcQ8GEVOYNuIwGriu8+s42z+fioQSV
	 sZsyHQaS8LkHtysiC/qbEJ0qwEpI11rTCM/V7dB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 271/321] Input: i8042 - use new forcenorestore quirk to replace old buggy quirk combination
Date: Tue, 27 Aug 2024 16:39:39 +0200
Message-ID: <20240827143848.567248037@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit aaa4ca873d3da768896ffc909795359a01e853ef upstream.

The old quirk combination sometimes cause a laggy keyboard after boot. With
the new quirk the initial issue of an unresponsive keyboard after s3 resume
is also fixed, but it doesn't have the negative side effect of the
sometimes laggy keyboard.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240104183118.779778-3-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1150,18 +1150,10 @@ static const struct dmi_system_id i8042_
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/*
-		 * Setting SERIO_QUIRK_NOMUX or SERIO_QUIRK_RESET_ALWAYS makes
-		 * the keyboard very laggy for ~5 seconds after boot and
-		 * sometimes also after resume.
-		 * However both are required for the keyboard to not fail
-		 * completely sometimes after boot or resume.
-		 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "N150CU"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {


