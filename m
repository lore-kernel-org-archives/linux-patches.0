Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878E5335B8;
	Wed, 23 Sep 2026 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175019; cv=none; b=b4W+mqfEq5XJ4K2afMWfNuA1Ah/3kNcQh0l/PucoIGNWH/v/K+al+cMH0O92WwnLBQtqQYbA7LIDYaqppNl/IdibWjVSRHnmjPqRwT4EWQi83uD1v2EjtxahgBH6uJVsPPFKl/fyUg62jqv9RkOv5mExi+GMrC/ip/d9m2oXyqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175019; c=relaxed/simple;
	bh=d+SEQNjoP7YuFHfESSrV+lAZSdQI3agjsWOl3uuft74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hxuieeLLecDpA82cr9G6CzdPj0KHOxyX4NNnIfvB9KA/skiIhWdkhFl/baGk2N3zcbhQDXp8pnE62LLwNzmcwfqbFgKRKc9uCJcwiy1mEm+R1vIypQ62I0aJ90YgCN/jNFILr4durPzvp3kMF7R/nW2PAnR4nFqTXraoij1nta4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1DH7tY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1DH7tY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95B11F000FF;
	Wed, 23 Sep 2026 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175018;
	bh=ukCO4E/5C3ifbmLsGYMzQ2UplCdPJN8IeRh3cfblyDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1DH7tY9v2YJlNeZj08LoqvREN+Lm9RxwgyWRkdtVqZluPdRGrcnV6+aXHfso7EHr
	 wAMDZ05a6UL9aQxHGOULvvPP6KQMxAAkVJEpu98BVmxWJs6cGVZh2baQ+vSA4xbohc
	 865Kaq+pOJTPFzo+82do9BokhGEHdMDwgm5P04i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 297/398] Input: evdev - zero absinfo before partial copy in EVIOCSABS
Date: Wed, 23 Sep 2026 16:06:11 +0200
Message-ID: <20260923140651.119513675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


