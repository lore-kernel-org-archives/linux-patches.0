Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408E141B37F;
	Tue, 31 Mar 2026 16:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974820; cv=none; b=sJfIzRsf4knTzd6W81fJNiuWOMu+zTwLfd/hXgK8jZu0hmNQIG4bC1FJ3Ib3bYQ3AsrrQrfNrKJ4SMnbapjeBTJqMW5QbyFtLdsu1FZjWl2NdjtDH1d6aZLVRdFl6s++zSRIFJISTE5PCw3CMsucMzQ4wEpJXNV43MMj+XXn31k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974820; c=relaxed/simple;
	bh=wpKgPYXZ78r8+EqD1bpJm29mr8znqFc3YC/naqv9Oko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+jApgBJNgR/293OqURQ2cOKTax1lWrw43Z66p7WwwYrwblc3ipjDmqGx5m2vy1eQJFsG6vDjAP1GceMDx2QSJGl5wxFqECPkiVTWZoAEGus5dn8HphLgmYmu2H6RTu/8TsLfC7tes1vSEaTJBSkIbxDeREOc7+Dl4jy32dvPZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rheLnSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rheLnSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87741C19423;
	Tue, 31 Mar 2026 16:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974819;
	bh=wpKgPYXZ78r8+EqD1bpJm29mr8znqFc3YC/naqv9Oko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rheLnSrYTikch+me2/mXNgq5eFQCc86V/MPJ0D3yBw06FUbEWsfTobyNj3Tzht0u
	 Indl3/bgB7haZYnbZje85/m5NPAUSnlOF81rwPbTfkbDaxz3tHhP1385E9pMLBZze8
	 IHwAxeL6xflAphcID6wMgW+YAOxp0UqydU9DH+O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 023/342] HID: asus: avoid memory leak in asus_report_fixup()
Date: Tue, 31 Mar 2026 18:17:36 +0200
Message-ID: <20260331161759.765244878@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

[ Upstream commit 2bad24c17742fc88973d6aea526ce1353f5334a3 ]

The asus_report_fixup() function was returning a newly allocated
kmemdup()-allocated buffer, but never freeing it.  Switch to
devm_kzalloc() to ensure the memory is managed and freed automatically
when the device is removed.

The caller of report_fixup() does not take ownership of the returned
pointer, but it is permitted to return a pointer whose lifetime is at
least that of the input buffer.

Also fix a harmless out-of-bounds read by copying only the original
descriptor size.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 472bca54642b9..8487332bf43b0 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1306,14 +1306,21 @@ static const __u8 *asus_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 */
 		if (*rsize == rsize_orig &&
 			rdesc[offs] == 0x09 && rdesc[offs + 1] == 0x76) {
-			*rsize = rsize_orig + 1;
-			rdesc = kmemdup(rdesc, *rsize, GFP_KERNEL);
-			if (!rdesc)
-				return NULL;
+			__u8 *new_rdesc;
+
+			new_rdesc = devm_kzalloc(&hdev->dev, rsize_orig + 1,
+						 GFP_KERNEL);
+			if (!new_rdesc)
+				return rdesc;
 
 			hid_info(hdev, "Fixing up %s keyb report descriptor\n",
 				drvdata->quirks & QUIRK_T100CHI ?
 				"T100CHI" : "T90CHI");
+
+			memcpy(new_rdesc, rdesc, rsize_orig);
+			*rsize = rsize_orig + 1;
+			rdesc = new_rdesc;
+
 			memmove(rdesc + offs + 4, rdesc + offs + 2, 12);
 			rdesc[offs] = 0x19;
 			rdesc[offs + 1] = 0x00;
-- 
2.51.0



