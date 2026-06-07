Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B3B4204E;
	Sun,  7 Jun 2026 10:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829643; cv=none; b=LpPsUIJ3LEYQWeGcdOZlC02guC5VRmdeV0WfQiLH0kOuF6wEhMxyUBVutwtuQPQ0YbI8ad6tB3WOLml52m4g5KtsKyFbJGD3ihJb2gJHBkLB/hQfwdAhUTKcfm/N7tOw2obOQMFW81eAASpSIIO5ydI9zBBDSG0fLcnCgbc31aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829643; c=relaxed/simple;
	bh=oReckq/vrcxfTnGmroQVX0e2PsdribcNqM8+R/7i7ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUxLabhyvD5oBDX08Rp+KRZoUyg+U4ZWnTa8fo1q1JPUc9oQ1kJhUy2ZiL5sw/SuO/eSNUumKVuxsQHJsadqjkQznWBrojzdlSrLse3/oeuM0AXA9aAyR8+IazqH5EhohUz/7AsVo5Reg20YpaBE5J8g0H+gZa6wLPNUOs26Qw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxncwW50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxncwW50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4851F00893;
	Sun,  7 Jun 2026 10:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829642;
	bh=dqNbRRzcn+6GlIA54b6TbmCpE/0PDagc7Y4K6CRTnEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxncwW503aH7TPc80wHT23IVDaYTQhkTRT9xW6mg/UsPRdx1bVm3pLtSdenOTzAQw
	 xhkIGD8U4dvM7CLpeudIIDZdeQg4ueGZpalIqIUJuTiI/MR4wcHmyLay1zg/NMLUMb
	 hhLd4mTMPJ/7Y9MiQUwkZ2ouVmxSDXumljnymb9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 267/315] drm/amdkfd: fix NULL pointer bug in svm_range_set_attr
Date: Sun,  7 Jun 2026 12:00:54 +0200
Message-ID: <20260607095737.376802257@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

commit e984d61d92e702096058f0f828f4b2b8563b88ce upstream.

The process_info could be NULL if user doesn't call kfd_ioctl_acquire_vm
before calling kfd_ioctl_svm.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 83a26c812e0529eb040d31a76f73e33e637243d4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3680,6 +3680,9 @@ svm_range_set_attr(struct kfd_process *p
 
 	svms = &p->svms;
 
+	if (!process_info)
+		return -EINVAL;
+
 	mutex_lock(&process_info->lock);
 
 	svm_range_list_lock_and_flush_work(svms, mm);


