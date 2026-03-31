Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0441230C345;
	Tue, 31 Mar 2026 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974287; cv=none; b=qA4CYrVHQf/HMiHXQqoiKEuo/vRiIMviVl/Pf2Xu7wQu6L04rxRYa65qKK3/ONawQl0faLqEvTEJUzWApX3+z/MepBH5S2cKvDSSld1UzxD58RD8uEd1o1GOuPA3kJR9u9PmIEVOcH3t7WsnIxRRKAkyIoJPDoYaR0K/2ZaNyps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974287; c=relaxed/simple;
	bh=4utwA8vIto4yxf+1ydUcJsYmJAy4uV4xMOsIfgAnWqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YqJ4mMH5sw8ZfqOivr59lmUw6KPZHYp3H0wx6ULAAZ1NIHp5Toee3J6Aa1bjgXYRTLn9GGCnmDn+Mmijqmskikohc3y/nncYN2ckUMSUH6qkfm2Wz1eXn3bBNHUrLfOfHAcxwjYOm/9ir7xWzhV+Ntv61Bo9pIDoY9pkON13/hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9SlwdHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9SlwdHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37139C19423;
	Tue, 31 Mar 2026 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974286;
	bh=4utwA8vIto4yxf+1ydUcJsYmJAy4uV4xMOsIfgAnWqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9SlwdHPOQ1KJZNSAhEaiBbUYYsvaeQC+V0D0NWOFgASH+CnWR4hVRwOacaVe8rzv
	 5iekWwBANNG+XuaQ7+DQRpHWujZXW5JdKJC5B1Q3g6bWENLiWrN4EBgOG7fe0aIWIj
	 pZ0nlI3zpQjPV60NdSwuykW44ABCaj/vhT/CChGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/175] HID: apple: avoid memory leak in apple_report_fixup()
Date: Tue, 31 Mar 2026 18:20:10 +0200
Message-ID: <20260331161730.749708465@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9dd5c698fefe0..6fae3427218fc 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -645,9 +645,7 @@ static __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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



