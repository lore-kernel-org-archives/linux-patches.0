Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3873D88FE;
	Wed,  8 Apr 2026 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671638; cv=none; b=CjcUAS6leaqX1cAW31t55luzbVdT+4/BGYVLPyhIX+e7TBPGD9RIO+2lf8CDwc1JFvZOATP3Eb/v8fQBhFtKQJjz6YiaBr+0ywCX38XtYvUAMaKztG0BrFnpTDa/r1PHOff1GPAchvQytAsajLhHZtJpfCCOqGgq41C2StZ9dQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671638; c=relaxed/simple;
	bh=3RH071ZPOeX9YTnkuPdw/4D0Dg1ZNzbyg3Qp3ojMcMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KmTaVCyuN75fDy3qhnWGyEPsZbnFLdC7oN4M968R7En22Q+Uk6HpCJyM7AmCGWsN15OxUXnsx5ytEczgMCRftWQCZFwUkGvN/XDiVX3XqteH0/mSK+mhhJ1tPAE1L5NNAa3mzR3jWsUppix4jJCUd5HzFcVEXQzcEOjG3L8dQAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=el4cntUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="el4cntUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC194C19421;
	Wed,  8 Apr 2026 18:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671638;
	bh=3RH071ZPOeX9YTnkuPdw/4D0Dg1ZNzbyg3Qp3ojMcMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=el4cntUz64cNz6ZTpndLPRf7f1fcjvBNkvY3HS+Ou+jl7p6XTNSfiDFMHmPHWlErk
	 I5Pq1Itb1C5kTPzT2FZLhpRfkfUp24sxxfkq6t4wUK62ztNnnNFgeeDcHvlx38WGLV
	 Q3xYsZUEYny5AARTXxTuin4cEMPuHnbPllcIt8O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/312] HID: magicmouse: avoid memory leak in magicmouse_report_fixup()
Date: Wed,  8 Apr 2026 19:58:48 +0200
Message-ID: <20260408175934.149769911@linuxfoundation.org>
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

[ Upstream commit 91e8c6e601bdc1ccdf886479b6513c01c7e51c2c ]

The magicmouse_report_fixup() function was returning a
newly kmemdup()-allocated buffer, but never freeing it.

The caller of report_fixup() does not take ownership of the returned
pointer, but it *is* permitted to return a sub-portion of the input
rdesc, whose lifetime is managed by the caller.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index bb725dfcef196..d5df2745f3da4 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -967,9 +967,7 @@ static __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev,
 			 "fixing up magicmouse battery report descriptor\n");
 		*rsize = *rsize - 1;
-		rdesc = kmemdup(rdesc + 1, *rsize, GFP_KERNEL);
-		if (!rdesc)
-			return NULL;
+		rdesc = rdesc + 1;
 
 		rdesc[0] = 0x05;
 		rdesc[1] = 0x01;
-- 
2.51.0



