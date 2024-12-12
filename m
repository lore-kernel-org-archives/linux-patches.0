Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1364C223E71;
	Thu, 12 Dec 2024 16:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021655; cv=none; b=A636ywt43O/WtmAwZRURGt+XiB+ANDA3ghQqHhyWRziKL0/qiM6Ccp2vawNG3Mu1FWUPgjr+Hy3cfFgKa3m5e5SKekWGCwd4VhY3PI5/XByJqKrIUsczMmF7l7nHiOR2uA36cWI93X/0NgEKk3AA2J7BV2lEyY5xtF1CdrxOziY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021655; c=relaxed/simple;
	bh=XIl1vjO8OTfqaJ+io6lgqHkTAEO+n/GGP6y3gpKdjRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrhYlxUg9vjkca9amgTNH6BxCse8GxwjubAbenxo345A3Lq72F0+H0RBCnEn4tGwq+FArjBemEu8BZ2naWZIL5ucUbGLO1EXUhDODAuW1BzWLAhh2CJScNQ/SCn2jPIYVhnuMWliaY4nMOBauhqKp0dbBSQqx/berXUat7d2w08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFvjMshg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFvjMshg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B964C4CED4;
	Thu, 12 Dec 2024 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021654;
	bh=XIl1vjO8OTfqaJ+io6lgqHkTAEO+n/GGP6y3gpKdjRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFvjMshgXVkt6lajLASXz32pKJYC2mf4daumsR73euOyJpu5MWuDO0pJnWmlLp/A5
	 UB/l2vKEPhEIBD8YTUDTNumho21Tl6DlAHYYlcps764iUw7UxOtFKySy5OOtUxnXiN
	 4jYVfjeDW8LdrBiqyJk8eGmFAqKKbEC+E4RS/Q+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 006/565] media: venus: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Thu, 12 Dec 2024 15:53:21 +0100
Message-ID: <20241212144311.696155141@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -391,8 +391,8 @@ err_of_depopulate:
 	of_platform_depopulate(dev);
 err_runtime_disable:
 	pm_runtime_put_noidle(dev);
-	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
 	hfi_destroy(core);
 err_core_deinit:
 	hfi_core_deinit(core, false);


