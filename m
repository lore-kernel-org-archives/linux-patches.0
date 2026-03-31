Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E53B401A38;
	Tue, 31 Mar 2026 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974915; cv=none; b=a1gPzMT6/WvhWAwOUxFryETblhkWalZqYUU25etgYbT1qGtCbHuMgw+EHwM/PtAIvDTSgP5RGUza5PvxdK9QS7yrtf7j4WEdTBVmH0qZSHmFJdJ5CKo0DRD9iHBKoQlTz1UA0Rz/6S7VOQRdFIpKN8PEsqmR/74vo2L4idO81Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974915; c=relaxed/simple;
	bh=rcnoysp1IYmEzmmnDMUYF4/8Nq1oT+eOJTR7CaO2m+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NnUIS/LAtT6jls0manOsXXWoSd+SaiF/qeFPd3Wq4s2jQoSlU7pWRXTRAkCkMtWhNITZnaj3jb0LzlQfQ/ok/1zlfICdw6meD/q3iXPL0i0i2vlLbrXlmIe32oxGZ/b4JGf4PaAerqLHeaG9PFJWTqNw84dgpXKAPPUDx9B2uTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WE7fyz+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WE7fyz+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150FEC19423;
	Tue, 31 Mar 2026 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974915;
	bh=rcnoysp1IYmEzmmnDMUYF4/8Nq1oT+eOJTR7CaO2m+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WE7fyz+vnx1jS+ljgZd77HsK+7VSKMb80CocA2iue3UxJYcfeznqDL4+PTNTESpXg
	 CcfPo3PQlclb3k8Idm/3aM32p2zxg0Hl0wYvezbGjLjIRh+4izwFcYlmYM1qaOVGMQ
	 vdM5Ix7t8BUDG0c5KkkQwX5iu39O6v14JBAueskI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 061/342] HID: apple: avoid memory leak in apple_report_fixup()
Date: Tue, 31 Mar 2026 18:18:14 +0200
Message-ID: <20260331161801.140901427@linuxfoundation.org>
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
index 2f9a2e07c4263..9dcb252c5d6c7 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -689,9 +689,7 @@ static const __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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



