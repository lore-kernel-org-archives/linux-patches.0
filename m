Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089E9350D6D;
	Wed,  3 Dec 2025 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778487; cv=none; b=uFThnwOSGAaYFmeNA4QbEwZdqQaREkbYHnxNmcPlXE4aJS/dEds9isMGZ5IfAb9niCgFxGowvyd0EOHo1vJjfoA8KAI088nqlzUnr31TAutkwUtwSz/5PLCB5wYwetPtxZHAibL91WAz26UqgBC5LUjGpA2gMKR9z0Z4oS9r2f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778487; c=relaxed/simple;
	bh=6DOdYaTgkH73Rl4EX07j+sxW6BSrZDs3iH5F7ymRzvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhAp54/vyLxx9KMpQ9IJtcFjb+O8ek2FjG0r5Oqp77CyljCNc5jU868J+4OHb1oPfW5/A3DdXY2lswkkvotH/nIIiyEzn7uTRamYJs9Ww3YQIpq0gJI/NgT7bnMih2tD/Vfsj+vJZgVeaaKPDede8OXo3WEzzQwbcOF8OLH78pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuGYvi4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuGYvi4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F426C116C6;
	Wed,  3 Dec 2025 16:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778486;
	bh=6DOdYaTgkH73Rl4EX07j+sxW6BSrZDs3iH5F7ymRzvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuGYvi4uT8v5XeZDTaOchPRh2K5mVtLrp7TVKXDF2TgvxTNDsE49NSKLPXEVAW20p
	 7Xkn72SJmwDjFo1skQtRrgU91gMWoUpQlMJ7vVyyLlxH2PShxyMd9QYCuibt1fncau
	 wBkJo01gRTxhtRKuE5hl13DYw4RFstTanB0ytLw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 5.15 361/392] slimbus: ngd: Fix reference count leak in qcom_slim_ngd_notify_slaves
Date: Wed,  3 Dec 2025 16:28:31 +0100
Message-ID: <20251203152427.449915264@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 96cf8500934e0ce2a6c486f1dbc3b1fff12f7a5e upstream.

The function qcom_slim_ngd_notify_slaves() calls of_slim_get_device() which
internally uses device_find_child() to obtain a device reference.
According to the device_find_child() documentation,
the caller must drop the reference with put_device() after use.

Found via static analysis and this is similar to commit 4e65bda8273c
("ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()")

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20251027060601.33228-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1164,6 +1164,7 @@ static void qcom_slim_ngd_notify_slaves(
 
 		if (slim_get_logical_addr(sbdev))
 			dev_err(ctrl->dev, "Failed to get logical address\n");
+		put_device(&sbdev->dev);
 	}
 }
 


