Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377083515C5;
	Wed, 30 Sep 2026 18:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794343; cv=none; b=aa9hajwgYXlWwBuSmODZLui8/jDqIoJr48PD5+dgF3ZfxwKjOqyaE3JF0+X9ff2nUmoPCJQF7oXl7RaUqds7fza2zicr1Kp57pm7kRcDKEiVNyAFDtgGVQBPM6SEbtKZXwM89XkIMKn4Yw8NNxqBkYWQqjqGWF1iMGIs/xZaJOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794343; c=relaxed/simple;
	bh=xo9raRj3hI8qMCpn67pUki5GJRoXTv5DMWVyOx0RsxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uffz1z3J8ONvU3ZfYcQbsxZY1ulGTay36JfJVgsXCMeEyS77P34UJfzVx8peaF0Fyak14SMPSTOy189Z2jS+wphj5GmMmwDtEyiGeCf6y1vn9qeotJ/0Ugn9PySMABZ2iuL76ZXWL+1EJx257dPh4nT8RVP9QgCdbSBVjvmHLSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heBYXHCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heBYXHCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1101F000FF;
	Wed, 30 Sep 2026 18:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794342;
	bh=+lTE0ARmEDa//DrPWVkHQqhlUDcBT2L60OpQyjBJrHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heBYXHCs+YPv+ndt6ZwLFvL5tg59wVprHURLrNUER1NO4Cf3UY+Q/3e21VlIiP7y9
	 5i54iarBwNqfCJSzrf3hTzn0y4nb+rTUzd4Ko8rGjTssAKlmPlaUQt1uVM0hE512XK
	 JYQTjSzpyGfDleaOozG23Rp/X+GOaV1DicNxgNag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0177/1193] drm/amdkfd: Unwind debug trap enable on copy_to_user failure
Date: Wed, 30 Sep 2026 17:14:21 +0200
Message-ID: <20260930152438.126252256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 01112e241e37f9ac98b6f418d93ce2e0b87b7ee0 ]

If kfd_dbg_trap_enable() fails while copying runtime_info to userspace,
it had already activated the trap, set debug_trap_enabled, taken an extra
process reference, and opened the debug event file. Return -EFAULT without
unwinding that state, leaving inconsistent trap state and a refcount
imbalance that could break later DISABLE/ENABLE.

On copy_to_user failure, deactivate the trap and undo the rest of the
enable setup before returning.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
index 267650dcced9d..bc92d88caea2d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
@@ -805,6 +805,12 @@ int kfd_dbg_trap_enable(struct kfd_process *target, uint32_t fd,
 
 	if (copy_to_user(runtime_info, (void *)&target->runtime_info, copy_size)) {
 		kfd_dbg_trap_deactivate(target, false, 0);
+		fput(target->dbg_ev_file);
+		target->dbg_ev_file = NULL;
+		if (target->debugger_process)
+			atomic_dec(&target->debugger_process->debugged_process_count);
+		target->debug_trap_enabled = false;
+		kfd_unref_process(target);
 		r = -EFAULT;
 	}
 
-- 
2.53.0



