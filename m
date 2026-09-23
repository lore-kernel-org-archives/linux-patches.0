Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DD43AD52F;
	Wed, 23 Sep 2026 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174924; cv=none; b=TFF1Fu6PaP1LXpfqZHzf8NwJnP6tlNFLu8Kkt0GHFmiGPvR3jKapvCUw4zTGDqSL4LoWPTqxAjNsifuTCXBdEr+bugTPaX4eJMrAcRhIp1lHdj3G5qgZvGXddNjs6AXpjqIxs8kqnIRhx9myWaTiApMYUO1pUUkRwSjoVdS32go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174924; c=relaxed/simple;
	bh=oAkjE5giv3Kww0NtUzUncGdFYUeNE9y1S8nziUgu4ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjNgYIsl4FtXlS1FCJJlsPR5Yr93ktJ+RhQXdPFbBEcnZ4LrBHo2l4JxtP1+NdntzPXJqI8WFfkYcRzCjwlBXm1neyEspuN0ETgfB76iUTW2yq0B+VVE7/TKdWNK02sYQeoVXOIHtm6m8izj0/5Jmh1NPyyI8CCKDK/2wOrc9OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rraiwlXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rraiwlXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6A41F000FF;
	Wed, 23 Sep 2026 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174922;
	bh=e72UlcM9qGh/fdQBLKmG1sTZKE3yYEdxnWCXka8suwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rraiwlXvGGlQUBRPNfCIckrMyYR+idtTjA96/qUPhLSNHTIKcGcY9XTHuFkz1D52D
	 9eePTHQ9PLIWsgc5t/nQzMqbXkxyuaXcUxb0h89cRshTsJLd/z6QdF/gRrhcr2LxAf
	 9JNp0KZrKL5hWePs432B+3g5V01kakOAC+RD/FxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 267/398] i2c: atr: fix dangling adapter pointer on add failure
Date: Wed, 23 Sep 2026 16:05:41 +0200
Message-ID: <20260923140650.334800768@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -864,6 +864,7 @@ int i2c_atr_add_adapter(struct i2c_atr *
 
 	ret = i2c_add_adapter(&chan->adap);
 	if (ret) {
+		atr->adapter[chan_id] = NULL;
 		dev_err(dev, "failed to add atr-adapter %u (error=%d)\n",
 			chan_id, ret);
 		goto err_free_alias_pool;


