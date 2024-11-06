Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2071FB3D0;
	Wed,  6 Nov 2024 12:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897571; cv=none; b=TXNYTusOUuHEpvzw9KuWO+C8bQbhMNUDkAIDJ6Z8AYmlW+cZEvIX06dsSHefI01CAkPfs2MU3Nqueutnf9zU/pKQaUc12PyL5VVtzAw/nf9yLLIF0E/1B2rw6TyXOABNlTdAky361VSCuJ1NcGQrr44KR71iD8hZJsCD2XO7sL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897571; c=relaxed/simple;
	bh=bO9ZslLvoT9Iimbl532a11Z7AU5UzQMxx9I5qsIGdyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VorMdXg6CkWhZcRuXD9uKG/I4HjTKPQX5g2zQfpotLI5a0f99lRkm2H3KQMisxP/LEgteDgWn2pX+gZKqNmth5N8oKevetHEfJYa5/KbwX5fzrPN/w6pqvo4MBfrkfNVIUbQeCpECBvP2O4i2oiwUe+RKt0PqeyZSvKgnjsqKbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xellU3Ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xellU3Ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416B0C4CECD;
	Wed,  6 Nov 2024 12:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897571;
	bh=bO9ZslLvoT9Iimbl532a11Z7AU5UzQMxx9I5qsIGdyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xellU3CaxJWS6dJux0BQSgReFgmk/SKcU6ih8zQWkm3Z3jSfosJKsJcXjmctMAHfD
	 CtVAcAj7VrlotfIOMYvmOkSZayM+eRHkMfxPvs4Gubswyujh2IKgnTolLJj9B43PQR
	 2yYt3UTKhTdGRW/ze7wPTRWTn9ImrTTwKF4N3ww8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 098/151] iio: gts-helper: Fix memory leaks for the error path of iio_gts_build_avail_scale_table()
Date: Wed,  6 Nov 2024 13:04:46 +0100
Message-ID: <20241106120311.570759484@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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


