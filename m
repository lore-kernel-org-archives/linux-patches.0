Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17C9274B46;
	Sat, 12 Sep 2026 18:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237610; cv=none; b=n/y48IuTiaCmzGJ6yCGCDK8wxqdf5W48BP/vkHPMfcAS81uMvZj2+faIRnNdLGmaXPgqQp+yZ5br1vXMdW6ipitNkg0DaMTUWScpjTdaj8XYNwGfvoHGi2SPUBC20QCvAw5z2EIorZxP0cJiKWuFnzLKIL+zxUlZMdVlC6zJiVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237610; c=relaxed/simple;
	bh=+R0m6cFGvLR+AlvSTANoiHNHyEPDK+vEzhtv3VmfnVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arDn23j5+MzSdPLtP9HOx7x87/U9S7xZfGn1X0CnmHFtOz3kX0W1Kr/VIu3boGbBOVqgs1G6pb2txhCKNVco7n77h5UactYw4SZfW8Y9UacCV6XAlVDhoYmOTkfqz4hc23xthBpak9CsVhLxcUsiK+Jf1PBCr+W2z89ORyl3ywQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Csi56U9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Csi56U9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E001F000FF;
	Sat, 12 Sep 2026 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237609;
	bh=jlirC2FfJl9yiK9EaCbf6IW8SQzC3gEKPcXWX81MxRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Csi56U9FnCM15W6GMBtmaMxrhvMU5wKxLmZlUJWDh1Ipht+yVthFHRaO/9GSqlZ1
	 lEBDIvqe9SqnBI/Q8pT8zFMnSEuNPJISUjvsRd+SW92ES20Uh/IKdPRMWiciyRwsFz
	 V6irxI+OxxQDflVzSYEj3q+FxlvR8pWsQ5xNcbIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 292/935] iio: chemical: sgp30: Handle IAQ thread creation failure
Date: Sat, 12 Sep 2026 08:55:22 +0200
Message-ID: <20260912065533.509186020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


