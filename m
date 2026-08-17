Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EED3E49E0;
	Mon, 17 Aug 2026 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975706; cv=none; b=r2pNG1XMNotV+h1PKHOWqH1yTEzXwEcpieKPvOSVF1iOaMWitg4rg9wHkfORK1Z76dAD0T4/eCecrPAh1b+Y/DpImtCaJsI6y4IuI4mUYHUmhzEe8Rh2fK6YWak3KM6WgUfJxw3zaKzrnjuALa7M5o610DycdzEBVxOzVrT6y7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975706; c=relaxed/simple;
	bh=mcUxhBjhNqvtbvD6izaNIcbqMY97EuVq3KTktQSfy1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPi+vcjM5qIhyK43pk1p8v9Bev+IhiXoYqf5HPUKor4EhDwAjydwze04PY43A8590tRvFDrHCAm6VOCKN/gTEHIs1LcWr4pq4fcP8wZFFCd3Sf+ixPusnFsIWCRsucmeI1nFh0jE6Gy8h4LOPI+Wx/RYIiRKEqA7231BFnzKhKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGBTdnVN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGBTdnVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD6B1F000E9;
	Mon, 17 Aug 2026 14:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975705;
	bh=OBVdKd6ObLZXWFCXXjP8ImA7tDPjqcHDArpOsGSl40c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sGBTdnVNx6A2mQXbfLfAHd3u6uEUfoweW4yQwYikj0wF+nUDCX2lvoSE6/JQFZYE2
	 Pd1fSGu0UIcIkTrNeQJvL5LpriCV34T+AXcSEuuCPqm7eP5wNjihBdom3GuRKj3BbJ
	 dusnutne2cAqfbrRWBmVMIYTZzChWfW4NSrd7Zzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 121/389] media: cec: seco: unregister adapter on IR probe failure
Date: Mon, 17 Aug 2026 15:29:20 +0200
Message-ID: <20260817132543.882041290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit c3a78691be8245e52ced489f268e413f18061ac2 upstream.

If secocec_ir_probe() fails after cec_register_adapter() succeeds,
probe returns an error and the driver remove callback is not called.
The current unwind path unregisters the notifier and then falls through
to cec_delete_adapter(), which violates the CEC adapter lifetime rules
after a successful registration.

Add a registered-adapter unwind path that unregisters the notifier and
the adapter instead.

Fixes: daef95769b3a ("media: seco-cec: add Consumer-IR support")
Cc: stable@vger.kernel.org
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/platform/seco/seco-cec.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/cec/platform/seco/seco-cec.c
+++ b/drivers/media/cec/platform/seco/seco-cec.c
@@ -662,7 +662,7 @@ static int secocec_probe(struct platform
 
 	ret = secocec_ir_probe(secocec);
 	if (ret)
-		goto err_notifier;
+		goto err_unregister_adapter;
 
 	platform_set_drvdata(pdev, secocec);
 
@@ -670,6 +670,10 @@ static int secocec_probe(struct platform
 
 	return ret;
 
+err_unregister_adapter:
+	cec_notifier_cec_adap_unregister(secocec->notifier, secocec->cec_adap);
+	cec_unregister_adapter(secocec->cec_adap);
+	goto err;
 err_notifier:
 	cec_notifier_cec_adap_unregister(secocec->notifier, secocec->cec_adap);
 err_delete_adapter:


