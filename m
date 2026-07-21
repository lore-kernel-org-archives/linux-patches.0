Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3A8442100;
	Tue, 21 Jul 2026 22:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672559; cv=none; b=s+C+FXLra4PHanLEGTqQTybwfoFzdakgLsaOhwo4d4qyyDJ9dUYZrJT4eLjG475bKFSVaYrSVBZCp0n4hcPXA/BdnFtQIPG6t8Jy6mQZG8OinBvYa9w+/SRizRDUbFwMUmO6su4GxmH6Vxc+99Z7H5JXy2Di1IIojsV99r+aKaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672559; c=relaxed/simple;
	bh=IYE0YMFaQfyBtw15s8W3WEPs9LnoPdFuy7c7QvndGzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqURj46+EyyzUVdGQMPa780RZt146Yk1K2sAK2W6rxVt1qhKhg2vruwAkyDsmO3uaTLfsYIxQCUX/ViBcRinQ2gU31H+3rM0u9SjqwJntXCEy4icwobBNU7S92Lx7ultJXWLlYJrGUvRuZqGNTeJGYxdYs0O26EBpX2F81Ezr1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4m/VmsX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4m/VmsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721811F00A3D;
	Tue, 21 Jul 2026 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672557;
	bh=qvBVHCBOMpKAkECKI7NdbaCFCUvwNfnfi7BsTqTq+iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4m/VmsXDdqYyhl549Be4r2MZDvdbcgYM5cfYmZYs6LMYvymVARvBGQHT+ns1AreK
	 VqcbBFOmRNo/9m+QRwECl+xOSQRK4sFfBsNiLAdhFfMxTgRyEG3kqOtj0s0tH94yM1
	 uzD5HoKvsqIuguI0cYMMOpM/E7YP693nndmX4p0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 669/843] Input: ims-pcu - release data interface on disconnect
Date: Tue, 21 Jul 2026 17:25:04 +0200
Message-ID: <20260721152421.111952671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 441c510a649c8ddce38aa0311334ed8bb546b36c upstream.

During probe the driver claims the data interface, but it never releases
it. Release it in disconnect to avoid leaving it permanently claimed.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -2085,6 +2085,7 @@ static void ims_pcu_disconnect(struct us
 		ims_pcu_destroy_application_mode(pcu);
 
 	ims_pcu_buffers_free(pcu);
+	usb_driver_release_interface(&ims_pcu_driver, pcu->data_intf);
 	kfree(pcu);
 }
 


