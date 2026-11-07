Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062069;
	b=cdXT2OKn/aT0O19dJs+9W2StyGqNvlcUH6VtGgKcXmPnuBgXTXFvIUrXfSFsN79zolNd
	 XsDLp2G3+CUs+Yf8RyAngoLsMWfdNs7OfAryft52QY3zF8H9gZ386aYoknXe2sZqPTaHd
	 8Hrx0zjUr62uW/ZkeUDVVQsgl1JP8sU5f9Bm7uDaPAH6Dn+JY3oabc7ugYFTqSu2K5CeE
	 2WKTplPkgHXqIgLKzQpp8nKAK2+hILvlntqF1XJ4zwGVUOZPglwHKHPhmj5jRa4lI2o3L
	 j8GTaXm94CGtUrd1y+VJkZC10m3eAChrXsJjVKeKru+iP56yrzhNTBJxfaeAchMd3oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P8HJmLbahBKZdsCxbj+5shLris+oLC2rSEjo2zTSq1U=;
	b=EN9UPKj7URYqw9Bsr7UwHRaoqkkzUyzXwwDkKPS3kRmXVJphzfA8BDLPWaqRPBpmyQAw
	 0VnpkQroAJWj9jdzhGpXUtS+7923RglSSFRFklBfO+Pl6+dt1djGmu3DmOfhX5twrZlek
	 cgzUFR5X6/ygM9IhDlsEWGlQRe3FePoXE3sOCIGfAh2eTIFfZI3cy/bkQxOVaETcnt0td
	 HYArQqnGIZbPnXqSWGYhCxutLXV18DkSPwd63zDBAzouvIbYd3sdEqzmIGOhd8owvTC9i
	 9ZA+oht6Ix8+ipQzUcLiKF4B8zXnipSSg1tPLK/8LdfYc/tW6ABwRs3Fx33gfksZIsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eKvH4lrI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3442B606D820;
	Sat,  7 Nov 2026 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eKvH4lrI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE8B1F008A4;
	Sat,  7 Nov 2026 14:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062068;
	bh=P8HJmLbahBKZdsCxbj+5shLris+oLC2rSEjo2zTSq1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKvH4lrIEwCH9TdLAUcsu97rYuLXoZ87hrI9i3JxCme24mj5iQsxn0kv7AaZ/zh+w
	 KIlWDm+ongN9eEebRdiDi+vSBIC0VpCVxKVODzZjb1NgZSlB/Yz7FTYPOPUWLoS4Yq
	 KwOb+i7ASZkVdmmT6dJEXH9qTsTN+0goUPceAr6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1048/1536] media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()
Date: Sat,  7 Nov 2026 08:51:04 -0500
Message-ID: <20261107135027.113328121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b00fbdad64d4ea7d594bc67988c1722fe5b3be50 ]

vpif_probe() takes a reference to the i2c adapter with
i2c_get_adapter() and passes it to v4l2_i2c_new_subdev_board(),
which does not consume it, but the reference is never released, so
it is leaked both when the probe succeeds and when it fails after
the adapter has been acquired.

Release the reference with i2c_put_adapter() on the success path
and in the probe_subdev_out cleanup, and initialise i2c_adap so
that the cleanup is a no-op when the adapter was never acquired.

Fixes: 6ffefff5a9e7 ("V4L/DVB (12906c): V4L : vpif capture driver for DM6467")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/davinci/vpif_capture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti/davinci/vpif_capture.c b/drivers/media/platform/ti/davinci/vpif_capture.c
index fe44d3abe18e7..e71242026137d 100644
--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1605,7 +1605,7 @@ vpif_capture_get_pdata(struct platform_device *pdev,
 static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
-	struct i2c_adapter *i2c_adap;
+	struct i2c_adapter *i2c_adap = NULL;
 	int subdev_count;
 	int res_idx = 0;
 	int i, err;
@@ -1695,9 +1695,12 @@ static int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
+	i2c_put_adapter(i2c_adap);
+
 	return 0;
 
 probe_subdev_out:
+	i2c_put_adapter(i2c_adap);
 	v4l2_async_nf_cleanup(&vpif_obj.notifier);
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
-- 
2.53.0



