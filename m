Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FC72628C;
	Mon, 23 Jun 2025 21:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713798; cv=none; b=JSchdl1AwQT//y0IdT1c13mvsR4X5Q+yfp3QtBJ/qxexY1onVcQAt42NvMsWg02xCeGpDBT0hWAo35VfPbsFEkFu0fI1G8dKQ6DuZIWYUxmbTzptJ1B1fktSoSC54ZqDFPqOMZGBAESfYfwLFPOHvG2kN+HVQjyPfpVoAhWelao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713798; c=relaxed/simple;
	bh=1nq70tJyKL2ZoDuLTk0NOZmgrcuWAVS8xCMECj+c8bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcSt6j31WFQVzV3+EUQWAiS/BClXRPZXibRh/ny+u9Kk/+IVxNXmIOAcNCovSeEhjAfzTzlwRGC84jFRbfBcQ6NOekMyQn0OT3orFmQ9NMY96FsKUYxFZdeiJiYmYW0UKv6+bSXvLSTvKxj90ZREAtDJ/duGQSTCyuUX2n7Te3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6y+wca6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6y+wca6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C99EC4CEEA;
	Mon, 23 Jun 2025 21:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713798;
	bh=1nq70tJyKL2ZoDuLTk0NOZmgrcuWAVS8xCMECj+c8bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6y+wca6pGTPTUqNpCSm9tR4bGGmzFteXAmvBgyZcxIrgKbczSmSKdZt/hvylBCkb
	 JRpevGfozu8kvgsdWgdDEvbeE/pEeVGdibocm9tNQSF4qS8tPZwoFF7tjB+EAJfSTV
	 qnnHZlW9jjmnVDYlRPWG8svfcw/n5odyYVA1T60A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 366/592] wireless: purelifi: plfxlc: fix memory leak in plfxlc_usb_wreq_asyn()
Date: Mon, 23 Jun 2025 15:05:24 +0200
Message-ID: <20250623130709.147261238@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit 63a9a727d373fa5b8ce509eef50dbc45e0f745b9 ]

Add usb_free_urb() in the error path to prevent memory leak.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
Link: https://patch.msgid.link/aA3_maPlEJzO7wrL@pc
[fix subject]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 10d2e2124ff81..c2a1234b59db6 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -503,8 +503,10 @@ int plfxlc_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
 			  (void *)buffer, buffer_len, complete_fn, context);
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
-	if (r)
+	if (r) {
+		usb_free_urb(urb);
 		dev_err(&udev->dev, "Async write submit failed (%d)\n", r);
+	}
 
 	return r;
 }
-- 
2.39.5



