Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E0C18A6A5;
	Mon, 27 Oct 2025 19:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592764; cv=none; b=hYftrXij9Mat7UPUfcWH16Qs7Tf/rRd/nBDNJNbZ1PjbDLfqK5Xpgq6xbzJEOxXKsC+SUEVg8oCNnzWz24TVtUkkrxp76R3aopYuvCmWmDv3lBhMThKQPVZN7227fppi1y25wigkaHELTWxmL7Q7kU9JUGJ6ovdtdtzFK+5ClQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592764; c=relaxed/simple;
	bh=qzXg1hO3zoj9YFs2mY7Xk8zry7k3f16W5rEzTXBvZPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rH+yQ/z6/0B018Z16iK6epm72IMKlTXnrokN4Abgd2ZWsOiuT6X3EDyK87zjs1tfHOQPZIoWUT7VlPhm28ohww2Aep3MVsq53wEfBGzR/c65EtbTlSmICaXauLtWrssJZY59XkRAmI4wQW5cHU/QGTURVm1vaRqUXeptbTEZvEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1rXoFDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1rXoFDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992E2C4CEF1;
	Mon, 27 Oct 2025 19:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592763;
	bh=qzXg1hO3zoj9YFs2mY7Xk8zry7k3f16W5rEzTXBvZPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1rXoFDbAUuS7i2z1aMxCvdjaPTPFn4rx5tQl22B+hcGP05nSzd1Y9Rk2+XoLgPwJ
	 alc/4w0W4SUxbQstCGj7mudZ+H8pXLQdfKLCA8f+ksiGY9kWzTQe4DlcFtN6lDL+fW
	 a94Nozz30UbJSWifHg2qlkc7ZWUnSPn5jKCu49QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: [PATCH 6.6 63/84] usb: raw-gadget: do not limit transfer length
Date: Mon, 27 Oct 2025 19:36:52 +0100
Message-ID: <20251027183440.493497259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

From: Andrey Konovalov <andreyknvl@gmail.com>

commit 37b9dd0d114a0e38c502695e30f55a74fb0c37d0 upstream.

Drop the check on the maximum transfer length in Raw Gadget for both
control and non-control transfers.

Limiting the transfer length causes a problem with emulating USB devices
whose full configuration descriptor exceeds PAGE_SIZE in length.

Overall, there does not appear to be any reason to enforce any kind of
transfer length limit on the Raw Gadget side for either control or
non-control transfers, so let's just drop the related check.

Cc: stable <stable@kernel.org>
Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://patch.msgid.link/a6024e8eab679043e9b8a5defdb41c4bda62f02b.1761085528.git.andreyknvl@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -620,8 +620,6 @@ static void *raw_alloc_io_data(struct us
 		return ERR_PTR(-EINVAL);
 	if (!usb_raw_io_flags_valid(io->flags))
 		return ERR_PTR(-EINVAL);
-	if (io->length > PAGE_SIZE)
-		return ERR_PTR(-EINVAL);
 	if (get_from_user)
 		data = memdup_user(ptr + sizeof(*io), io->length);
 	else {


