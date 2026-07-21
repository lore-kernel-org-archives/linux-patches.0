Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EF33EF652;
	Tue, 21 Jul 2026 20:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667563; cv=none; b=bE4OYFzVX9h1ebmWz+YZzHOJ6cr/gFrCmMz22SEjiekD8uSdYSBaxSi97MVk9C8oPiQu+3HVro/YdtuRbsasxQAMskjVmDtmSM76MqepivGYdT96VtRNoc8Cgt9PbNEmc3egHbM+HplqgYc+mksaGVjnlWaK3dL0V7Jut43KOxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667563; c=relaxed/simple;
	bh=/FINbzIgm3EkRpA8gZ/FLSv1YoEli4/MG2+xr0yOISQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cvw3nS+uFqStXfZYt0vGgARzfiCLDnypc043NTI+E0w2Fgom+SKrs9kf9HUT3PRu84JQBOHUYLwobHgobHIUl++kmY+keF8KI4MDSDXrlFoYeKuMqMnQ6YElB5GlqMVSfh+hk5bt7P6p3S7hd29/HIlXfdJi5MwAXHhEjDpUHeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJa8JDxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJa8JDxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C28D1F000E9;
	Tue, 21 Jul 2026 20:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667561;
	bh=MfvrSMjXqtlvEgEoKpipVvWxME6iXHHq8Xo+OVlQsIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJa8JDxJDXEDm04RMszUcd1AaSIdqe3b1vpjt/t9fVxCwr7om24M4c4AmNGlk7JKv
	 VWYpfL4CKKEUuJtBJmytDuXn/QfjhVcrPIOld3i4PQ/UKVKYIvshkSVY2vB98PZqq9
	 YQ/rcGlnbBDxLoYJB5iKYEhMY+glxe+q/tOmuceA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 1066/1266] Input: ims-pcu - release data interface on disconnect
Date: Tue, 21 Jul 2026 17:25:03 +0200
Message-ID: <20260721152505.675068207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
 


