Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B4F442B39;
	Mon, 17 Aug 2026 15:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979476; cv=none; b=NsoHsNShigSWJnUINlm42gmfQ7S5aTHMeHqzZzLME99F+2qy4kb+Rb7niel0TP1aPZ5aNZpvhBfJABIEVWk8uICFYv18F5dEwxWaTFQ0j/SPcks/lz5J7SI9YsxJL4UZNx+5p+YS9Gyib/9sMhv/kWkFoulC9m9MQcRonRibB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979476; c=relaxed/simple;
	bh=FHGlIKqDpw4biz0DLnpBZNEvqqdY8buDBq+OQQBox7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzQoF7ERini1O2FJVf+FJ+oAYveAw2LaPAJPwnd+iG6uMPiStSbol3Rqr7i8U6u1KnRjWbIlyRqY9iy5BoNeh+4jGEoH7bv5w4+30rAMN5a8uguX8zuSAUJnUjxyiaPjtzhM1iBxjiftARaIGeg08JunuUBHXbDIqsDbpI1UbVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LokdFtop; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LokdFtop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA5D1F000E9;
	Mon, 17 Aug 2026 15:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979475;
	bh=Cvs84ywaKmEd6eBNRR3W5qfG6g0EziVD8rQDvkTfWAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LokdFtopoSOjcuIp/UC1rRyeV8Wp2ZEsfcprcghzSHEvKpxamMtc7myXOlh086SlD
	 s85zb0vTmQVO++YWigi4t2XsGdeHQ4+zLlnssLNfwBhKHD/ajGfmzlZ7JMKHDP5OSR
	 HyFrVDAUL4jLTv0eLuh1yYuuY7fw1uno83FL8z5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 190/609] media: cec: seco: unregister adapter on IR probe failure
Date: Mon, 17 Aug 2026 15:28:06 +0200
Message-ID: <20260817132550.432081945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


