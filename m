Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDD53148A7;
	Sat, 12 Sep 2026 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242015; cv=none; b=qL+v4MhyBqb+SMGLCIeoyzrh95UI5a+3PXpEwrnwg1tdYYC5iarhUTFnTdRBxZ7ok38BbWn+pw8T9qFzUbXyfzsAYcaDb8mQ60EsP7erUTX+hZgD3e+PDRymPEzxpG6kos6NNc4/RefzLkrCCs2YaSqMQ+zIxVi5cncbG00ARV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242015; c=relaxed/simple;
	bh=bvgwg31nGR2+qnkIZm5nBxOhVjYkJeTzLuWqpfYPtEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4hiVriWOpC41+Gi+EAywlsEYVCh1WZwjXjrs/4K3jecjmhI9gQN42YmOZR97nLtFmc6tc3/bMtBPjOJIIExr2aKff2Jr+yov9dvS4hglkcjemA7wrdHCUeGkOJyVWmplodDJ6P0uE6HnhIqGN7RoVtbKGrEmqgDtJ58K1ItO2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYo1hpu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYo1hpu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15B41F000FF;
	Sat, 12 Sep 2026 19:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242013;
	bh=twz+zU2iakrdGQ5ZFCbNUB36BotEKYD1HRlHn0Voca4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYo1hpu3ngRVWu+4sAzaVTJKeLzMwCeWvO+OA6nv1/mip+DnYVLknvCzqH3a3tLwB
	 bWSgiInUUmcHohD1U0+4A0zjX5nVGy2/CzT7G1O5es9u8pCEDeTkmYyzs0j2NWKW5B
	 VgCu5uz3GF+W7TJvALFMYhfS4N6JPeztR3EcV6DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 256/798] iio: chemical: sgp30: Handle IAQ thread creation failure
Date: Sat, 12 Sep 2026 08:58:04 +0200
Message-ID: <20260912065523.026654821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 1135d6875d2dbda3f6ec718f3421a6ce4378bd63 upstream.

kthread_run() can fail and return an error pointer, but sgp_probe() stores
it and returns success, so the device is registered without its IAQ thread
and sgp_remove() later passes the error pointer to kthread_stop(). Return
the error from probe instead.

Fixes: ce514124161a ("iio: chemical: sgp30: Support Sensirion SGP30/SGPC3 sensors")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/sgp30.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/chemical/sgp30.c
+++ b/drivers/iio/chemical/sgp30.c
@@ -548,6 +548,9 @@ static int sgp_probe(struct i2c_client *
 
 	data->iaq_thread = kthread_run(sgp_iaq_threadfn, data,
 				       "%s-iaq", data->client->name);
+	if (IS_ERR(data->iaq_thread))
+		return dev_err_probe(dev, PTR_ERR(data->iaq_thread),
+				     "failed to start IAQ thread\n");
 
 	return 0;
 }


