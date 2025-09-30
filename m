Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DF9303A05;
	Tue, 30 Sep 2025 15:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244458; cv=none; b=NOg567oxAZzbdpXHAcl8g6HkWPe1j4lSVpEmQh63ZKPyeTagusZyKG0G8SpMGeecEr9jeT1TzRQzGZngqwwCYC8muTL9/pgO06/4PsTKOeaA6rqi4eCIzvHASV9dHVJwNKzDFDoMJe38GDVUGiEGyDQWTqjSb2I6jUHxkKusA7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244458; c=relaxed/simple;
	bh=Ay2aBw2LJ1kxsbOxqR6+2HmrxkYL6MyjYG+drjopXVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTsIyvlUFwA2sYy4NRFmmr8XKdtxJH31dHbIPRxpAihR5XSIm1mLeqy72IzNfpxEQTiYGayX0NMToC8G8WpYh6lqFJpYwOp4dMLvaKN9oK9iyYP507mwA1VVDGSMrNB7TlBjn45VJnGLf4X+lQcUSTB66xGWb+GRrqnHH7cNABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOQ+yPiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOQ+yPiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C062C4CEF0;
	Tue, 30 Sep 2025 15:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244457;
	bh=Ay2aBw2LJ1kxsbOxqR6+2HmrxkYL6MyjYG+drjopXVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOQ+yPiTcOz9YjiHCiIqz4DvmyAxIL4bXPlZiAjAGW859TCbYz+pihTpPBT/LzLgT
	 ZFAs8xIFMIzTWQQ2/I1cttG9ujkwXgCr2v9Yq7EvMeHR21DzikHIV6IC2lmr2vyGYC
	 8GmNP1+6PGJQObRVV4qHB95IiwUmXQvn+WDjNLWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 013/143] HID: multitouch: take cls->maxcontacts into account for Apple Touch Bar even without a HID_DG_CONTACTMAX field
Date: Tue, 30 Sep 2025 16:45:37 +0200
Message-ID: <20250930143831.775839699@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit 7dfe48bdc9d38db46283f2e0281bc1626277b8bf ]

In Apple Touch Bar, the HID_DG_CONTACTMAX is not present, but the maximum
contact count is still greater than the default. Add quirks for the same.

Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Co-developed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 20e0958d0fa9f..c9f9f21a6ec6b 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1335,6 +1335,13 @@ static int mt_touch_input_configured(struct hid_device *hdev,
 	struct input_dev *input = hi->input;
 	int ret;
 
+	/*
+	 * HID_DG_CONTACTMAX field is not present on Apple Touch Bars,
+	 * but the maximum contact count is greater than the default.
+	 */
+	if (cls->quirks & MT_QUIRK_APPLE_TOUCHBAR && cls->maxcontacts)
+		td->maxcontacts = cls->maxcontacts;
+
 	if (!td->maxcontacts)
 		td->maxcontacts = MT_DEFAULT_MAXCONTACT;
 
-- 
2.51.0



