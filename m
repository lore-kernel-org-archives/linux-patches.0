Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8F92A1CF;
	Thu, 13 Feb 2025 15:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458811; cv=none; b=gQ3q/DG4d3um0XRNR5yxdp6Fk5TJHyfX0a2xkWPl/V44qgi5zrbG70dAe88rFIlsQFRQqYF0PdbHVed8O6RoJZoRVmbBrwwpFZazi9eD6lGqqtBdt3Vzwtvm114XcfbN7DMnlL8wk1SW/df1/LafjVLndoIASlErX0AwL26set0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458811; c=relaxed/simple;
	bh=/Lkm+X27qeeRsEVLHmKJ/2mk1WPYCBKNB/ZcOIe3cfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLrCmElMbo0Nh0vNI6XAbTBZOcXDArlowqQWSw2qibu4p7HrXzkTNwvEraO5jQkOkhwWhuqfAK8VFipcUdc6tnGd8FqMRKDeZuT8yyigtjn52GbUJqklpa8Uh4s1KgVqcx9uKyACvSamI5U0XrWBQq9FiaDHhBKThWxdiVipLOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GnQP3h1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GnQP3h1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F6CC4CED1;
	Thu, 13 Feb 2025 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458810;
	bh=/Lkm+X27qeeRsEVLHmKJ/2mk1WPYCBKNB/ZcOIe3cfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GnQP3h1eThMWYGrqqQblM0oL0TzdyXQDIFFLMNtgSsYe3E5fgZhUixAEdMOrUsus
	 u+acUO2dJ0fEvtiAVpNryde9iyANeIP6L59I8/istltrj+VJP00RNdYrDtVN3YvsEO
	 Cm1fAJJdl05uFGzyrCry3SyFM18g6DoeRTagvi6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enze Xie <enze@nfschina.com>,
	Youwan Wang <youwan@nfschina.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 066/443] HID: multitouch: Add quirk for Hantick 5288 touchpad
Date: Thu, 13 Feb 2025 15:23:51 +0100
Message-ID: <20250213142443.166395209@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youwan Wang <youwan@nfschina.com>

[ Upstream commit b5e65ae557da9fd17b08482ee44ee108ba636182 ]

This device sometimes doesn't send touch release signals when moving
from >=2 fingers to <2 fingers. Using MT_QUIRK_NOT_SEEN_MEANS_UP instead
of MT_QUIRK_ALWAYS_VALID makes sure that no touches become stuck.

Signed-off-by: Enze Xie <enze@nfschina.com>
Signed-off-by: Youwan Wang <youwan@nfschina.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 42c0bd9d2f31e..82900857bfd87 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2314,6 +2314,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY, USB_VENDOR_ID_SIS_TOUCH,
 			HID_ANY_ID) },
 
+	/* Hantick */
+	{ .driver_data = MT_CLS_NSMU,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			   I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288) },
+
 	/* Generic MT device */
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH, HID_ANY_ID, HID_ANY_ID) },
 
-- 
2.39.5



