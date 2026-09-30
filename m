Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518DD4FB9AF;
	Wed, 30 Sep 2026 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788754; cv=none; b=ry5y3TWwmxa88QIPc1EXHid06ZVd5u96LyfpFPo0Moiwwbyu5gbYLoQskj5cFLIIzaiMoGa5smApXJbkBqL5vMxA5DU2jXQjEeKsvMrwIqGarZDoav7OkSGbACOpWVqtF3GcnAo6arP9d9/BSe3G1Z22he1ZDHMIJwfwhBcXygQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788754; c=relaxed/simple;
	bh=XHNmkaQt7DINR2BgxqOqRkBVhOjL9MLnh9EbNSSoY3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JogvHtKeO8lJnuPV+qjiquHKWlC5mV/CcvdKZ570cFbJfWIMVr9E3DzHVW8Rv4YVPvImZ1RTlo4r5G7jCWC9Lm5450DPMHif3TexbgJuEHXNu6z+IvdDAtIbLF0ITnda2oWaKGurWBmGiBO8yCtyI83kg6gUxRXMyMNgUDjL9Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MvItZXiR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MvItZXiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC0D1F000FF;
	Wed, 30 Sep 2026 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788753;
	bh=0PYId5OV5xL17jGa5n0TbvWPOIVY8tWkBhsD6s+zSNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvItZXiRlg042LFElCJi433vsVwc3FKcI/T9zE69lpAgi/mr9t8Iee39Jys1P9p2M
	 G5cjdzehZwiWqaVSJvkNqYq/TdPwXDRo4Dr9bz4oeE52Mhc+BR8TUHci6W35qy5H/X
	 XRYHq0Ysu9wzWVQsR7gDZ84DjjNUQ1IfU8myBG6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 209/877] i2c: atr: fix dangling adapter pointer on add failure
Date: Wed, 30 Sep 2026 17:18:40 +0200
Message-ID: <20260930152419.236953293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

commit ad34235808b63a70ca4989b7a2852923193d06ef upstream.

i2c_atr_add_adapter() stores atr->adapter[chan_id] before
i2c_add_adapter() so that the I2C bus notifier can match child clients
during registration. On failure the channel is freed but the slot was
left pointing at freed memory, which can lead to use-after-free in
i2c_atr_del_adapter() / cleanup and also block reuse with -EEXIST.

Clear the slot on the i2c_add_adapter() error path before freeing chan.

Fixes: a076a860acae ("media: i2c: add I2C Address Translator (ATR) support")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Cc: <stable@vger.kernel.org> # v6.6+
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260907071102.1080840-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-atr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/i2c-atr.c
+++ b/drivers/i2c/i2c-atr.c
@@ -632,6 +632,7 @@ int i2c_atr_add_adapter(struct i2c_atr *
 
 	ret = i2c_add_adapter(&chan->adap);
 	if (ret) {
+		atr->adapter[chan_id] = NULL;
 		dev_err(dev, "failed to add atr-adapter %u (error=%d)\n",
 			chan_id, ret);
 		goto err_fwnode_put;


