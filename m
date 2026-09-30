Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D220533DEF9;
	Wed, 30 Sep 2026 18:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792158; cv=none; b=uFGZbt0RgimV8DwuvPNvl68jaTMPdNONawykPlU7nrdRRC/ZgzWZXawQAng2bUtOk9TAoUJX5HamVQ/dvaOj9mJ+mcdh5FoVHHPLEeir9m/BV5pgbEZzHnl3UCQriBxmCD/nNEyDvQceB7UgHQb4Z8MBEUh+gN0eQ0HDiz4aAw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792158; c=relaxed/simple;
	bh=MGKCdN3KGeNC5vLXwCEv+TnmhSELi1CDXK5iOaSuVlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e3InarJf3uGpmh5Af9PrZFSGpnDgfEkPRxpkyQpllgegHVAMg1kJSZuw6IOSBbeXvo1VpCCcyrq75uiEiVhzh0zKE8yT1RMyClZ7YA3hVyFCOuAQ01C3XeGMM/nZSoD5HIc7d7LkfAkd/tQFszQQPbtheSZ4nekz3o+HUb+UEes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7tQqo1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7tQqo1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA811F000FF;
	Wed, 30 Sep 2026 18:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792157;
	bh=tV5yqJ2kqiuouW9cXEIggIabNv0e9wdznT+FfICvtbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7tQqo1/eRjS+x44cz+qoU8IEgESh0Cpm/lIHg+Xvs7hiChGdzUmjrA5342lrhnuA
	 TtwBLlyQDlT9v/+QJOsVpDVfwjcoapZBU3TLu0K7B+UItwTtydFjS6+bfyfqTor5qH
	 ii0EN6iLflYqaNyE6iHHPkHLvRPX328PkeGhJ0cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 554/752] Input: evdev - zero absinfo before partial copy in EVIOCSABS
Date: Wed, 30 Sep 2026 17:27:04 +0200
Message-ID: <20260930152410.232628168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1231,6 +1231,8 @@ static long evdev_do_ioctl(struct file *
 
 			t = _IOC_NR(cmd) & ABS_MAX;
 
+			memset(&abs, 0, sizeof(abs));
+
 			if (copy_from_user(&abs, p, min_t(size_t,
 					size, sizeof(struct input_absinfo))))
 				return -EFAULT;


