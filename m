Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A743AE70F;
	Mon, 23 Mar 2026 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277750; cv=none; b=JJ1tEMpVFKK42fFFHCrzhYVHR7pjSC/hxGX/5ZESazx57FLEMi5VqstY29q7NeMY3wnbl6kuwZdcbGsv73TTJ29OLsN/dyndchjsTMK7ELCKvtVoVpV0AQSVQWuyvzQK5z0AE+O/dXSYH+aDFHrj1xlU4LvtjRWGESgkb6ok4HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277750; c=relaxed/simple;
	bh=ZajUoLIcjVrVvR7yDEMiE3S4dhbnLd/LOnFz/THuXz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5BIeYwkr7s0L2L4u/5DqrCpg3bC+SHfsNM8RKou35RUlFt2hhmQW/VvZX8lMh+dq0/IAtOdKhUIlBjfyG2daG06E0fRxzvKZFkzqMq3rnenHmRW5PZ5xeMmQ0eTpUYj3M+jLVAq93dK/qFj7XBg7xl6xB5uuWGzyc6GlFj81gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsHJyase; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsHJyase"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E81C2BC9E;
	Mon, 23 Mar 2026 14:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277750;
	bh=ZajUoLIcjVrVvR7yDEMiE3S4dhbnLd/LOnFz/THuXz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsHJyaseUBSg5lamKNpzFxDRuSB8t2nOflXvHZEHzyFqkLfYc9PymWlrPVuqb45lO
	 dd8E+BVQlCRSIeZG1EZ93KE4b8OHv1ychkk09BbPP/yCx3l6k0EM5K9WY1Qk5cAUIY
	 e9LO7zi1nupl/2P+0GYxb64F9tS/DNMCEyeAy0dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 089/567] nfc: pn533: properly drop the usb interface reference on disconnect
Date: Mon, 23 Mar 2026 14:40:09 +0100
Message-ID: <20260323134536.032745914@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 12133a483dfa832241fbbf09321109a0ea8a520e upstream.

When the device is disconnected from the driver, there is a "dangling"
reference count on the usb interface that was grabbed in the probe
callback.  Fix this up by properly dropping the reference after we are
done with it.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: c46ee38620a2 ("NFC: pn533: add NXP pn533 nfc device driver")
Link: https://patch.msgid.link/2026022329-flashing-ought-7573@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -629,6 +629,7 @@ static void pn533_usb_disconnect(struct
 	usb_free_urb(phy->out_urb);
 	usb_free_urb(phy->ack_urb);
 	kfree(phy->ack_buffer);
+	usb_put_dev(phy->udev);
 
 	nfc_info(&interface->dev, "NXP PN533 NFC device disconnected\n");
 }


