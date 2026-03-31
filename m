Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09363E3174;
	Tue, 31 Mar 2026 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974261; cv=none; b=LR8tnHR02woPyvkNPbovREG05pLrQ0WLrMcP2GL7cKbI21d3cexGx2p9Sa0yT1RTgnN6ubOovdQ2sJiqt1Ne/n+k+q5XIHr1NyPmqLM3vbFeY1UkckunklBhlk8uD4VeyxvNHDi4LTtv+Vh96caca06IfWUkRUjFe15NDdVvRrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974261; c=relaxed/simple;
	bh=VbU2nzil7mn/8wc8sKECzkVYZfwUmOsYv+t/2LoTj0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmwdZP53ZPqO39c19eMnHM18dXt+Ht7Rlq7OH4Oju/GtpIusMhh3VA8YjqzeDCaLIKkya3dxFY7V8zqa8HVpcrtOGA1eh4H9odvkp14Q3NPszCuccRVFyubqCDPD6986XYgUPDiTJ2QEOz+EYlb7WxNaISvEEGav9SELfUOcaEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqnyJFQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqnyJFQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4579CC19423;
	Tue, 31 Mar 2026 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974260;
	bh=VbU2nzil7mn/8wc8sKECzkVYZfwUmOsYv+t/2LoTj0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqnyJFQfLOULUfv6UwKNVGSXVDjzhdNJFtLkOJ6VI/s6m7joC6FCr9eKZgcgYlAbF
	 ZeVT6SffIg1Z0uOHCWkYt+b2kCB47mVY44LygaulWa4FLXwhQpOdEYO6YAFDjApMoQ
	 hicbDB6gC32UhK8JXOajh+HrI2v3xBB2xiqbfG/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Lehmann <lehmanju@devpi.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/175] HID: magicmouse: fix battery reporting for Apple Magic Trackpad 2
Date: Tue, 31 Mar 2026 18:20:01 +0200
Message-ID: <20260331161730.415061911@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Julius Lehmann <lehmanju@devpi.de>

[ Upstream commit 5f3518d77419255f8b12bb23c8ec22acbeb6bc5b ]

Battery reporting does not work for the Apple Magic Trackpad 2 if it is
connected via USB. The current hid descriptor fixup code checks for a
hid descriptor length of exactly 83 bytes. If the hid descriptor is
larger, which is the case for newer apple mice, the fixup is not
applied.

This fix checks for hid descriptor sizes greater/equal 83 bytes which
applies the fixup for newer devices as well.

Signed-off-by: Julius Lehmann <lehmanju@devpi.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 99d0dbf62af37..bb725dfcef196 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -963,7 +963,7 @@ static __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	 */
 	if ((is_usb_magicmouse2(hdev->vendor, hdev->product) ||
 	     is_usb_magictrackpad2(hdev->vendor, hdev->product)) &&
-	    *rsize == 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
+	    *rsize >= 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
 		hid_info(hdev,
 			 "fixing up magicmouse battery report descriptor\n");
 		*rsize = *rsize - 1;
-- 
2.51.0



