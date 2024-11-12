Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0B0219C9F;
	Tue, 12 Nov 2024 10:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408350; cv=none; b=lYOo5pOediVru+N1lRMAe/iT9OJy81g2fQ7i+I2fe8Cqea3pH91BlyN2NDWGbfC4LEDgbM4qiz/QimNMSSHZAJAopPIrTc9z25ba8u1PNOAubCJdg2XEbbKl1abKi5PjmK1BV3BiP9n81nzex582UuF/MHs4wylKTgsXhosj44A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408350; c=relaxed/simple;
	bh=3H1QckuKRivPh3Gqh3UqH6PQWTYu1AZ+gAER/Fp/qMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WF67yCI/222ipg3fnBpWcESuLVol1vUq4U8jib8pISrQ0ycIBHDKz5vAHHetQdWGlLG+9wqf6uvP+pDGtV/wiBnjBe1b0JAKAOEom92vct3liD/fyatB3JC0BXVxX0wA5UBx+wu2eQwGwZBmuX/05C+4kACmW5i8/A/jjCVfI0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z75kNJG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z75kNJG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34817C4CED4;
	Tue, 12 Nov 2024 10:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408350;
	bh=3H1QckuKRivPh3Gqh3UqH6PQWTYu1AZ+gAER/Fp/qMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z75kNJG2ltHBJXkx6fmMq+YXRVFy1XpTzCUVBMbfGaV/fZLX8ccUojCAPFxWhOzji
	 KhCMbEZQ5NgsXsxusO/6QMqRSNGU0xI2ZcjOlbPFXmMQeS7DdZwYY+HFHWc0S7ElQb
	 JgS4KCWXflgFhoE8QHE6dfoEds3lmV2R0mWRSDL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 094/184] drm/xe: Drop VM dma-resv lock on xe_sync_in_fence_get failure in exec IOCTL
Date: Tue, 12 Nov 2024 11:20:52 +0100
Message-ID: <20241112101904.467704742@linuxfoundation.org>
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

commit 64a2b6ed4bfd890a0e91955dd8ef8422a3944ed9 upstream.

Upon failure all locks need to be dropped before returning to the user.

Fixes: 58480c1c912f ("drm/xe: Skip VMAs pin when requesting signal to the last XE_EXEC")
Cc: <stable@vger.kernel.org>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241105043524.4062774-3-matthew.brost@intel.com
(cherry picked from commit 7d1a4258e602ffdce529f56686925034c1b3b095)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_exec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/xe/xe_exec.c
+++ b/drivers/gpu/drm/xe/xe_exec.c
@@ -212,6 +212,7 @@ retry:
 			fence = xe_sync_in_fence_get(syncs, num_syncs, q, vm);
 			if (IS_ERR(fence)) {
 				err = PTR_ERR(fence);
+				xe_vm_unlock(vm);
 				goto err_unlock_list;
 			}
 			for (i = 0; i < num_syncs; i++)


