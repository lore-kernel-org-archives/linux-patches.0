Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E34938D01E;
	Mon, 17 Aug 2026 14:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976935; cv=none; b=ZvGqEOtjceOwnbkmIPy+d//kYV24oVh2wiBY3zs9311SD2PFNvTuzE+KN4G+C7/uQnhiRvV3Wi+dyv6ywz19qL2+xieBfnrBxV0dk1SxhNbYjrmsJc7rkCvfxVlHYquQJJ7fZw2pl6KfVnmeQFbFigEK8GMVJ9Gi497Pq4Zg+mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976935; c=relaxed/simple;
	bh=ejraNiT1TPZ4WANjHAzjmHZdwWAxDPlAA7NdZ5Mqn/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBmZTqM44NscCK6f27seVP5XIWLC8Jf9sWUHLBj6oizKIKAsQveQjWkOXfT93zWlzch7hsLazLz8BDglI11WMc8v0fV9x1vPqGExNPTvO6LpX8Xwmm3h5Nfu5DBo8l9fIC82m000I542iz/mHq8B6KT+UqrXK0nYpRnymOp5MLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uh4Hloh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uh4Hloh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4CB1F000E9;
	Mon, 17 Aug 2026 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976934;
	bh=G2WnUsYSRtzXqHXnL6HS/ApsgKRgRX3jb/Irmr8EV7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uh4Hloh6Dl1S8nG8J8XghyDwFMel18PirZVnpvS8js0HDRd0PCY1DxwfT3nZcnFpB
	 N5c1Xyy2lTsEIwzsUhOkurrrB5slppyTz0q+eTAAwS3q9D88b061tNlx7p/FmdKz2U
	 kt7gEEan4XZLAcMEzDiG5DK3kiwnY1BPJOtRndeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 156/456] media: cec: seco: unregister adapter on IR probe failure
Date: Mon, 17 Aug 2026 15:29:06 +0200
Message-ID: <20260817132546.186037820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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


