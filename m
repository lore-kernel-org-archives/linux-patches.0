Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A3D4207F;
	Wed,  6 Nov 2024 12:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896218; cv=none; b=XhGcbNGqAgAs7QKilsgBZ6jXmByD0Cu9eJNc58UZFoIAc8NEJQMiGQx4SoLqx6Ap554xuj1peiMLuIDM/Zp6Wwnyhk00y1tyTNmuimTjlhOk4IVHx8fMEpM/IWpVlsAYM8XE+sqeN7EHFd2o6iyDrajCrBDagk/NyeBWjDl75Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896218; c=relaxed/simple;
	bh=Vc5WL8RQh2rb1a+IIO/oavQ9+fHtmm+FdXEfrV8iv4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFdsMs7E7ckHvMLnhxCE4qaixnagq8eUNlHBGeMpjg9SbSNAKkvC0YpAG7znH8mWgNZx2q+yMOrOaVqUq327ZyG7tO0JsmsQwoa/yr/v3bX4BtCAYZ7fLDYs8aK23JeLL6rJfCodTrXeqQLZ78IsPVDr1+0XIENH6EG2GvlJkng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8ZX/0d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8ZX/0d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E601C4CED3;
	Wed,  6 Nov 2024 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896217;
	bh=Vc5WL8RQh2rb1a+IIO/oavQ9+fHtmm+FdXEfrV8iv4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8ZX/0d49V47SZkb2RpV7Pdw4BheTqfRe8J7a8VgvBVbscsUCKqZ64ILpYUkjq7C0
	 NWS4pQ84zeOHTCYiFiy6xk42dyP3V5qfr1meVU0hG2Pe6b41R2MVYaNz7xPdefgAqZ
	 T/Wy9+5X3ntokwoIWYlPKQfkgDw3YuTxMQfTsmiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 130/245] iio: gts-helper: Fix memory leaks for the error path of iio_gts_build_avail_scale_table()
Date: Wed,  6 Nov 2024 13:03:03 +0100
Message-ID: <20241106120322.423227991@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 369f05688911b05216cfcd6ca74473bec87948d7 upstream.

If per_time_scales[i] or per_time_gains[i] kcalloc fails in the for loop
of iio_gts_build_avail_scale_table(), the err_free_out will fail to call
kfree() each time when i is reduced to 0, so all the per_time_scales[0]
and per_time_gains[0] will not be freed, which will cause memory leaks.

Fix it by checking if i >= 0.

Cc: stable@vger.kernel.org
Fixes: 38416c28e168 ("iio: light: Add gain-time-scale helpers")
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20241016012453.2013302-1-ruanjinjie@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-gts-helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-gts-helper.c
+++ b/drivers/iio/industrialio-gts-helper.c
@@ -313,7 +313,7 @@ static int iio_gts_build_avail_scale_tab
 	return 0;
 
 err_free_out:
-	for (i--; i; i--) {
+	for (i--; i >= 0; i--) {
 		kfree(per_time_scales[i]);
 		kfree(per_time_gains[i]);
 	}


