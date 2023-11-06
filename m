Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B937B2374A
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6q9wRGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DFCC433C8;
	Mon,  6 Nov 2023 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277556;
	bh=kJnIXReKw9OSXyUNZ4pskXWkm6ARfBnxu+iPoaubPJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6q9wRGHSWtBYhYzDw6GN+sReK1fSHa2wJFj24ddtDKvV4exqXGiR6C/fbk3hsd+d
	 qEp22+YlY83IaocEWMylyyvU2mcVX2t/2e7Gy3+TLQtHOnBbshiF5vRwVdKHoGzimk
	 RdBK09HQOdNFidm25dI0lXz7nXgQY7fpoduNOmME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Peter Rosin <peda@axentia.se>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 29/95] i2c: muxes: i2c-demux-pinctrl: Use of_get_i2c_adapter_by_node()
Date: Mon,  6 Nov 2023 14:03:57 +0100
Message-ID: <20231106130305.782267123@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Herve Codina <herve.codina@bootlin.com>

commit 0fb118de5003028ad092a4e66fc6d07b86c3bc94 upstream.

i2c-demux-pinctrl uses the pair of_find_i2c_adapter_by_node() /
i2c_put_adapter(). These pair alone is not correct to properly lock the
I2C parent adapter.

Indeed, i2c_put_adapter() decrements the module refcount while
of_find_i2c_adapter_by_node() does not increment it. This leads to an
underflow of the parent module refcount.

Use the	dedicated function, of_get_i2c_adapter_by_node(), to handle
correctly the module refcount.

Fixes: 50a5ba876908 ("i2c: mux: demux-pinctrl: add driver")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Cc: stable@vger.kernel.org
Acked-by: Peter Rosin <peda@axentia.se>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -61,7 +61,7 @@ static int i2c_demux_activate_master(str
 	if (ret)
 		goto err;
 
-	adap = of_find_i2c_adapter_by_node(priv->chan[new_chan].parent_np);
+	adap = of_get_i2c_adapter_by_node(priv->chan[new_chan].parent_np);
 	if (!adap) {
 		ret = -ENODEV;
 		goto err_with_revert;


