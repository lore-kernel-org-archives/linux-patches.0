Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09484284685;
	Wed, 23 Apr 2025 15:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421445; cv=none; b=cDIH9IHDVlgWjp+oLFnUn4cfi97Mlrw+1xAo0Jo+j6m0vi+WjXflBd+dNOdCn9OiZ2+5Qa0EngnFisiNSv+jBVFzZ6C4JKTvYxxp2zUhzCpVPDHKZNK+h2f23iw1W089hVDCis2VfUieJrLeKcL3uF1ZCklwmjVo61iBMjJuoVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421445; c=relaxed/simple;
	bh=UQUZPLrUjYAs+9jsOiuhdPyE0fXi6gAZAlWAC6pCKO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFDFfrZYyia2YU84VPOggx4muX1+ZYlPbQAEtoPAFeAaktZ9DjPVOeTGkXxPRY54KRnfWRF+rmBdbv7q+b9DyYQihNGBi5tHK/uOR3iN0aP2bJvsbP/6xNRn+tIjLSnJmTWhoSJCQwgsiVgakEWZexlZGOfusJQMBc6i3u5bhMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9P4jzLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9P4jzLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAE3C4CEE2;
	Wed, 23 Apr 2025 15:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421444;
	bh=UQUZPLrUjYAs+9jsOiuhdPyE0fXi6gAZAlWAC6pCKO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9P4jzLEvwXzjvVha7ODctAv6nFeMvGA7kZHQGzdS6PFnxUiFISiliy6EJwX5Wiei
	 GDg55oC7Bd9M5Gs0dlGvLK7JPkz80CxptaHDroiZPUrxnzD5LbOYdSL+AZzNf0fnG4
	 hSsmwHBWXz749w9+wsyArLWosvKUtbDO9924VmII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.14 190/241] drm/xe: Use local fence in error path of xe_migrate_clear
Date: Wed, 23 Apr 2025 16:44:14 +0200
Message-ID: <20250423142628.281846951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 20659d3150f1a2a258a173fe011013178ff2a197 upstream.

The intent of the error path in xe_migrate_clear is to wait on locally
generated fence and then return. The code is waiting on m->fence which
could be the local fence but this is only stable under the job mutex
leading to a possible UAF. Fix code to wait on local fence.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250311182915.3606291-1-matthew.brost@intel.com
(cherry picked from commit 762b7e95362170b3e13a8704f38d5e47eca4ba74)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -1177,7 +1177,7 @@ err:
 err_sync:
 		/* Sync partial copies if any. FIXME: job_mutex? */
 		if (fence) {
-			dma_fence_wait(m->fence, false);
+			dma_fence_wait(fence, false);
 			dma_fence_put(fence);
 		}
 


