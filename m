Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F98168C3F;
	Thu, 12 Dec 2024 17:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025666; cv=none; b=N/l5DU+lPTXZHjfdw6brU0Btin47WkAGboHDsZxkAVCVIw6N9+Ld0FSErFmHy9GIQxH2sjD42Wy2sU1BrlOEmeX4+etFMckOekIkG7e+HcmvpLhpfM+FCkGhp6P6gWvVww2BjRI+8H2yLdHkRPJPrNEKzeiDdkt2Pg5wb1LIQZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025666; c=relaxed/simple;
	bh=rxh3Tw2JY0SL9lGOphqtGIsqKzt7lZpRZIS6QC7IRJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnIV6zcuZFmZSXUgs9vfINygVbE7mA9d7UAzR3MCQ27Eu//gDUQbuQSQekAvV1LsdW1cHh4me0iCTgpBrhdNlKPRqYr1rx3uxGGN+Fnshv81R8hsmeOZcvrMmmHfKGPWUxpgUFJh1W6bLw3yKO7AiAAcXAYeX6JLK1JWS40MAxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/FPuGCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/FPuGCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF0DC4CED0;
	Thu, 12 Dec 2024 17:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025666;
	bh=rxh3Tw2JY0SL9lGOphqtGIsqKzt7lZpRZIS6QC7IRJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/FPuGCU5IZSKSHjfzf9xaSYxEBdGsyv3fdAIX+SY34W72sc0mMlBXT63gKjH8pD1
	 Kru6JmHSr0J2EypFvvVKJXq+MX3eHyVXi0oJAljliZVFn/dbxj5RoAEed8eAHBFtdO
	 pXB6wRJzf3yr1Jm6P2UNjE70t9b7D32QZDCOfzx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 206/321] media: venus: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Thu, 12 Dec 2024 16:02:04 +0100
Message-ID: <20241212144238.120513963@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -335,8 +335,8 @@ err_of_depopulate:
 	of_platform_depopulate(dev);
 err_runtime_disable:
 	pm_runtime_put_noidle(dev);
-	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
 	hfi_destroy(core);
 	return ret;
 }


