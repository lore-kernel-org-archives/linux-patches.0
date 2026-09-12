Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A0E332610;
	Sat, 12 Sep 2026 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213749; cv=none; b=OZqUlPFlSx3I09iZg/jM10AEWsA9PxjfzEwd7VENxLfL4g9RuZV/vBVm+JWfRlIYA8ZUOetLDjyGEfDijSa2jno72gQVyVtxzoNbjXB7o1VtWwlnrQdhw4+rf59Y+SFA+VGf+lwvU+hA1dnhXkpyX6rkD1SdQUQdbaBubymZ3hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213749; c=relaxed/simple;
	bh=FJ9ieRMdIlAS1Is4FXYqA4sDoIoyJQU1naLNEVe1UiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1m2mmQb5We64mbJ3i5zpFJ5s5kYNbpIG1O0rc37pHmv0ewwg+sMIIO4bo8Qr2QDCtCXaaTjJ63HmtfKVb6D95tK2Yh4czhfSqTDTr29XwnGYm6r5NzFBrGTIN9IM1s5bChJFsMH99qAaCjSza4uSj/AuSDsFSh8fZFG1nLwzEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMTPVGJt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMTPVGJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6621F000FF;
	Sat, 12 Sep 2026 11:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213747;
	bh=Hf3zKfEQGIhYJ5HoPTYqU/jA+BaXUdHVwoY+v3QBSAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMTPVGJtcgzQeKO7JyjXVal8Txl1XAWwHnEvVbq7JsH3jxbUXpXD1GKMw9VlScS/X
	 pQOCwgpdcvhSu2WOGVC3qffeZXjsVulCk5pOUJ2IaeBN7OqAix7ry7HsCOkY0QRxbZ
	 9/lMUAryKUfs0+znW0k7zfRKA2RFI+QjUA5a2Pjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0141/1376] iio: chemical: sgp30: Handle IAQ thread creation failure
Date: Sat, 12 Sep 2026 08:42:47 +0200
Message-ID: <20260912065610.695559345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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


