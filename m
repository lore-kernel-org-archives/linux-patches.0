Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254D93E00A3;
	Wed, 30 Sep 2026 19:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796328; cv=none; b=MssODOWbunxu4EaEjQMmLYIxrW8RzjjDD0eLWlO1/plBLp0YjmeeghK8Fqd9yE1elF3Pavu61sh8BTfLHrPtO5hsaIkorIRYS+B/G9slg1aGEei83WL6O2CsOPGUpDwfiS4p6v/sCqxOZl/hOLlY09toG2Iz1VwYQW5qs8fiiu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796328; c=relaxed/simple;
	bh=mXaJQhVLn3MzJ1OjtddlSB4/+UtCMfYzeazLVcUc6QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdlFdPyiDTGFXBX0gkmgwZo199eEdyR/0vEYBQ7ScNS0jcZHYZOAQ8/k1MCArtjmV7nntpEmTj0enRcCQ/aaYn4ItM3q2fYd0/AbnPC30iMGIMeMxaFNY7gsNRpk7lwrS0q2F20E5EDj4PsV/SOI6wKWW7lqEinNDrZckq7k1Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxJXpmlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxJXpmlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F26F1F000FF;
	Wed, 30 Sep 2026 19:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796326;
	bh=0F9c3ja7eiVmbyrlcXTPoKu4+3/VxhR9FDg9sPv9Skk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IxJXpmlH4XJOrlyjFSOPAqyJBMGSoLjWfJhJUi/noS3BKwhqIhKLWVwM41khI0QDb
	 7D32y2U5KdOcsvhFpraG18E6Ca15h3okYeZPB/4SvBCU6xi6dZz6Ysu+iG11VdFIzB
	 fX/d+gYFYLa6WLFW9ldZ4tdhCzRdTc3MxYwg1vgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 0874/1193] i2c: atr: fix dangling adapter pointer on add failure
Date: Wed, 30 Sep 2026 17:25:58 +0200
Message-ID: <20260930152453.657723767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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


