Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA023F9F2F;
	Tue, 21 Jul 2026 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653923; cv=none; b=UVBW6DyaNaAiVKx3BwgYjYV7nwagkx+QZDnPLCfhBbSG/OSXw5o+OP0MeVPKZ2jhCRmc2cvwGTUuovHREirlidiZvpVI+o0PYfNnLNniBGnk0BbhjyRjSB5EjSXqyKqznMrfH2dq1FICpGbkU21YkMnfFnH0GVCzymh3gM6NpE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653923; c=relaxed/simple;
	bh=3SS09dk9VFFzQrfdVf4t7o6SW/dyVPlJ6pIrZv/tR6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUZfdVBw3zkFrRxOVpqUorJl/6yAyxDpwG6Vw6G/PwVC0TQanxnaUaUJexeeW0B+LJNOpe8pEt0jl96/ievDEgkcwN9CPSSnIIPQmPmX6YG0kECXLUrS36iybFbqWzkgSXkXhecrLvXz5DFmGppPyqsX3HuqEro0LzizDJcQLwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrPkNmJO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrPkNmJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B3A1F00A3A;
	Tue, 21 Jul 2026 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653922;
	bh=tTM4S4aH7HIBb+8ZZU2ErPj8YNxLgNxl98grpR7nAgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrPkNmJO3RW1OeTR7jdZ14N09Od8y0Z9zDFU96KIQZXzDd5Wtd51tzdVN1RcUFi+8
	 uaGZd5bwTbQpnJg1MbLjCNKlaojJurqyHL4mn2B9xTIZ9rLl58Da8yoNrimnBJgKOl
	 7GOdZYAj3zsI2uTm2sf04dw5wP4weoboBk4rEA4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1509/2077] drm/xe: free madvise VMA array on L2 flush failure
Date: Tue, 21 Jul 2026 17:19:42 +0200
Message-ID: <20260721152628.376772984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 14abbed336a2d1bbd726c25d148d2ec0ff928073 ]

xe_vm_madvise_ioctl() allocates madvise_range.vmas in get_vmas().
After get_vmas() succeeds with at least one VMA, error paths must go
through free_vmas so the array is released before the madvise details are
destroyed.

The L2 flush validation path added for PAT madvise rejects some
SVM/userptr ranges after get_vmas() has succeeded, but jumps directly to
madv_fini. This skips kfree(madvise_range.vmas), leaking the VMA array on
each failed ioctl.

Jump to free_vmas instead, matching the other validation failure paths
after get_vmas() has succeeded.

Fixes: 4f39a194d41e ("drm/xe/xe3p_lpg: Restrict UAPI to enable L2 flush optimization")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260708073422.725186-1-lgs201920130244@gmail.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit c3a1c3579b1250060da73507a4acef712974c78a)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm_madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_vm_madvise.c b/drivers/gpu/drm/xe/xe_vm_madvise.c
index c4fb290041956d..246fe18431428b 100644
--- a/drivers/gpu/drm/xe/xe_vm_madvise.c
+++ b/drivers/gpu/drm/xe/xe_vm_madvise.c
@@ -643,7 +643,7 @@ int xe_vm_madvise_ioctl(struct drm_device *dev, void *data, struct drm_file *fil
 				 xe_device_is_l2_flush_optimized(xe) &&
 				 (pat_index != 19 && coh_mode != XE_COH_2WAY))) {
 			err = -EINVAL;
-			goto madv_fini;
+			goto free_vmas;
 		}
 	}
 
-- 
2.53.0



