Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8104368287;
	Wed,  3 Dec 2025 16:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780749; cv=none; b=i/UIeix2poExhgJcgylMlWn+lciKQG+UfawhiL4L4NvT/VnMgC+OFh3a70CWHMEcP+x74eAKbyqxSdj0mqkNN4Cn2ZtCgdLFT6iSbbrj1d2xkd2D5hpn/cL8n61CFehGZGIxwPYML1uondxsBcZImq8G55VcH2x9bXgOUIMNpyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780749; c=relaxed/simple;
	bh=4dKKPgjBk15aXMuSn7opo+2TBCIKHk3TdiIzn8hcyoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beuVDAvSL346QUY5O8he++Vg35u0g3+JJYyQtNfZuak5gmXABT7aOdRm6mR8/oG6PZqaGc5/q0ZqeOktvk1IjhOlnrZcn360zdmib5VQ1wm9KKa8cCEjTvrBlYHjFR30UKIEiyRJCFMqTt4jDROCdndyN6hESyHSMkVRrhKaqDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5RI/iJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5RI/iJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5660BC4CEF5;
	Wed,  3 Dec 2025 16:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780749;
	bh=4dKKPgjBk15aXMuSn7opo+2TBCIKHk3TdiIzn8hcyoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5RI/iJB8ITIunAWe2oDa3PW9VuvavGhPXYs56rExdvlbnGADEXoqSiFRTd++PoxD
	 ziI+VLLSsfj57EUge/ozYf6QJEPGcdrAptyNvUyYyUuw7eKPnkrDbPBhB2fSRd4x8O
	 wxthO2Ltmw1vJXET1EME6n86NAiVP+ApQoQke6Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.12 079/132] slimbus: ngd: Fix reference count leak in qcom_slim_ngd_notify_slaves
Date: Wed,  3 Dec 2025 16:29:18 +0100
Message-ID: <20251203152346.220514598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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
 


