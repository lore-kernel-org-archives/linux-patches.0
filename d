Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8EB171675;
	Thu, 24 Oct 2024 04:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729744929; cv=none; b=SGRfqMNdF3/qNwcFXSfzg1QVRLDemip5xGUu1chQMbWbd09xLg3s0PEWBBXXgUs6heE3T71Kd2QorXdZzDCAnHdcUXPBgjHSW4JsOWjydNrzIldaClBpl7sr4qd86FVTy1gS33Nk9MpJmqm5CqBXtztZAFiu1AI67SNzRL8nuQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729744929; c=relaxed/simple;
	bh=/E05jT6POpOqZDCpwe8J4QUwk/2Ud1uqQgjbaLBTXt0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qe7SXfWJeqMkBqkBNX+jZ04P6GKiGbO2ltLOqohlDiQmUKkTsHZ74cgn8yzHBqtC+6DJGH4YeGaS7QKAA4J43B9KWvjg5TmwweKNB7l6wzbHEii9kDGkE4SvfTZMXZVL7ZEMFE4+ZKo88KH/StUCnNXQKspQU+uC+lrJda7k0Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LlBxOEkv; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LlBxOEkv"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3e5ffbc6acbso326304b6e.3;
        Wed, 23 Oct 2024 21:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729744927; x=1730349727; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/E05jT6POpOqZDCpwe8J4QUwk/2Ud1uqQgjbaLBTXt0=;
        b=LlBxOEkvORrvRkKVp1JjVelLQyOrPCFkKJ765OFH2j+7TjZDw3ZQfgxS5aso5gcu1U
         yAw27O3JzyXthSn6EykAORZmoKj1ElUhVLl0Q43fDVNb4d79DSLUnOx0Z0Eb59MKDoLr
         TJbc5OvBo30mCoPD4Bx0mhV3e0JWONqHAjeaX/Z3Nt7xJta932aI6/MH4xdCfjNweBcW
         hJbOrwVY53tMoRNNC3GrqyrwLsSy1Xy+KbErLdW1dyQbsUk4EWAuaQyy8/SyvVWpelgM
         jrJWGvW16WhP+F9WYmHMe9+YvIom2aSauYii+3Oe7yFLhlloPKFJqvqB4MSSEPTYUTog
         hJVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729744927; x=1730349727;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/E05jT6POpOqZDCpwe8J4QUwk/2Ud1uqQgjbaLBTXt0=;
        b=sOmFnTofugNOIZXXbqjMTirbKtgcTkAsiCmtGyUOMSkMytQ3HcgrKo5/SocZtjXN8E
         TyBqgakGmOrtLbgfpt8N8MGIQeRSyrHSVEPI+xcWbUcS9B7VcEb0MMyA/9fSjawX6f/h
         tXpHKzLs9qlGft9oGS3X6JwgHtoste7Xivf1B2cluJSGICUBfV+L4l+6Z33Fo17ZaIYS
         u1pl1xj7HvJg+/YZQLoCGl+GzHSr9oy4MNFAkLyb3hmJT9vfafd1AjLeEs9Gqrls031E
         bUs9mRbqsPpOImDX0ie3e0tMiktPyOsgvllcrKPdkZUq2MgBPhmV+nFwAQVVhAHWRibg
         6bkg==
X-Forwarded-Encrypted: i=1; AJvYcCU8/uvn5QpvKU3kw7NDI1muHIFwVHd0KpG3azfgo79NL+CgdjqRi1y9XpPrK5+N1jT6R3M=@lists.linux.dev, AJvYcCVi9eFUIoP3TFf5rgu1WmWRN396aGEzqoxUWouyhR4p2jbnCFS90btt6KJuX0c8b+JCGzD7HO6XgQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyBjNrxHJhq1pVJwi5DZqB/1XGMVQLFZDG8U/OrZOtUkIf0BXho
	Uf+hrTze8pLctF3VLvK6swS5827ktrjLkVc3hHS6vKhQ0juENyIgd8Zc2aK70HlXx0XnafhK9Pz
	I+SI5DORJXD6TPle0gBJsrpLTZDc=
X-Google-Smtp-Source: AGHT+IEcPxkLcRYoYZ+qYqdz3rf9C8aaTqIgeoOwaGj1dLh0kiz4T/GQTSq6ljBIHvhnOb/5OXIeeI806cLnduNI9A0=
X-Received: by 2002:a05:6870:3324:b0:286:f2cc:7a4a with SMTP id
 586e51a60fabf-28ccb9e54fbmr5220982fac.34.1729744926679; Wed, 23 Oct 2024
 21:42:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Ar Worf <fricks6@gmail.com>
Date: Thu, 24 Oct 2024 09:42:02 +0500
Message-ID: <CANSmiqmTobiHdS3zi794hg=rmvg6ePWDp7_vhgMD4_Sb4by7hA@mail.gmail.com>
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
To: torvalds@linux-foundation.org
Cc: aospan@netup.ru, conor.dooley@microchip.com, ddrokosov@sberdevices.ru, 
	dmaengine@vger.kernel.org, dushistov@mail.ru, fancer.lancer@gmail.com, 
	geert@linux-m68k.org, gregkh@linuxfoundation.org, hoan@os.amperecomputing.com, 
	ink@jurassic.park.msu.ru, jeffbai@aosc.io, kexybiscuit@aosc.io, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-fpga@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hwmon@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	linux-spi@vger.kernel.org, manivannan.sadhasivam@linaro.org, 
	Matt Turner <mattst88@gmail.com>, netdev@vger.kernel.org, nikita@trvn.ru, 
	ntb@lists.linux.dev, patches@lists.linux.dev, richard.henderson@linaro.org, 
	s.shtylyov@omp.ru, serjk@netup.ru, shc_work@mail.ru, torvic9@mailbox.org, 
	tsbogend@alpha.franken.de, v.georgiev@metrotek.ru, wangyuli@uniontech.com, 
	wsa+renesas@sang-engineering.com, xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"

> I'm Finnish.

Said a descendant of Swedish occupiers. Ooookay.

If you deleted all the code committed by Russians, that would be at
least understandable. But what you just have done is refusing the
people who contributed to the kernel due credit for their work, while
keeping the results. A totally imperialist mindset.
