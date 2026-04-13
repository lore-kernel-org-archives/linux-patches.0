Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2306225A38;
	Mon, 13 Apr 2026 16:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097870; cv=none; b=QXcch1qVrD+zGirFqjTkvDNALwWxuTMLvmRNEMoTS57KhfCL4vHFH7QvCyniLPHGpSemkVCviam3U7rJF0xUbj7dMiOKPxBHi99eftc98yVo0YvOONgI/KBBQPFn7x4Dc6etkL143YJwfkbeI0FH9hg6G2PDQiq1vExNXLUkI30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097870; c=relaxed/simple;
	bh=Q+k8rwogVwiWM0zylv7mdTIs+VJ3iQEMqyPX8pvTJzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uus/aRdx3nTb2k4QfmbTU4SwZ2aj11kHhwitWgND+RkYpCaMZPR2SrtsFG0wLATfGV6wCIXQ2+JKzVIlx3k+lL64e2DsfLQMkl2EeOPuJ6Zm8sbqX9+bvUDarlEaq3hL+KGkrB423Q/6dfblPgsFou0sG7srbZH15TMo0SDhZ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gP/jLSxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gP/jLSxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C25C2BCAF;
	Mon, 13 Apr 2026 16:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097870;
	bh=Q+k8rwogVwiWM0zylv7mdTIs+VJ3iQEMqyPX8pvTJzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gP/jLSxCcuuDd/r0syS4e88KfCUZALuPK+6xTQ0mNd4mGaTJWyGBjv/eHzqKlUavH
	 ckaxyBiLxPXWFs46XhuyoZygnklf5rKxz0z82stlSi8HvMru2ai1hl9gtb1plTdftR
	 SRXwtVcU6FcxcLgVaLqfvOcTqBf4Vp+HxV247V9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/570] HID: asus: avoid memory leak in asus_report_fixup()
Date: Mon, 13 Apr 2026 17:57:08 +0200
Message-ID: <20260413155841.628310657@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index feec0724328ff..3be17a8b7a293 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1224,14 +1224,21 @@ static __u8 *asus_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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



