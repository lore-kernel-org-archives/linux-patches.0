Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503D0423A9B;
	Tue, 31 Mar 2026 16:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975741; cv=none; b=Ukp2xZIzSsiUHxTZ3GuczRPIZi0AGVFBhQoO9DISi5iEMlDcyX8v92/SHO2ui4GGjBJWUhz4IFhDyfgaFx+zCiP9ET7VcmKDGwN6PliKtAN0gzsnUZCgXqOBL/VrwjoaY4ngxaTbXZ6c8XuzZLJX4OgNmr3E876kUqiKvR3h2L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975741; c=relaxed/simple;
	bh=yUSBEXEOPvjFFBjZB8dSyUil6R45CdzDEWl2miTl3q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d38/iMOMK/oXuZ1dregSlQQZD+2xMaf7Xs+9ScRAu1Ufx3nMc9Glvp/o6xUkRg+fjnuZtll8yu5qM6XftBEsPzXWRYRa8ABwaUj+L5tbqsj0CHJDSDNIbsHXC8h7rhLy6kazo/6Ofi6BBMVeVkCU4bIsDP1s2dTMGp1wW3yXnOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhtGGdfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhtGGdfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1359C19423;
	Tue, 31 Mar 2026 16:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975741;
	bh=yUSBEXEOPvjFFBjZB8dSyUil6R45CdzDEWl2miTl3q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhtGGdfcs19rNGawf3y6ToAmSXicBw0MuKHXbY1j3tAwvOLtZSNLD5KzclsAS+DkA
	 4DhW71mj+mKlZ72mqaksMyL9sZ3ibIBvvhlR/sdBYZIOSRlqgdDGlkVPcCU/B/nxAf
	 8NMwg9KAhwd7fR7J3kEaDcATnK8kPubBRHnP4Ev8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/244] HID: apple: avoid memory leak in apple_report_fixup()
Date: Tue, 31 Mar 2026 18:19:45 +0200
Message-ID: <20260331161742.997430300@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 16540546a210c..7e11f2932ff09 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -663,9 +663,7 @@ static const __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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



