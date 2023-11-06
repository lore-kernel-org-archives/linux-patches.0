Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E712374A
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sD7C6Zdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDC9C433C8;
	Mon,  6 Nov 2023 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277549;
	bh=0HV+SLqkJtsfIrOMII8k6fwnQ1V2KelzhExFNV3l3u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sD7C6ZducatUDksoSySiBjYP1E+AtsZJYnD4iEQQORn3khXEkLl31QmpyOc34hOEc
	 mhkMyqVQJkQ1HGjnSqcoKsDRjucUrzj453k4yhyr6KKBKu/oCQ7jFyf4+Q0opqVXxE
	 m5m/uYefXQI/ONJsO7WtU0auf8uu/7/IiqBOwJXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Peter Rosin <peda@axentia.se>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 27/95] i2c: muxes: i2c-mux-pinctrl: Use of_get_i2c_adapter_by_node()
Date: Mon,  6 Nov 2023 14:03:55 +0100
Message-ID: <20231106130305.712011348@linuxfoundation.org>
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

commit 3171d37b58a76e1febbf3f4af2d06234a98cf88b upstream.

i2c-mux-pinctrl uses the pair of_find_i2c_adapter_by_node() /
i2c_put_adapter(). These pair alone is not correct to properly lock the
I2C parent adapter.

Indeed, i2c_put_adapter() decrements the module refcount while
of_find_i2c_adapter_by_node() does not increment it. This leads to an
underflow of the parent module refcount.

Use the dedicated function, of_get_i2c_adapter_by_node(), to handle
correctly the module refcount.

Fixes: c4aee3e1b0de ("i2c: mux: pinctrl: remove platform_data")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Cc: stable@vger.kernel.org
Acked-by: Peter Rosin <peda@axentia.se>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/muxes/i2c-mux-pinctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -62,7 +62,7 @@ static struct i2c_adapter *i2c_mux_pinct
 		dev_err(dev, "Cannot parse i2c-parent\n");
 		return ERR_PTR(-ENODEV);
 	}
-	parent = of_find_i2c_adapter_by_node(parent_np);
+	parent = of_get_i2c_adapter_by_node(parent_np);
 	of_node_put(parent_np);
 	if (!parent)
 		return ERR_PTR(-EPROBE_DEFER);


