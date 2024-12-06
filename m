Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1BD1494D9;
	Fri,  6 Dec 2024 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496043; cv=none; b=IrerSBBH/Qgxof60wGCI4hE7Mw+kmgnadBxTrEXtCqWIQ+w8IaAeYlg7bXQ1KZxJPCKF+aIyfNeesrgpLrsNntp6nAtm2bDgQEDLiLUyo2gWTIEpN6rHLasfJ4HmvFvpYArpLaWcKB8hEq0ZjUswbf9cwEMPhop2GXuSc6HL4KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496043; c=relaxed/simple;
	bh=3p/tJlxvkIPv3twU+qTT5+d/xGwOc1eEdd/h2UItrXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlaFLH6lGTHWX0bg4/EZXpEVBJfajyzlmtc3ASRo7ObD06/gZlqhc3MDuZL7/yRddcm5S7kRXfohqeJNo/2voXSx0pLC5ZJWB4Sa2UpKLdxI+cxZvItkEnLv8iMKBobheFtXpzVTE9m65DGnLGcXSarsNFyAsEZmDAdCta6KpPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMxIH2NC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMxIH2NC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE54C4CEDE;
	Fri,  6 Dec 2024 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496043;
	bh=3p/tJlxvkIPv3twU+qTT5+d/xGwOc1eEdd/h2UItrXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMxIH2NC/rxRAgNykL/OZDTXZj/NdTYe/lrVbXCJwO/wduESCWCf4e8R5OWw7JffX
	 ESHSf3JxpiwBEz7n6vAT9CIRlvYCp5iTJCfylkcim/DAY3nJz8H7DvAHz6YSv5jht1
	 V/bnKuY1ZoWgF4ZUhs93S4dfz/9xO/EbEPp2Gorg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 034/146] media: venus: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Fri,  6 Dec 2024 15:36:05 +0100
Message-ID: <20241206143528.977643517@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 2a20869f7d798aa2b69e45b863eaf1b1ecf98278 upstream.

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Cc: stable@vger.kernel.org
Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Acked-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -412,8 +412,8 @@ err_of_depopulate:
 	of_platform_depopulate(dev);
 err_runtime_disable:
 	pm_runtime_put_noidle(dev);
-	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
 	hfi_destroy(core);
 err_core_deinit:
 	hfi_core_deinit(core, false);


