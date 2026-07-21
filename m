Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2464B46D0AB;
	Tue, 21 Jul 2026 18:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659058; cv=none; b=DAN58SPM29P+pXuHrQVhk8JlNFA7dXoV8Av2iBf6VKX9mNmf0x/RSGMFIRkIYhdCoWEvAoqeJ4SkgXag4nShUTEdW/vRmmuRXx03VXr34AocDP1DKHAWoQ7l9HPFX4utPiHsFygjrlEohmXQ5lss27AcEykDbqgCOiZnAHYGdIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659058; c=relaxed/simple;
	bh=buKv4WnvDCfEOk5hNd5Oow1pb7Q5JL6YXYfU0UxEX6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PueEm8Tl/bgliGcXjQ1zbOS0U4Q76FgyF4rXhPbLmmYN+9FtzQ+2vLX830+TAw17w3F7gl9PGH/b/I/YRHoXRGgH/UAI+maYJWC0aR+EZXbKB+eg1axnyCtnpeoriy4NiG8YnSXj3+rNG3EZAWD1t3yY1YGS4fPfvNEXCiBGcKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMIwe39b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMIwe39b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A541F000E9;
	Tue, 21 Jul 2026 18:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659057;
	bh=OtfIOpOKCsOTa8CaepWRORhs3+167eR9YdgckxUpYXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMIwe39biqphVZ4YgVUyZer3Db5HjLP5YviNP7EjjJDTJx2Ie7d/vgIhzF6qO30TS
	 FA3678qV2C0L5uBIAfemt7Ui1qV/Au5mXR8+dFh2gtgEYpV0+nSmms1I7OyN5yaTim
	 uf+CR6cyvut0DmJKGJ1GMhgF83mAuwFN5Sp+UnWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 1376/1611] Input: ims-pcu - release data interface on disconnect
Date: Tue, 21 Jul 2026 17:24:52 +0200
Message-ID: <20260721152546.395076600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2076,6 +2076,7 @@ static void ims_pcu_disconnect(struct us
 		ims_pcu_destroy_application_mode(pcu);
 
 	ims_pcu_buffers_free(pcu);
+	usb_driver_release_interface(&ims_pcu_driver, pcu->data_intf);
 	kfree(pcu);
 }
 


