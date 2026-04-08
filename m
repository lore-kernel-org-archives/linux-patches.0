Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D5E3D4134;
	Wed,  8 Apr 2026 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671742; cv=none; b=FislyiansVw8fWOWZ+Xr5F2tjTausIuuU4WeOpCeDJbFg9vUTuo1SDO0SUDg4Eo7bEFlPEhen+45MO2uLcxHkBAG+iZmNX3AWOEDkYVzoeBTEXw3EQboDYaS2OhT/yqzzwv2ErAkosfArKj8rZTxMfhg/eUFPkOWWiX4PkIT3yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671742; c=relaxed/simple;
	bh=Lazv+L1FErYvguckzIIFwtL3kosyC0gIcsBZL4302Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rtYzq+63qmxvqRYVB7XFNuWVtJow6x5XEB9FfByDwC4cRxU50nqe8tGZeAr98ZtChk96AYO+l4YZM31NC2gmvY1d/fMW0EyxAuGqM+9jilV4M7YbdncMMKU0hVfmSwwvmeHKrIqg7FcLEimEeBkQymcbFUmohJtz1UmHmkuZXqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgsWguke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgsWguke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C53C2BCB1;
	Wed,  8 Apr 2026 18:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671742;
	bh=Lazv+L1FErYvguckzIIFwtL3kosyC0gIcsBZL4302Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgsWgukewsK3Y51GUeiBVgTMPTtgMbnXdJvSJEFMY3ky5Bjdybct/xNLYvG1LjmPD
	 fD4bA6A87ZXD5S9rUD37SEc/2tFGd9SNHolQCJqL7vxrbQVpkO5UB+XQaC6spySHM0
	 8MWQvQN1PpJbsEpFlXsWgBjxpeBP4xRiOYwB/AhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/312] HID: apple: avoid memory leak in apple_report_fixup()
Date: Wed,  8 Apr 2026 19:58:55 +0200
Message-ID: <20260408175934.411297930@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

[ Upstream commit 239c15116d80f67d32f00acc34575f1a6b699613 ]

The apple_report_fixup() function was returning a
newly kmemdup()-allocated buffer, but never freeing it.

The caller of report_fixup() does not take ownership of the returned
pointer, but it *is* permitted to return a sub-portion of the input
rdesc, whose lifetime is managed by the caller.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 0dff3f557e632..742ff0c86e0f9 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -611,9 +611,7 @@ static __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev,
 			 "fixing up Magic Keyboard battery report descriptor\n");
 		*rsize = *rsize - 1;
-		rdesc = kmemdup(rdesc + 1, *rsize, GFP_KERNEL);
-		if (!rdesc)
-			return NULL;
+		rdesc = rdesc + 1;
 
 		rdesc[0] = 0x05;
 		rdesc[1] = 0x01;
-- 
2.51.0



