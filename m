Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1135254B03;
	Mon, 23 Jun 2025 13:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684952; cv=none; b=ZhxBqDM485DA9IPr7JW9wvjEn9l36c+8eufhf5ae/NPDt+Hnjj6BOfATS79F2GOWH6aavB2CP5K8zC/lOp3SC8kz29o7yAAfzwdzXnPZYrBQVbyYegiYL7eMuYqfoCnKkdl6oek3DSfkf/wcNCmDSI4tw9SRb7cUd5Xy+N0+21c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684952; c=relaxed/simple;
	bh=U1TM1fbcvPlSeV/mxR0JEz1dg/WfygfjVCsw5RaqZuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTBOzwfQR8MJ3Hxx4lxap7cGmNiD9ev6tr1+HQeWK9ugQrJAXe2Hrnq+D5IEukuVEcai6z9M8E804pRXUy7/elSAaWrejPb0v/9TtGyrscnPKt76Bu9kP7IwdIcJgQwowqA1qzOdd2obCTn9d1RR3ZydDsSZniKozi2tTeG7RqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J38S28f7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J38S28f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E6DC4CEEA;
	Mon, 23 Jun 2025 13:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684952;
	bh=U1TM1fbcvPlSeV/mxR0JEz1dg/WfygfjVCsw5RaqZuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J38S28f7DsVsXqBih4dYqOtCPKvvlasp3znRTFYjX8mXJuMa/Z8WCBNyJtnoSSC3O
	 djsjqJkv5KSQ9ZnAGfNqzk1Dqv5YTqMveH0ltxk3qBevIKjgbfbhN07cquG5FC4R38
	 pD2wAEVrvb1xpF0y9nDuxohEeBa7KUsw4PE6/+Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.15 194/592] accel/ivpu: Fix warning in ivpu_gem_bo_free()
Date: Mon, 23 Jun 2025 15:02:32 +0200
Message-ID: <20250623130704.904770624@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 91274fd4ed9ba110b02c53d71d2778b7d13b49ac upstream.

Don't WARN if imported buffers are in use in ivpu_gem_bo_free() as they
can be indeed used in the original context/driver.

Fixes: 647371a6609d ("accel/ivpu: Add GEM buffer object management")
Cc: stable@vger.kernel.org # v6.3
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250528171220.513225-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -285,7 +285,8 @@ static void ivpu_gem_bo_free(struct drm_
 	list_del(&bo->bo_list_node);
 	mutex_unlock(&vdev->bo_list_lock);
 
-	drm_WARN_ON(&vdev->drm, !dma_resv_test_signaled(obj->resv, DMA_RESV_USAGE_READ));
+	drm_WARN_ON(&vdev->drm, !drm_gem_is_imported(&bo->base.base) &&
+		    !dma_resv_test_signaled(obj->resv, DMA_RESV_USAGE_READ));
 	drm_WARN_ON(&vdev->drm, ivpu_bo_size(bo) == 0);
 	drm_WARN_ON(&vdev->drm, bo->base.vaddr);
 


