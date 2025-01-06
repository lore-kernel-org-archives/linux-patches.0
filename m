Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABE11DC991;
	Mon,  6 Jan 2025 15:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178085; cv=none; b=pT9cpQZAQlU/EtpEzj+v1YwFlXjKWg3VaWWdym7XcQKUsK7U/tIuEor/BnmlQMZ4bf6g7efSYn2AyVlV9uf82bfXc2G5so3vIRdT15Rzq0xdYcjosEF3BM9NyayukLaY47mWcL/gmeBu2psFLLoou5KMS87Nlqozkog+wFekhew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178085; c=relaxed/simple;
	bh=yXHlmevvbHmrUngPioYOhgArMc3g0DbrFCUs7JUYW88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZpahrjrJrQm1GQEdPWkK4tmLqOHqFf0FYk4Jhk14two89zjTwOWkiGgbpQgX25kKixCQisFM5HuzWDji4m6wH/UlKObSOklAfez8/DhCS27NjJ0vi65jlNWZXN9bU7K+ZBfTouLI3jIkAzxyfNXFSNt1H2w+QWftKwRDjdhTqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGImKIMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGImKIMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99209C4CED2;
	Mon,  6 Jan 2025 15:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178085;
	bh=yXHlmevvbHmrUngPioYOhgArMc3g0DbrFCUs7JUYW88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGImKIMcjA8+Wy++/W0ny0uat+7aP84zWXVYjc4hCVaNUqRVhwAZGGNuNbxC36Z4U
	 TIMge0d4t0jpMJFZdFPsgH6laIufViTEcAgCfnjT4V0PoW4jyIOc5y/fEsOE4O9tNH
	 QOMliEH3NbGgVtEuP5AaXYlGexXxVg7qj5bdFoXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>
Subject: [PATCH 6.12 115/156] drm/xe: Use non-interruptible wait when moving BO to system
Date: Mon,  6 Jan 2025 16:16:41 +0100
Message-ID: <20250106151146.058072507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

commit 528cef1b4170f328d28d4e9b437380d8e5a2d18f upstream.

Ensure a non-interruptible wait is used when moving a bo to
XE_PL_SYSTEM. This prevents dma_mappings from being removed prematurely
while a GPU job is still in progress, even if the CPU receives a
signal during the operation.

Fixes: 75521e8b56e8 ("drm/xe: Perform dma_map when moving system buffer objects to TT")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: stable@vger.kernel.org # v6.11+
Suggested-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241213122415.3880017-1-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit dc5e20ae1f8a7c354dc9833faa2720254e5a5443)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -722,7 +722,7 @@ static int xe_bo_move(struct ttm_buffer_
 	    new_mem->mem_type == XE_PL_SYSTEM) {
 		long timeout = dma_resv_wait_timeout(ttm_bo->base.resv,
 						     DMA_RESV_USAGE_BOOKKEEP,
-						     true,
+						     false,
 						     MAX_SCHEDULE_TIMEOUT);
 		if (timeout < 0) {
 			ret = timeout;


