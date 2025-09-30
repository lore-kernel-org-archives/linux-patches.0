Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9C130594A;
	Tue, 30 Sep 2025 15:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245657; cv=none; b=Mx9RP/urLvFxhI6T1D7hIIkGNoJ2qvsr5iToM395Bw0CyRu5QNVpRvZWGsGkSTy5RC8Ia+KakRiex0JpGcCf8zOXLN0oO9WAbKS4thvPQGuogtjZXCzhmTv+BmM5xkyTDOZEtuJThrLS8McADWfecgWMva2TZEqOn6vimB5iKIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245657; c=relaxed/simple;
	bh=93EFQK4Bt29HojdrMczV2MvVBCfzuN/2QzLrQGECE3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aU3+RYNc3Fkr3KkbfHNiAmQAXApZFxqCkrnc7WSHW/1U6ZhHtN9tgxvDrXWTZ6rGPUBnTm3NPs9Ak09ZmjsTHRBifjWA4Igta8qFHPpeTjANE09Qzamzrxe3rQS8CxFjPIWogQaeBHgTFD3INHOyDroJhJjKt/s62uUsA+9yjGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCWaj8yO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCWaj8yO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBCEC4CEF0;
	Tue, 30 Sep 2025 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245657;
	bh=93EFQK4Bt29HojdrMczV2MvVBCfzuN/2QzLrQGECE3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCWaj8yOlB5SW5uUXFvSvKFw2aeUXry189WkIadBy7OoEqyNlWG+1nEpyFt1tSS/L
	 kSFM3UvTxA7A6jy6OvyQYiNezKB6czpb+nr7DrRD0oEM6Z3JH1eMA08rn4Io/laiR4
	 2Rht/tITb2yZVJJttFTMtnU+v/rzhxQYnWhLl/a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 11/91] HID: multitouch: take cls->maxcontacts into account for Apple Touch Bar even without a HID_DG_CONTACTMAX field
Date: Tue, 30 Sep 2025 16:47:10 +0200
Message-ID: <20250930143821.590021310@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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
index d0b2e866dadaf..8e9f71e69dd8c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1322,6 +1322,13 @@ static int mt_touch_input_configured(struct hid_device *hdev,
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



