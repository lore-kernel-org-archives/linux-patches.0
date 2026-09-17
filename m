Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585934F5DE6;
	Thu, 17 Sep 2026 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664349; cv=none; b=PJ3muom6dLCuYthv0wHWc2c+jz5hvgx2mmrrhJ1anWF0eMv4ck5FE9XLUjJhfLVUHm3Apveh9nkxBeSEQWZLhHijVUzb9AnCzPf9eZQZRFWNLDdgir9028R3Op9xQkIBq3dDUzo/UZ9hoxf3nUCcW1DZwXIDnHvMVh4kSYrFek0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664349; c=relaxed/simple;
	bh=SK4QGYGUHM9M647ujHRPBB4zTC8819xSHJIr5IWi22s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZT7/f6oIHTIJ13rDfMmuNKYYOdVNh6iEyEQQk0EKBAxbBncqGmTwHhW485WAke0Mkwz6bcFcmmgZpaqJwYJCI/DzHTjPS6WDd0eJdmqiAaM5HBFw6d26a+QhdAFTXhOIruNrvmJZ+WbKb5z/DFDpx5ew6CFhPQpNrF0xZtNhw0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5VThaR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5VThaR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0CC1F000FF;
	Thu, 17 Sep 2026 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664348;
	bh=usNWY83dutTTdpyCebpsBd0U/oSrcLzWo9ViF6b7euk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5VThaR1KVwJVchIH7BxXDi49Huhb15jjng0oowSPWbTAWXsMNx6dKZTFH3MzMKIO
	 oZRjPuUbskjvDHjzb32ZlPrnn1xOIr+YSEYISUEaRf52qdhXNzAltTryJcZJBhfD7W
	 SqwHe5mI2A3uydMEKwutmBEx8ierzdkxMpfGYQw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0335/1250] drm/amdkfd: Unwind debug trap enable on copy_to_user failure
Date: Thu, 17 Sep 2026 16:02:10 +0100
Message-ID: <20260917151601.166966160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 986cb297de8f8..78e1dfdb27147 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
@@ -816,6 +816,12 @@ int kfd_dbg_trap_enable(struct kfd_process *target, uint32_t fd,
 
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



