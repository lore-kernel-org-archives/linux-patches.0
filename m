Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A0C21440F;
	Tue, 12 Nov 2024 10:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408213; cv=none; b=Ha3sNuU9JE2ODK51rA/g93FYdzE0GXk3s8+V15pB2rICCpZxlKiaEpp1sDQcYtV0at4jZYp0ZiAKqonPZzqvfyVwxQr4M5wYY+GKwXG7fseKd1yA8YB9X/nO2WtXN8yPpZzl1mHs//Ir+vUB5svhrvq7etpSzDCos1b80NSTnIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408213; c=relaxed/simple;
	bh=TIy9eCEdWBeVkdzLP/cM/fATaCsDCNpLr0tb0ELbLMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXLF3/6ovOn6c7ryP6OYuLV4ZdDEaBfhqax8n/15u8mk9KtxTFLmYllH/FhU0+JM0WeYFnZv5mZNAW9odxe+PhcHPmBUAc6Ooft4cs6EqzsofG6cd50/5h5VJF4aYXBlu8g9h8QDhK3C0fTMmu5Tn+6IHi01ApBPKvIIANeqk2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7Q8mI5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7Q8mI5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C44C4CECD;
	Tue, 12 Nov 2024 10:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408213;
	bh=TIy9eCEdWBeVkdzLP/cM/fATaCsDCNpLr0tb0ELbLMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7Q8mI5U6DOXcYarUjxQ090PQLjhj6zRzqrscflXFn0JNN0uNqTlTa6dYD/9N+XkK
	 2rjxPaC9mjDSmUYB/WyIRlCsDMBN4PeA6JmQUR5Wk5FqIkpSYaINipJ3uq2pUcuIqZ
	 MMtLZEJ+UAGhCFjWgfNGofamfc/hvjKU0I268rDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 093/184] drm/xe: Fix possible exec queue leak in exec IOCTL
Date: Tue, 12 Nov 2024 11:20:51 +0100
Message-ID: <20241112101904.429016183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit af797b831d8975cb4610f396dcb7f03f4b9908e7 upstream.

In a couple of places after an exec queue is looked up the exec IOCTL
returns on input errors without dropping the exec queue ref. Fix this
ensuring the exec queue ref is dropped on input error.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241105043524.4062774-2-matthew.brost@intel.com
(cherry picked from commit 07064a200b40ac2195cb6b7b779897d9377e5e6f)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_exec.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_exec.c
+++ b/drivers/gpu/drm/xe/xe_exec.c
@@ -129,12 +129,16 @@ int xe_exec_ioctl(struct drm_device *dev
 	if (XE_IOCTL_DBG(xe, !q))
 		return -ENOENT;
 
-	if (XE_IOCTL_DBG(xe, q->flags & EXEC_QUEUE_FLAG_VM))
-		return -EINVAL;
+	if (XE_IOCTL_DBG(xe, q->flags & EXEC_QUEUE_FLAG_VM)) {
+		err = -EINVAL;
+		goto err_exec_queue;
+	}
 
 	if (XE_IOCTL_DBG(xe, args->num_batch_buffer &&
-			 q->width != args->num_batch_buffer))
-		return -EINVAL;
+			 q->width != args->num_batch_buffer)) {
+		err = -EINVAL;
+		goto err_exec_queue;
+	}
 
 	if (XE_IOCTL_DBG(xe, q->ops->reset_status(q))) {
 		err = -ECANCELED;


