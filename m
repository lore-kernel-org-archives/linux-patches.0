Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8847424A078;
	Tue, 21 Jul 2026 20:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664990; cv=none; b=T/vio3pvRHaoBO3/UFZy8gw+6xyDg2Wm9BxvIs1V51Rbtam1xeKyYM016j9hglRsdmWI8hywp05TqgqnSBLcudwpdW9IFjr9Y9xsIwMQb79LA3kjHXrSPaNvclBsnTfxnefyAl297d0QTOCn+9p07W1ASSHevu9dRMJ7C5elQZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664990; c=relaxed/simple;
	bh=KwT/iflPGihdHyvKUwq4JupWobhZlVJc3/xLrVXtt/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aICQ7rEbqMytOlYiwtQqtsYkkiwI2sZCmU8A3FYeVE99TYh3YeasRzU0D6RRdlPNobmiqZOh2jIKd/Em6ICZ+U16Dxr0V11Kb2JHVSi2ELIJKvTOOwewgFJ3LJ3h1E5sk+/HH1Bv0QEjus6pEimQXSiT0iGb4qPWFwSp824vWxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urYf2GUs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urYf2GUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4861F000E9;
	Tue, 21 Jul 2026 20:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664989;
	bh=Y8mCWTYEO0C0BPToZmnP8NDFKeWcJIEyQTYj+IUk2EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urYf2GUsjftYSZtuOq0jM7WkbkaOF3e67C4aFsrEOeB0eYCkq59jPXi0FgeQc+N9C
	 J9nSrGa7tADr9Q5P0rXoeYZG0cM962x5/Q76PY8Zxfs+M5FCP26GS/sRmGfUo9Qlfr
	 ZxmvjAsV4MY9XegSbWIh29101vXu2Ep76+YRfST8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0092/1266] iio: imu: bmi160: add IRQF_NO_THREAD to data-ready trigger IRQ
Date: Tue, 21 Jul 2026 17:08:49 +0200
Message-ID: <20260721152443.864268845@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit cd5a6a5096b246e10600da3ac47a1274ce9573c8 upstream.

bmi160_probe_trigger() registers iio_trigger_generic_data_rdy_poll()
through devm_request_irq(), but it passes only irq_type and does not add
IRQF_NO_THREAD.

When the kernel is booted with forced IRQ threading, the parent IRQ can
otherwise be threaded by the IRQ core and the subsequent IIO trigger
child IRQ is dispatched from irq/... thread context instead of hardirq
context. Because the handler immediately pushes the event into
iio_trigger_poll(), this violates the hardirq-only IIO trigger helper
contract and can drive downstream trigger consumers through the wrong
execution context.

Add IRQF_NO_THREAD on top of irq_type when registering the BMI160 data-
ready trigger handler.

Fixes: 895bf81e6bbf ("iio:bmi160: add drdy interrupt support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/bmi160/bmi160_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -784,7 +784,8 @@ int bmi160_probe_trigger(struct iio_dev
 
 	ret = devm_request_irq(&indio_dev->dev, irq,
 			       &iio_trigger_generic_data_rdy_poll,
-			       irq_type, "bmi160", data->trig);
+			       irq_type | IRQF_NO_THREAD,
+			       "bmi160", data->trig);
 	if (ret)
 		return ret;
 


