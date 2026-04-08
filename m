Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A75335CB6F;
	Wed,  8 Apr 2026 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673246; cv=none; b=I5pgSp6bVlEb63mOwZvZ6FThBe0eYgBVUhn7ft7Kz59XD6hXktrzXfl0ZGpgvluKJBoxIqNi4bUgQeBSil7fzJoAiDbA4shxm2edvnITb/h7DjBi06rcSFSDEru5aolhO58Jt3lIUemsmCJ6cDYUjR/7GIymGuETa9GKR7RUPxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673246; c=relaxed/simple;
	bh=BE2GL9iKt/ZXcgc++zFoRt2ianJ09YEzjYzFiuuZ3PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mWpyR/caITVlQrQEHNDWlAfcaLQpfiQGHNjRKIbVTlXi3gmsWRXaquFsjqYYYtUO0kK5En84gh4L5EBvcY9yxPoAIOk3E2RzauxdJvaAdGN9YCOVoqdXW7palMBH9Rn/XprVlwLJzpubgd4HjUXLl3VmDBe3WLYx7/lG9fxsyU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1dshGx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1dshGx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7087C19421;
	Wed,  8 Apr 2026 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673246;
	bh=BE2GL9iKt/ZXcgc++zFoRt2ianJ09YEzjYzFiuuZ3PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1dshGx10ouIdcgQjS7GRb1roW10Kn/HgC9XEvtXlq0IjIPP0I2VoZqYSTGf2o5Ax
	 MORJqnKwsHqvuZM7F9maYiXof+G1IYXAdtPYnfXD/mURLCyHdsQoR3nYp5bgEA1L/H
	 pGhBh3CkFZeC2HgxnklSre4LKfbXjTlvbhE8Xa9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <jpaulo.silvagoncalves@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 158/277] iio: adc: ti-ads1119: Fix unbalanced pm reference count in ds1119_single_conversion()
Date: Wed,  8 Apr 2026 20:02:23 +0200
Message-ID: <20260408175939.771067321@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 48a5c36577ebe0144f8ede70e59b59ea18b75089 upstream.

In ads1119_single_conversion(), if pm_runtime_resume_and_get() fails,
the code jumps to the pdown label, which calls
pm_runtime_put_autosuspend().

Since pm_runtime_resume_and_get() automatically decrements the usage
counter on failure, the subsequent call to pm_runtime_put_autosuspend()
causes an unbalanced reference counter.

Fixes: a9306887eba4 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: João Paulo Gonçalves <jpaulo.silvagoncalves@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -274,7 +274,7 @@ static int ads1119_single_conversion(str
 
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret)
-		goto pdown;
+		return ret;
 
 	ret = ads1119_configure_channel(st, mux, gain, datarate);
 	if (ret)


