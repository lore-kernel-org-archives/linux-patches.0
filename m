Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76109438468;
	Thu, 30 Jul 2026 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422593; cv=none; b=PqGKjTdxRxVIAl+MLKa1FFFkGjbx5Uvj8epCP+5IC7G8TMCR8AMEl52j3vXsK+fIG+n9oO9XSmvfFKxJzyenSsFGXF4ihnD3MtLZfIkTGpY/eypfHCkTHMUmNeu5c9MjD9loV6bBGg5hqwoDe+0s1mLnvyKQ8STLP3UnDfpNqbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422593; c=relaxed/simple;
	bh=I7ri4ikLB6EaYeoYiUcH1YwYPsYmBY8/2eSHVczQxGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eo3/0W465fhTomZz17B88KBBvfI8QxqMHpmeMl9PE/vWCdG9mh0r3Rc1IxxlYf8s7VdYeJ/RsIX1wn4/01i32L5My15jweuLilNWfBEFxOewpDUM7xW3bGK6oo4kXkQ2+3NGGv0v4ktUM+a31GFQHCgdqHiIyMTRGvhk8JAluYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1NYpZKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1NYpZKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C95D1F000E9;
	Thu, 30 Jul 2026 14:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422588;
	bh=D6gs44D4dVGfbuBXkjHoWuQb7Ln/85AtQpP/FpYeXYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1NYpZKy1a5F7aECK9xYrHurG+UDfNqDCGoIhjOHa7JOfaGHTUevwghNEqZ1NSKn7
	 hVd+nRpzFbR4aYBnpjSNOcwuf5xe+kKpeoxdkQZEs0PiTKdGMwdYX2qSAT7V2zEpBD
	 Lg3PKLaZvZbJ8KjYrXW1uZKsUDdwsY74a0nSyX28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 489/744] media: mali-c55: Add missing of_reserved_mem_device_release()
Date: Thu, 30 Jul 2026 16:12:42 +0200
Message-ID: <20260730141454.687736237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 38e3509dd98d7e970db87e13f8ec7412852a6967 upstream.

mali_c55_probe() calls of_reserved_mem_device_init() to associate
reserved memory regions with the device. This function allocates a
struct rmem_assigned_device and adds it to a global linked list, which
must be explicitly released via of_reserved_mem_device_release() — there
is no devm variant of this API.

However, neither the probe error paths nor mali_c55_remove() called
of_reserved_mem_device_release(). Any probe failure after the
of_reserved_mem_device_init() call, as well as every normal device
removal, leaked the reserved memory association on the global list.

Fix this by adding an err_release_mem label at the end of the probe
error chain and calling of_reserved_mem_device_release() in
mali_c55_remove(). The remove teardown order is also corrected to call
mali_c55_media_frameworks_deinit() before kfree(), mirroring the probe
init order in reverse.

Cc: stable@vger.kernel.org
Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-core.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/arm/mali-c55/mali-c55-core.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-core.c
@@ -806,8 +806,10 @@ static int mali_c55_probe(struct platfor
 	vb2_dma_contig_set_max_seg_size(dev, UINT_MAX);
 
 	ret = __mali_c55_power_on(mali_c55);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to power on\n");
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to power on\n");
+		goto err_release_mem;
+	}
 
 	ret = mali_c55_check_hwcfg(mali_c55);
 	if (ret)
@@ -846,6 +848,8 @@ err_free_context_registers:
 	kfree(mali_c55->context.registers);
 err_power_off:
 	__mali_c55_power_off(mali_c55);
+err_release_mem:
+	of_reserved_mem_device_release(dev);
 
 	return ret;
 }
@@ -854,8 +858,9 @@ static void mali_c55_remove(struct platf
 {
 	struct mali_c55 *mali_c55 = platform_get_drvdata(pdev);
 
-	kfree(mali_c55->context.registers);
 	mali_c55_media_frameworks_deinit(mali_c55);
+	kfree(mali_c55->context.registers);
+	of_reserved_mem_device_release(&pdev->dev);
 }
 
 static const struct of_device_id mali_c55_of_match[] = {


