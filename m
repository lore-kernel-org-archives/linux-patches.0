Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58EC53162E;
	Wed, 23 Sep 2026 14:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173738; cv=none; b=hvBlUPcdrj683Z+vrXvrj7aMQC+aeGb7wYaZll4Fq3yVq1JHxh5EGYCpPC+aLc36bowFYuJUut6vaI29Wg4WMUWJh7JuqjzuGUJY+EEtRbTr3h5eXhSyP8WOnQluqQ9hmXspaxAWBmdiS3QGPiC0rPTdAr3/ZEyBuC3TlkUSIZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173738; c=relaxed/simple;
	bh=OJZwE84pTxLwSqfOU/3puEVEx2zP/c+H4TeKzOGlE8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5xZ0IrU38sGXsS5cZy7OAP7uhqIv78LdJXoC0vAW4xNvgy7EqSe5IEcac7HRVppmeJ0SyEA1bb6cCsr6fp08ROMhHLFcoA41AmhkGcUyIRpsAJSxjxvXdQwI9zkDRJ1vGATsFKUZIUdn6HX0j/lpSiYH0YKMkepO+882gxSQTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjWKMBft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjWKMBft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7EF1F0089E;
	Wed, 23 Sep 2026 14:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173737;
	bh=ed/LlIACSw4ZDZIe7PO9llAI3RR3DArVeEqv3NJw4GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjWKMBftl2/s/M0O7eGLUgUBmU7pAUYm7KpwtIS0cd5NzzvBwpnXOINexBJ/NbiNl
	 MLjSXocEXFQc3JaPUTN2lsMAJuA6hn9uRY60pVa9AQni5YAGVQdMM6daw2x7clCpJ+
	 AOtmXrEcovsQduC69aWuoVpFMmfTnca1WxikPBCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 326/438] i2c: atr: fix dangling adapter pointer on add failure
Date: Wed, 23 Sep 2026 16:05:47 +0200
Message-ID: <20260923140653.251649390@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -855,6 +855,7 @@ int i2c_atr_add_adapter(struct i2c_atr *
 
 	ret = i2c_add_adapter(&chan->adap);
 	if (ret) {
+		atr->adapter[chan_id] = NULL;
 		dev_err(dev, "failed to add atr-adapter %u (error=%d)\n",
 			chan_id, ret);
 		goto err_free_alias_pool;


