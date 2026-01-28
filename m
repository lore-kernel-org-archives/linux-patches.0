Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290F12FBDF5;
	Wed, 28 Jan 2026 15:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614817; cv=none; b=nnjNY1WrGgN4OJyKWR6eHlJg/GZHuq+RL83bdTURs9FT/0JVQe0jiTxUMDKH98MR++aGMC+DUV1Cm2FLI+AFS/vAvhJhK/55roFWpfoDpeOKWZI//kUFJc3UsPIakRrCzva4M8xgxJvQGj8zRQGDGIgrvkstPJsmVeJ7WoF9N/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614817; c=relaxed/simple;
	bh=1m0pxd9+He69BvGpdL5Lt3M78VxCPmE70gqfDFPOEY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2SS3CHnafBMkreG882QuQziD/gd7g3XHMnGcJg1eCXSkBQKXUPAs/lrh2msc0S6DtuW7VrAH+dI2KjGo3792QiKK94evdhPzjqq9ntuSgSeRm60fneMvXibfcnbLT4zimZfbbWA3PbUMJCOkHgKPU+VXyJuMm8KcGVhjinCNxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+WO8zBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+WO8zBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A56AC4CEF7;
	Wed, 28 Jan 2026 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614816;
	bh=1m0pxd9+He69BvGpdL5Lt3M78VxCPmE70gqfDFPOEY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+WO8zBaQPsakjCx8dvouQJXwihYqFdWqL1rdsv/vLZiiOtf9lDIlb98Mthf39FCz
	 CO/CGbp97Zwqmk/FgUT4ql5dXsQLLW+Trdg7zqcbI0OroFiuQFS0t81dnxckLiDPQz
	 mLH1vCfJVEvhToANwlbqwBl1itmTwRYi2FaAKW1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 6.6 208/254] uacce: fix isolate sysfs check condition
Date: Wed, 28 Jan 2026 16:23:04 +0100
Message-ID: <20260128145352.279623228@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

commit 98eec349259b1fd876f350b1c600403bcef8f85d upstream.

uacce supports the device isolation feature. If the driver
implements the isolate_err_threshold_read and
isolate_err_threshold_write callback functions, uacce will create
sysfs files now. Users can read and configure the isolation policy
through sysfs. Currently, sysfs files are created as long as either
isolate_err_threshold_read or isolate_err_threshold_write callback
functions are present.

However, accessing a non-existent callback function may cause the
system to crash. Therefore, intercept the creation of sysfs if
neither read nor write exists; create sysfs if either is supported,
but intercept unsupported operations at the call site.

Fixes: e3e289fbc0b5 ("uacce: supports device isolation feature")
Cc: stable@vger.kernel.org
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Link: https://patch.msgid.link/20251202061256.4158641-3-huangchenghai2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/uacce/uacce.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -379,6 +379,9 @@ static ssize_t isolate_strategy_show(str
 	struct uacce_device *uacce = to_uacce_device(dev);
 	u32 val;
 
+	if (!uacce->ops->isolate_err_threshold_read)
+		return -ENOENT;
+
 	val = uacce->ops->isolate_err_threshold_read(uacce);
 
 	return sysfs_emit(buf, "%u\n", val);
@@ -391,6 +394,9 @@ static ssize_t isolate_strategy_store(st
 	unsigned long val;
 	int ret;
 
+	if (!uacce->ops->isolate_err_threshold_write)
+		return -ENOENT;
+
 	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 


