Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5DE1F4628;
	Mon, 23 Jun 2025 21:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715888; cv=none; b=ZnzUGvuyyQNnZHp4CFNmVC28OreUtgzlY0O1pnbIY353y1+9dvFgE8ePcCeIRjznS9XkjmfXhWYa3pT2pMGyExpYk/GzIeVCsWE9qzwabVhLv1B0gjPp+R2Lh0PZYqW6y+f6pQzOsc6V35Socu1Z5ef5VJLc7nX8IieO/vaLT4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715888; c=relaxed/simple;
	bh=x+JLJZZp5SfCELYYAwWug3f+F9Xi2DIXmXTwPQ/3dTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CofU0UXhzd/7uHDZBrV7fBjZaAc70OATkRK9G3diSZu+60zIYI66UG4MtY+YHzaMO9Ks7uegafIjXC0GiJJTa0O14IJ71QdciX0qDH5Mz/wJ0+kASGHN8HwJzBL4Dn5KoBUglzyI1O0ZQTEJLmVyy3RiHjEHXs4muq+5jnOkQ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpZB089b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpZB089b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FD5C4CEEA;
	Mon, 23 Jun 2025 21:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715887;
	bh=x+JLJZZp5SfCELYYAwWug3f+F9Xi2DIXmXTwPQ/3dTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpZB089bLMJVHHEGYqFm/BV0tzNzQsmXx6xqs0RTHM4/wo0J465KZrllJy/5ZMkSy
	 SNo9m2a+1WXJDlTyoj6MXYjS58clEIYlMm5VwgkoftPS7+j7hue1c20osC6J/viCF2
	 MALwlVCc47mWMyH5uD7OdqOMGF6Vdr9R0vkRfvZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/414] wireless: purelifi: plfxlc: fix memory leak in plfxlc_usb_wreq_asyn()
Date: Mon, 23 Jun 2025 15:06:12 +0200
Message-ID: <20250623130647.913591654@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 56d1139ba8bcc..7e7bfa532ed25 100644
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



