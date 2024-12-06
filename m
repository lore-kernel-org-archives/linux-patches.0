Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91FD1465AB;
	Fri,  6 Dec 2024 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498619; cv=none; b=XRYOZXLSqZ/uVOzwRz4g9TjLTbLu2+CowQXentDCmuBKFGqi7VHxPnIPmtCcxHnQBVXpX/IzgAEJ7zJxWTC9CMzpeSzE5b/wpN77wg407Al7S7c0SDrF6xRd0NIFpICX3dVm2TLXLdId+QtGZmRBfoSHLBFl/g2YvR0GrEy9s9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498619; c=relaxed/simple;
	bh=yj/pxMPtVOqJZaWfcqroh2mzjTBTuJODSnLP0s9ngfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTgznlu0mb9lDWe/j1uV4n6QyCGLf2J1Fq91AhG4Ear/WG3dI4gwcD5o0/kMXTYVQ36I7wLvdRDn/dyZclHkxI9I/r19Pqb1ihbkLeJMlqy09Nktc/0Rtop1kq8U/PHxnOkTF5HLN2lQzcgS6UAtoMh1jc1kyfX6M+JKighZjz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJcLlyUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJcLlyUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEA2C4CED1;
	Fri,  6 Dec 2024 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498619;
	bh=yj/pxMPtVOqJZaWfcqroh2mzjTBTuJODSnLP0s9ngfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJcLlyUKH46/icNFApLQOX5IqW7xX6kYsSWUen9IUZRAgsKtzheZiCQt2s4Ou/RaE
	 Zvm+KBVOdL0l6mZUdSejxoTGpxnd7EdO6/3pC7EfNFAl3p3WYwCJ7kayhTxiNvgan5
	 iVmBV6DIZPSmFY9AF3rBuDUBSqV4F9sdmKoIOkaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 621/676] media: venus: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Fri,  6 Dec 2024 15:37:20 +0100
Message-ID: <20241206143717.624148026@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -406,8 +406,8 @@ err_of_depopulate:
 	of_platform_depopulate(dev);
 err_runtime_disable:
 	pm_runtime_put_noidle(dev);
-	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
 	hfi_destroy(core);
 err_core_deinit:
 	hfi_core_deinit(core, false);


