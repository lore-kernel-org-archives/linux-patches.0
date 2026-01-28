Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE7930BBBC;
	Wed, 28 Jan 2026 16:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616128; cv=none; b=pPm3+9IHwGSZLq7JaHFZd1X+8PTzA8sn3IpNiNQbvmsWDD63JFfGcVsBHpnb+gdSm2rUYk6OaGVRHjSlkyiaAETKiBmqtL1RXkbLhZ1To+WFRQzt5RAQuqrldXunTOukLPM5pujxce58PWU3KrRIlmQsP+IvvjCKaZcjA6zTnq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616128; c=relaxed/simple;
	bh=ZXauBZ7t6zl3/f5DAXVZPeUqNk69NF841fb8gCFK9g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nrsmzW25q0GHO3lVXFmpReaerVTRPl9MKjsk2z1b0z/BwK6be/U2kscQWVQBpP6eKG6DQD/WksLc9bR7Wq78Pqg62P5Va+8m8TTOn30Ct7CI/kYLIJAw1xHCtjoSSZ6b4XU0dbYRNgJFgb3+Hn++eJu5cpOK1okUEjQVU4O6Zg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7pedKUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7pedKUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FC8C4CEF1;
	Wed, 28 Jan 2026 16:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616128;
	bh=ZXauBZ7t6zl3/f5DAXVZPeUqNk69NF841fb8gCFK9g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7pedKUfgYy6HIlft3lADvcSxfM8doljUn3T60i4Dw1tp10Hd2cPV5L7FRvrZ5CdP
	 MkzmSySJussJG7AGvwxtLnY2sMvvY335zUmeaBm+RxIeM2NmRK4EUOvZa62WbpIswk
	 ZAkWwAVMj0OCAALj9dMnzpxMAK+d7uc2iERJFz2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Crivellari <marco.crivellari@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 215/227] drm/xe: fix WQ_MEM_RECLAIM passed as max_active to alloc_workqueue()
Date: Wed, 28 Jan 2026 16:24:20 +0100
Message-ID: <20260128145352.171207120@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Marco Crivellari <marco.crivellari@suse.com>

commit 6f287b1c8d0e255e94e54116ebbe126515f5c911 upstream.

Workqueue xe-ggtt-wq has been allocated using WQ_MEM_RECLAIM, but
the flag has been passed as 3rd parameter (max_active) instead
of 2nd (flags) creating the workqueue as per-cpu with max_active = 8
(the WQ_MEM_RECLAIM value).

So change this by set WQ_MEM_RECLAIM as the 2nd parameter with a
default max_active.

Fixes: 60df57e496e4 ("drm/xe: Mark GGTT work queue with WQ_MEM_RECLAIM")
Cc: stable@vger.kernel.org
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260108180148.423062-1-marco.crivellari@suse.com
(cherry picked from commit aa39abc08e77d66ebb0c8c9ec4cc8d38ded34dc9)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_ggtt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -291,7 +291,7 @@ int xe_ggtt_init_early(struct xe_ggtt *g
 	else
 		ggtt->pt_ops = &xelp_pt_ops;
 
-	ggtt->wq = alloc_workqueue("xe-ggtt-wq", 0, WQ_MEM_RECLAIM);
+	ggtt->wq = alloc_workqueue("xe-ggtt-wq", WQ_MEM_RECLAIM, 0);
 	if (!ggtt->wq)
 		return -ENOMEM;
 


