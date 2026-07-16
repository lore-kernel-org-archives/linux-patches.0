Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2957A41F5EC;
	Thu, 16 Jul 2026 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209141; cv=none; b=VDkZ1Qpty7fexkODEr6pV5H4niNAHSwtc+GBf2VmMGCPxjo1mxKtGuCrJj+qxWmnJ753pgrw2ooIlp6PXnDjoTqGcOjD2hwtE8x184tLIlPfp9yQiOset+XQnO73Q0IDGAYMWiSmuq22f8GGrHzCNMWdC6FdGfRe54iVM+eqRew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209141; c=relaxed/simple;
	bh=NtYW3YIr+f4HuF/ofrbhgG0Mj84J4o5nBqJwNx2/gIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShGOV1g9ooX8HYg+fRxQeMZ3y7PKQHcFwkkXEoog6yVSdMNWoS+ZzujJSSwNIuXnWuYjNx9EDAIDh1sEkFAc1IJ67FrsRSYTJoh+f0r4srMCNY3YNyfR9WE9Xn/7lP/AaUdPQ/AGt+/onxNp3tZa1O3xKxFktlAs4VDq7xEB2aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urzRBQTx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urzRBQTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C811F000E9;
	Thu, 16 Jul 2026 13:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209139;
	bh=Znd1OAsW51Wq3DYhYx3LuN+H5CXA8WJDGSGT6REuXzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urzRBQTxl8+1wpLDStXCutLUz0WF3qrsRwLS7wMq1XoROKKUue6wY0fifT7bsWsq3
	 6vZQ4HpXz5HgZXCd8MisqW2o7L+Cg5kKb2g7YhhKbkq92FC2ESM5VWaRljcaSvENS2
	 01Wpx4aWrnHYsn55ssiflDGv3Ha+HmRzLhYX2ax8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 070/518] iio: magnetometer: ak8975: Add missed pm_runtime_put_autosuspend() call
Date: Thu, 16 Jul 2026 15:25:38 +0200
Message-ID: <20260716133049.318238946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e94944d7364d3ddb273539492f9bd9c9a622549a upstream.

On the failure in the ak8975_read_axis() the PM runtime gets unbalanced.
Balance it by calling pm_runtime_put_autosuspend() on error path as well.

Fixes: cde4cb5dd422 ("iio: magn: ak8975: deploy runtime and system PM")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260505-magnetometer-fixes-v5-0-831b9b5550fc%40gmail.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/ak8975.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -784,6 +784,7 @@ static int ak8975_read_axis(struct iio_d
 
 exit:
 	mutex_unlock(&data->lock);
+	pm_runtime_put_autosuspend(&data->client->dev);
 	dev_err(&client->dev, "Error in reading axis\n");
 	return ret;
 }


