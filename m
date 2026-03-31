Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5E73DFC7E;
	Tue, 31 Mar 2026 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976246; cv=none; b=pW6/zdOSQ97flyqvCZ66F4w29tfQh8zLo6+wpKkdjoEWCYq1NrhR6iOMo6rDPD7SonIP3GDpSqhmVdTQHz2lnRWBC1lcqkeMUfrZswOt+fk1u+ntRDpbSjHW617ysI9SwGZAfRm81eMaWeTm1TzHMvKpss7aB8Jh4weQp7hdu3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976246; c=relaxed/simple;
	bh=FkzMfnVMO6XRwoMWMXPDa0Hp2qMqxJ1kIYXg+jgkv3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hnY3QTK7rAXe7Qy1dps91E1NE/GVopqtxt8CT2Eo4QW5GzszaQ+UP111z1Bzc0Dgmo/EsEIRKZRgNqhgAxQG81WYFN6Gp9vOIVLnE3vV11tjZwL0akhpQ4/xcXqerb3SJ0O9Fhd0jcAv/XFhyH2M3OZHOpyczBK76QX8tW7+094=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dW0KTZrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dW0KTZrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984ECC19423;
	Tue, 31 Mar 2026 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976245;
	bh=FkzMfnVMO6XRwoMWMXPDa0Hp2qMqxJ1kIYXg+jgkv3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dW0KTZrvbOSW02gCn63J7cNLoz6VMtORUUKY1fSBvqSqZf6JQAGHMUuXZASug2kC6
	 os/yfxuLdxhHHbwU40GPWmD+fdbpIXmHcA8FHdMEoaTYrirfgeyIeCL5Wh7e3ypf+H
	 8D+9PiDe+f9+2XNNM//f9taNsl0sslYXxBvP/nS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/309] HID: asus: avoid memory leak in asus_report_fixup()
Date: Tue, 31 Mar 2026 18:18:42 +0200
Message-ID: <20260331161754.186072536@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a444d41e53b6c..7904b3b7ea63c 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1305,14 +1305,21 @@ static const __u8 *asus_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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



