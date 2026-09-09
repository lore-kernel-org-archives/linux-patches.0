Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB40353D0B8;
	Wed,  9 Sep 2026 14:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963829; cv=none; b=cuIxNZYO28Jc+Psq5SYw6zLuVOpkHm8t6yr3qu+966yYkCmBkcITOKpPoeCfVlvVZKIFAD/Z5EuV3C3jSzvUN9uA3JcVh6/fqJw6E/K3OCPsd3EpTbQULySAChICYu6J6RDMWc9/R8m6RBZfg4PtJ1Ni1mc6gj33CBNklxLD/G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963829; c=relaxed/simple;
	bh=yBxM1+5SpBd4oFT527W9Bm9B+zgYc35J9MveJQVG9M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MihefJcukjSOiaMTgyK9Etr64tg1rN0GpowpALV+r9Hq5Y8/LywzQZ4EP2O1WRIoYzOKV7vzzCIUStBBrXNi577apYlz5j1ZYm9qlQe2kohgU4QZZs13MVhIhNF7GRDdXKqbge1B1gHhImI/i4FLZPWEqMaW1oKA7M70SqShicY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VND5B8OS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VND5B8OS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E85C1F00A3A;
	Wed,  9 Sep 2026 14:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963828;
	bh=u6uSRG6XlqNsgRtyYT6Q7mJ5keEpi9D4jV67FWqITac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VND5B8OS140VI6LjQPNwmodRc1px9hgb2TL5h4Uqg22zPF9VgTULytC2UsFYJ6Rti
	 8QBjvhBd+idld4DHkTHJbp4Q+nv+Z5byo05cbpapz0Ob449cjxe94IYdC3uF3qKXBU
	 ioW9WPGBwJGi9FEVjoRjM6spyh3k8dfJEzPLPOn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 211/583] iio: chemical: sgp30: Handle IAQ thread creation failure
Date: Wed,  9 Sep 2026 15:38:16 +0200
Message-ID: <20260909134245.453767243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


