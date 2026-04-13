Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1B0333429;
	Mon, 13 Apr 2026 17:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099726; cv=none; b=lK1+1svPa2kDuzqQqbuGe2fgrIi4x5YQBvw0Mt9ABwIaD6C4ljo5AUmicWUgWm3IPgrXCMdMBVUT9DpJvbQpphnJ893GgN2Qaft1cKZu5V0msfW51RDoVZlYKtRxwq2C9cWmwM0qFVhjUhXCukBsqRaugDgUG+k7RWWxBG4q7JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099726; c=relaxed/simple;
	bh=ohpOrWqelUVWQphQbdfObM3IJ9BNz25k93y9qDTmaVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLT5FB+ZT/nB+PYH8ID6er6HxSSnQ/iYzPXe5PdiRAJgrUx2tsLgymi43nU3Q8UQYvXhT20f64bzbGaEzE8YbP3YxlVOOTHpJ5/vhEqw0zucq71bf1NbOqvMKTEYcpaqBrKGumV0ZuKrVHiSTNBsVfeff5DbeNlAWpEWFSDwffc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODPjxnWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODPjxnWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65191C2BCAF;
	Mon, 13 Apr 2026 17:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099725;
	bh=ohpOrWqelUVWQphQbdfObM3IJ9BNz25k93y9qDTmaVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODPjxnWQBqWp5XL112QdMJhjn1OUfXD9CIOHysbhrdSkmAjyl+mLWM2XsYNOiibRw
	 BR5rEXlxjt6LXuWXMM6nidePBHOL1KX4d4eSnWA1bhYdWwgU1pWIP1hu/tSrf4IPRo
	 sHJqxRWCQB64zHiVZt9kusYbhhdzhddK2INCr9pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 449/491] mmc: vub300: fix NULL-deref on disconnect
Date: Mon, 13 Apr 2026 18:01:34 +0200
Message-ID: <20260413155835.838657424@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit dff34ef879c5e73298443956a8b391311ba78d57 upstream.

Make sure to deregister the controller before dropping the reference to
the driver data on disconnect to avoid NULL-pointer dereferences or
use-after-free.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2371,8 +2371,8 @@ static void vub300_disconnect(struct usb
 			usb_set_intfdata(interface, NULL);
 			/* prevent more I/O from starting */
 			vub300->interface = NULL;
-			kref_put(&vub300->kref, vub300_delete);
 			mmc_remove_host(mmc);
+			kref_put(&vub300->kref, vub300_delete);
 			pr_info("USB vub300 remote SDIO host controller[%d]"
 				" now disconnected", ifnum);
 			return;


