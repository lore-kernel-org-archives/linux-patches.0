Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A570330B06;
	Wed,  3 Dec 2025 15:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777137; cv=none; b=EIpidnlDZkTtOwwb+eaxQjezDPAe32YQL4naDHOiO6O5SigcgQhW04lwYhtzR+bZuKv0ZqvdJWrmxFYjyW02zQHBhlmY/IuPdhGTCsjKIz4/AYYH3Me8H3CC6sp/LqNYYnDJ7KWxyVYRDStUSX7sGT98lBFccygKGUcTd8vUnNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777137; c=relaxed/simple;
	bh=ptZKBvrM79wM2IXiHey9QzxxXWKlKXFUWt1sHVc95a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzOiJg6k++sg/dyPJv+WVqadfCwIPVCORIdA7Z2jsT3nRZvv0zX9Kevc8cZ1T9ny4p8njD7n8hPxDGCr5IwhZeVCut1W+9ls5KnaLrSlUEBkOuMv4h5mLY76QoNQpSSCl28stNo7RC//yYI1D8LzcXlYo7R3u3mMRnCXgEh/6YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkvRAH6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkvRAH6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F121C4CEF5;
	Wed,  3 Dec 2025 15:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777137;
	bh=ptZKBvrM79wM2IXiHey9QzxxXWKlKXFUWt1sHVc95a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkvRAH6j2D9EQXXFMv2H3HCa5lRPA9pvuW5NUbH9ZqFg2Ub0NkyXdhd2sobdzB5oC
	 8Wtb46GK4QBKmsnuhkwsDFOw5GPV61UwDMcbaR5DxRRC+aeKhsrdud92QyvwyADNoW
	 NgZ2tcmJtGHsUHSrL3BukVbAbDzRHi/sD73P6Z/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.17 093/146] slimbus: ngd: Fix reference count leak in qcom_slim_ngd_notify_slaves
Date: Wed,  3 Dec 2025 16:27:51 +0100
Message-ID: <20251203152349.863972749@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1241,6 +1241,7 @@ static void qcom_slim_ngd_notify_slaves(
 
 		if (slim_get_logical_addr(sbdev))
 			dev_err(ctrl->dev, "Failed to get logical address\n");
+		put_device(&sbdev->dev);
 	}
 }
 


