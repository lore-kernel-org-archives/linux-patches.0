Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2924204E;
	Sun,  7 Jun 2026 10:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829647; cv=none; b=LjwJJd2qmMvEM6tfcc+60xe40UfQLhgFma8Z69t3zo+/qWCN8uS7IlvyDfddqvU/0OlSGTn+gaDZdnWayZMTSjcXq/8lB+S1q8e0GcvEV942t1FLGnAUV5f6aw7Dn6j+sewjNEOhbeLIhY0KEH9SycQ8qwc131WOXmh/NAhpUC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829647; c=relaxed/simple;
	bh=kIqFeGJ6KiqyEKMmdb2Qjhx8klSQUemJKLfgJwKI0sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgoH5uKpEr0tFxi52JIkMhULpfZkled0P6o7WaBjCjYxppJrJfncRTO4ApO3Q+9260QGS2V2qveWM2Th2mcPuhiMkwxKNtAyqofyNR7A+ve5t8VdKICajoRLJGJBEA6tAUy/+bC8IgCj53hbursg9/gF9u1eIg83JgscJjxdXXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMyBxGcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMyBxGcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973051F00893;
	Sun,  7 Jun 2026 10:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829646;
	bh=0SFZLCzptxjtGx981jIs9nElWvMdpz4OwszSSXl2b00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMyBxGcH1RgIohcfPXSPjesnSgxVHguOn0JfIGhao//4xk8bOBs8ZfwO4CNq8Qa5d
	 dHk7TyVWjooDumDvsE8s+FyBvE5DxxZp+zvDmV/Jrm37Oz0ZdyS0KA/trm5fi7uwVa
	 q7+wZ09YvY4PiWbSZS9OSKPdHrGD42v37dx+kJ0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 302/332] drm/amdkfd: fix NULL pointer bug in svm_range_set_attr
Date: Sun,  7 Jun 2026 12:01:11 +0200
Message-ID: <20260607095739.153683606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3718,6 +3718,9 @@ svm_range_set_attr(struct kfd_process *p
 
 	svms = &p->svms;
 
+	if (!process_info)
+		return -EINVAL;
+
 	mutex_lock(&process_info->lock);
 
 	svm_range_list_lock_and_flush_work(svms, mm);


