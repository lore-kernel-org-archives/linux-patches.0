Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576803161A2;
	Wed, 23 Sep 2026 14:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173828; cv=none; b=Fcmp6jzJSDqq85Gpzwf4LSpgFPP6gJLSBGbkR15Vb5TW5DAE8cG+9kMkkh63rJDg0Ti7m3P+XIOLRlfxGDGuAYmgl4qgfPCVBihEMm6dFNB5KY5eiKMpbb5/4dre4a8n/bN7u0Xo+7CS2ccLb1/8QUFvTlCW8y2XdqkwExw4Oao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173828; c=relaxed/simple;
	bh=tKMaNlRrQbUEt6Vh65U7fJalcr2uSc/tw2ly91GNcc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJof0k3OtCSiIsStFBWQeF5AaoiH/UnQrlDOJBT9S5YPi2nVRz/tGTy+1PuBNqjYk6llBkgddD+RkSVLKO8WFS20jJwj2DrrIVdEBaBVbXRqlNfntEOYsU720gTFA5ra5hg/WQTO2NA48fz8iyRto3hZsEw7xuqejW1/jjXx3JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwzyegqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwzyegqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED741F000FF;
	Wed, 23 Sep 2026 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173827;
	bh=5837BCxOPOrJj3QC3hP0BfJpP8ow4RlpQCyLqQnYZkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwzyegqw9Py1o09910YO3ghTDR0CkQ4ofZU/vsPaeUWOcm9SznNUL/AvbOaCV+VyJ
	 lOSh+kqURgk7aYM+9qMCGBCdwdXbxWYfu3RA3Yzg/GDWkOnTXWBATXItKLfJ/br/Ih
	 7VPGhuEooE3zNSStRBT5hf7BJCOoRiquRQSHHeho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 356/438] Input: evdev - zero absinfo before partial copy in EVIOCSABS
Date: Wed, 23 Sep 2026 16:06:17 +0200
Message-ID: <20260923140654.064052073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

commit 8b852965b8eaf910c314dc346967ed82c8d4f235 upstream.

The EVIOCSABS handler copies at most the user supplied ioctl size into
an uninitialized on-stack struct input_absinfo:

	if (copy_from_user(&abs, p, min_t(size_t,
			size, sizeof(struct input_absinfo))))

The size comes from _IOC_SIZE() of the ioctl command and is therefore
fully controlled by userspace. A short size leaves the trailing part of
the structure holding whatever was on the kernel stack, and the whole
structure is then stored into the device:

	dev->absinfo[t] = abs;

EVIOCGABS hands that back to userspace, disclosing the stale stack
bytes. Only the resolution field is currently cleared, which covers the
legacy struct layout but not an arbitrarily short size.

Zero the structure before the copy so any part not supplied by the
caller reads back as zero. The existing resolution fixup is kept, since
it also handles a size that partially overlaps that field.

Fixes: 448cd1664a57 ("Input: evdev - rearrange ioctl handling")
Cc: stable@vger.kernel.org
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Link: https://patch.msgid.link/20260901130629.24078-2-ivanrwcm25@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/evdev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -1229,6 +1229,8 @@ static long evdev_do_ioctl(struct file *
 
 			t = _IOC_NR(cmd) & ABS_MAX;
 
+			memset(&abs, 0, sizeof(abs));
+
 			if (copy_from_user(&abs, p, min_t(size_t,
 					size, sizeof(struct input_absinfo))))
 				return -EFAULT;


