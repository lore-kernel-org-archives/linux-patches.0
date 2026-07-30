Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4C433D4E2;
	Thu, 30 Jul 2026 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422550; cv=none; b=kuq12BYi+dgZToHhf0sgg6bO+3YECplLrZHvMvYPptXydOZ8p9FxiSvRqa2EFDwTo8iQe4lJTug24HV+1vK3H2jzBuDtWWK07EmjHYC1CTrMNq+WMS/pugLYrPU2jX/7vocP9f44lNuV3/Q+HX0731lecVVbP2W6cWaiLSJIBvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422550; c=relaxed/simple;
	bh=iU3XaNIuDRvTlFZTW3igLQ0CeQvRYRRzMf85z9LiqKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cf1Lu9S/nIoLnQ/Sj/mu/0FsIVIwvYMhGjawYEIkd2Bz7F/+yX/Io9KbRoAMsdP2BsKDDhDHPiBWjaWDrWfCMDkcxKHuBUFMfTD0iPPF6WN39FdPHEIzwgt45gv9NsyNB2m9hoA+9pqYVhYhUbFzSQKBMXIzpYgg20PEnGOS6R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1PJKdguS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1PJKdguS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A341F000E9;
	Thu, 30 Jul 2026 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422549;
	bh=kezxludmddGz5kuzLZTX3fsvYNHnImGpqQe4p6iIXFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1PJKdguST7eXWmbhT6uwM3GJM5yS22N9Sdq1LyVooeNi/QvqVX9bx5igYwRk8QVe+
	 RgIsFeVMqLfDxMtvJD6CVNQTgv0e/G2X6jHMhIq219bLuUjdQscLtBiuCB7Ngvsjer
	 +c7uX9GRhe+4rzGv4qI2ky42qmmFN5eqXT2gKHTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 477/744] media: cec: seco: unregister adapter on IR probe failure
Date: Thu, 30 Jul 2026 16:12:30 +0200
Message-ID: <20260730141454.433445758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -649,7 +649,7 @@ static int secocec_probe(struct platform
 
 	ret = secocec_ir_probe(secocec);
 	if (ret)
-		goto err_notifier;
+		goto err_unregister_adapter;
 
 	platform_set_drvdata(pdev, secocec);
 
@@ -657,6 +657,10 @@ static int secocec_probe(struct platform
 
 	return ret;
 
+err_unregister_adapter:
+	cec_notifier_cec_adap_unregister(secocec->notifier, secocec->cec_adap);
+	cec_unregister_adapter(secocec->cec_adap);
+	goto err;
 err_notifier:
 	cec_notifier_cec_adap_unregister(secocec->notifier, secocec->cec_adap);
 err_delete_adapter:


