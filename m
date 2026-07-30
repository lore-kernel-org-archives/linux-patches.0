Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD69395AD2;
	Thu, 30 Jul 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427622; cv=none; b=fT5G1gU/ae3SQ0N32WgAst0JYw2Kwt7GIM7iUCVsSkTBDOpe+ULCZFH5vOaypdvKoYCtJO4TECLpdKCUrGCCYAGJGZV4imNOR8pltF0/jhZogqLIAGcvKGvQu2ETK87jn0x0UADDAOi+cIQiLRyFkXR93bM6GW0Q1+vwD78ErxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427622; c=relaxed/simple;
	bh=cl1FnGjR5j4CBCZZtWxgEmwJM0dm6F65z3GkeKEXB4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYjGxdtmQldXTnt60QRC/aqomfOS8s8Z43mQeP3/ZNuxia0I4EEkBITja6EqU2olT8h75dqc1KSkgZXjjw/MQ83HHnphRXytxTtP6j1k3TGmp4H19EfsnOqASpBVajDkap8kJXaQGUONyI+GxlmtzSxUTD/V5erAAC6DHkP0Cxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqGOfjBc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqGOfjBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013A11F000E9;
	Thu, 30 Jul 2026 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427621;
	bh=PxQEZtq02jEhZU2m2tAGACu974e0zZ6SrF3Tz1j+aVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HqGOfjBceT33kXV92iXJGHudzRLp4YBhZCf/80XrU+dD7JX2dYIRh7GGlsPglYVJ0
	 IGb2fdFiGZDH1zNxdfXBtAsfV1LZvyGxxqF3AiLCn9AXXKiRH9ryGyZE/iLBZO0tOY
	 N7bNESFHKKkCa86AX2JebAu78D0PD6cFwro7xM5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 236/484] media: cec: seco: unregister adapter on IR probe failure
Date: Thu, 30 Jul 2026 16:12:13 +0200
Message-ID: <20260730141428.603361411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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


