Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67352D8378;
	Sun,  7 Jun 2026 10:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829259; cv=none; b=KcKG3xhmJKwzh7lnIja1v513yTPm9nxUZgM/B26wjVPt3AsiKpmPS5ngiBTOKGZtA2HKiHnbpANoGFUTqSaFChNL5//Z+2oT26YbVB2ygvcux/h/5aiPTGBNoJnfl6JbQtytH+wIIUF+GjXygm4bgP8eYG0y+s6JnIn5ivESpS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829259; c=relaxed/simple;
	bh=bxTkesAKYZLGOWEJoUq0nzRUzhtYcjIB6irTCGp04ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Obktp3tkxPy7nzcV2PLglWJjYYaZcgyFZ2jzNIr1cC3R0rmPIV95zpotd7XyRAT5W/WiWUqSru2Q+iTbKMPJ3nCtaKOGLomEdHDy9jfn/XsQcCFVUHrxYpTPCLOZTbqqqj6oc3s/jpXdYB2ZIiOPXUq1GEhtx2iqjfM8JD9WspM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAh3QWIc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAh3QWIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182801F00893;
	Sun,  7 Jun 2026 10:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829258;
	bh=vKZ0m5AMTo04lkCVJlOchZZLIMJNCccCczwro+u5JVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAh3QWIcev0hSXoS792SGaqKfeLuyOxPghCvBBUzJTu22wzCaKXn4QcyDzXaNrYvx
	 mZy7nPGbiQuHWBXQBhS9aHwQUwGscEHSTm2WTqtWk9O/GYcykf3eYRPX+yPsBBrF+7
	 zTycGA3ERrdCgKva6apnVCGVHK7zLar9hwGCYyCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <error27@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 230/315] usb: typec: tipd: Fix error code in tps6598x_probe()
Date: Sun,  7 Jun 2026 12:00:17 +0200
Message-ID: <20260607095736.015930065@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

commit b02900c85a6423cf9b3dcc6b47bf060c85075e69 upstream.

Set the error code on these two error paths.  The existing code returns
success.

Fixes: 77ed2f4538da ("usb: typec: tipd: Use read_power_status function in probe")
Fixes: 04041fd7d6ec ("usb: typec: tipd: Read data status in probe and cache its value")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/agL9o7wUK1dOVBTy@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -1828,6 +1828,7 @@ static int tps6598x_probe(struct i2c_cli
 		goto err_role_put;
 
 	if (status & TPS_STATUS_PLUG_PRESENT) {
+		ret = -EINVAL;
 		if (!tps6598x_read_power_status(tps))
 			goto err_unregister_port;
 		if (!tps->data->read_data_status(tps))


