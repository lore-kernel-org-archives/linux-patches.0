Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A243F4C0;
	Tue, 21 Jul 2026 22:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673120; cv=none; b=bbb5uKsfu3gxp4lski8uZhNHI4EElw4DhTYFcPl6jvhKokId/SKPgJHOXuhtTrovzUwKQBftc+V6OMtR+GlQU8A6WakFZlmpJlQOMo0ea1PCLq4OD4wKbW+Gak4RexdBrpRfnjytTZlT6RNtbIygueBxU1UFYnS280k7jhCaAHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673120; c=relaxed/simple;
	bh=Z8XVEH5/Y6MQxEWUSbQtpg/nBiPPTGyyqUmEwN9pEws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdlR/c8WxAJkJIlexZoGbK07sirHp0CGkdenJ0Q/rxX90kJEmtAvxfPt9ShU5cEBqQO37oMX0LNn/Ep/d/N7GROsFPSIPAUP233I9F0ScdRSj0Kx8HBZxZvW9xOAzhtbJZ/65VzARMaFLRqbLT/PnubMERJ5LEptfJ9z21Gfwh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kG6y+9Vc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kG6y+9Vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D8B1F000E9;
	Tue, 21 Jul 2026 22:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673118;
	bh=6Os3+cW2wIjtqcpEFYGT60X97awwS4R54ExsBczmWMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kG6y+9VcyGfTPjqkmF8BjPz1Q8OGOhWMUtb1i2X+soUoYZIKzd7OW90/rb9TbnmAR
	 AWEVylIamQCTP5b8mTKFPaX8TEpd3eFRB3YUf6v9mN3yd7Z5BtjOrJOWWiNC3wqPr3
	 lRhNLZvnVE+lSen2Gy0P4YZHW/B1YIUCRvMGCjiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 043/699] iio: imu: bmi160: add IRQF_NO_THREAD to data-ready trigger IRQ
Date: Tue, 21 Jul 2026 17:16:42 +0200
Message-ID: <20260721152356.680859004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -801,7 +801,8 @@ int bmi160_probe_trigger(struct iio_dev
 
 	ret = devm_request_irq(&indio_dev->dev, irq,
 			       &iio_trigger_generic_data_rdy_poll,
-			       irq_type, "bmi160", data->trig);
+			       irq_type | IRQF_NO_THREAD,
+			       "bmi160", data->trig);
 	if (ret)
 		return ret;
 


