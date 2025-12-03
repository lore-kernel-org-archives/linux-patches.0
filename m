Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C9E313546;
	Wed,  3 Dec 2025 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780468; cv=none; b=S6WEkmx+BYO7wywqsI725LZ8ld8v3bkZApkSIRK9Dzi1OW8dRqfdWcA003rSsWIxuyMTRnHowinkr8RA7yHmvy3vKPQreJbHaMawkQ4w/OeORk/pHOANasnfIYERZ3nq2cpGjdul6dXDNZ5mWgmrVMK7f5n4PQVGP1wzPqqJGqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780468; c=relaxed/simple;
	bh=RvOFww6i/DplSnjYwp661U9uDldJ8+q87feZw52aqO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxUEAaH+RIVerkCFJ5K8aD/hCxUI55I+bSFmq37K1ZdIX1gLVtZRoUYIpr4pTUUOTANsbU4HH2ElnM4SHPmY/nbT9Xb1U/x+oXdsDZqEcL9AKrN7++bt0QUqV01C/+IgPSth9VRllLPbposkvxNwyUcW6RVqYGoVhEqn75R7f58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgU6bA5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgU6bA5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9764BC4CEF5;
	Wed,  3 Dec 2025 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780466;
	bh=RvOFww6i/DplSnjYwp661U9uDldJ8+q87feZw52aqO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgU6bA5osoAyyFVNDbnKW79ZqhqUOgrrwPbIntw5yW3KAZbCjN4PaiPj3uoKOFTR8
	 C7XFf5Tlidw4j2atXkQKjeoqAEIZnCqfJwppe2dxp8u9/5UTQjDF7pFFmlka8gColb
	 r29Vfb1+Yz8vh904umkCetexOzXB/brPD7y0/jfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.1 532/568] slimbus: ngd: Fix reference count leak in qcom_slim_ngd_notify_slaves
Date: Wed,  3 Dec 2025 16:28:54 +0100
Message-ID: <20251203152500.198925658@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


