Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2868268C4F;
	Tue,  8 Apr 2025 12:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115506; cv=none; b=MfBR1v5F59Bn2chlrJ6meqN5P35uQk4eEv3DEXRt2SH8AaDAj5xGb/wXQy9HY6rLNBxd4O6gejQxJblvhcwUZB349twDk8awFNoa3h4/hAgrSGxM8BU7h2eGM3x/8IJn/a+UkmxMii5tOLnmY88oPYIVd1eg9+DdEBqvWnuaJOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115506; c=relaxed/simple;
	bh=Tfq1VcWKM8rcfSPqQbwJi4MQ8Oc6HWrrx+zPMNH94iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GaHJsCPnN9Cl0JxfphBnAjQqYeE0uHTv2V9KLOENY/bD5kdGYZMrpBQ/SE+WgmLzF81kZVPNgwSga0GJ4t+2PaHfxYzywPMvczxFHsQp6sBfVtmVCbC4dMKiLKFrdOgYrp88Ch1+T3csREghqBz8FWI6MIRP4shtUNCHX0I/riU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgB7jlT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgB7jlT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321CAC4CEE5;
	Tue,  8 Apr 2025 12:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115506;
	bh=Tfq1VcWKM8rcfSPqQbwJi4MQ8Oc6HWrrx+zPMNH94iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgB7jlT7Erxcs+i4U0uwMwmvcuJ/DR3BM/Wx2E7s4Lu5tkEopSO0GH3NLO2mN0MEc
	 YqBJQPu2rQDln5Xb9yJ+fFWJwJXsWeFZnsXp5zvO3tICvRif3fZk96+m7QCHGRozHS
	 qNviYkH3lAe8sPG2r91wiOs0Im1HXZ9lldteEC88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.13 499/499] platform/x86/amd/pmf: fix cleanup in amd_pmf_init_smart_pc()
Date: Tue,  8 Apr 2025 12:51:51 +0200
Message-ID: <20250408104903.806537828@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 5b1122fc4995f308b21d7cfc64ef9880ac834d20 upstream.

There are a few problems in this code:

First, if amd_pmf_tee_init() fails then the function returns directly
instead of cleaning up.  We cannot simply do a "goto error;" because
the amd_pmf_tee_init() cleanup calls tee_shm_free(dev->fw_shm_pool);
and amd_pmf_tee_deinit() calls it as well leading to a double free.
I have re-written this code to use an unwind ladder to free the
allocations.

Second, if amd_pmf_start_policy_engine() fails on every iteration though
the loop then the code calls amd_pmf_tee_deinit() twice which is also a
double free.  Call amd_pmf_tee_deinit() inside the loop for each failed
iteration.  Also on that path the error codes are not necessarily
negative kernel error codes.  Set the error code to -EINVAL.

There is a very subtle third bug which is that if the call to
input_register_device() in amd_pmf_register_input_device() fails then
we call input_unregister_device() on an input device that wasn't
registered.  This will lead to a reference counting underflow
because of the device_del(&dev->dev) in __input_unregister_device().
It's unlikely that anyone would ever hit this bug in real life.

Fixes: 376a8c2a1443 ("platform/x86/amd/pmf: Update PMF Driver for Compatibility with new PMF-TA")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/232231fc-6a71-495e-971b-be2a76f6db4c@stanley.mountain
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmf/tee-if.c |   36 +++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -510,18 +510,18 @@ int amd_pmf_init_smart_pc(struct amd_pmf
 
 	ret = amd_pmf_set_dram_addr(dev, true);
 	if (ret)
-		goto error;
+		goto err_cancel_work;
 
 	dev->policy_base = devm_ioremap_resource(dev->dev, dev->res);
 	if (IS_ERR(dev->policy_base)) {
 		ret = PTR_ERR(dev->policy_base);
-		goto error;
+		goto err_free_dram_buf;
 	}
 
 	dev->policy_buf = kzalloc(dev->policy_sz, GFP_KERNEL);
 	if (!dev->policy_buf) {
 		ret = -ENOMEM;
-		goto error;
+		goto err_free_dram_buf;
 	}
 
 	memcpy_fromio(dev->policy_buf, dev->policy_base, dev->policy_sz);
@@ -531,13 +531,13 @@ int amd_pmf_init_smart_pc(struct amd_pmf
 	dev->prev_data = kzalloc(sizeof(*dev->prev_data), GFP_KERNEL);
 	if (!dev->prev_data) {
 		ret = -ENOMEM;
-		goto error;
+		goto err_free_policy;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(amd_pmf_ta_uuid); i++) {
 		ret = amd_pmf_tee_init(dev, &amd_pmf_ta_uuid[i]);
 		if (ret)
-			return ret;
+			goto err_free_prev_data;
 
 		ret = amd_pmf_start_policy_engine(dev);
 		switch (ret) {
@@ -550,27 +550,41 @@ int amd_pmf_init_smart_pc(struct amd_pmf
 			status = false;
 			break;
 		default:
-			goto error;
+			ret = -EINVAL;
+			amd_pmf_tee_deinit(dev);
+			goto err_free_prev_data;
 		}
 
 		if (status)
 			break;
 	}
 
-	if (!status && !pb_side_load)
-		goto error;
+	if (!status && !pb_side_load) {
+		ret = -EINVAL;
+		goto err_free_prev_data;
+	}
 
 	if (pb_side_load)
 		amd_pmf_open_pb(dev, dev->dbgfs_dir);
 
 	ret = amd_pmf_register_input_device(dev);
 	if (ret)
-		goto error;
+		goto err_pmf_remove_pb;
 
 	return 0;
 
-error:
-	amd_pmf_deinit_smart_pc(dev);
+err_pmf_remove_pb:
+	if (pb_side_load && dev->esbin)
+		amd_pmf_remove_pb(dev);
+	amd_pmf_tee_deinit(dev);
+err_free_prev_data:
+	kfree(dev->prev_data);
+err_free_policy:
+	kfree(dev->policy_buf);
+err_free_dram_buf:
+	kfree(dev->buf);
+err_cancel_work:
+	cancel_delayed_work_sync(&dev->pb_work);
 
 	return ret;
 }


