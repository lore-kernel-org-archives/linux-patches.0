Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6FF3BFE5B;
	Tue, 16 Jun 2026 16:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629079; cv=none; b=n/VXeWD5Ctm1kOLMpgCzLbtc6CWA84lxb9nWUBPYgzUnrax0Mxtz+Z9rwoxoIyGvpYo2rKczEXWOi54gjG3w9hiMizqSgM/4WLxNXRPaTxknrlzd3W55Ii9kTTyQSfN1jVHn++Y7ozvqYxMA1SSLRyeYzRGhW7yWzSxnSrWzBxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629079; c=relaxed/simple;
	bh=rmZv1XFnjOQUU3lt85ahUnqtPKrz6xuD8kF1V0bTMYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ga3+RqyfzwCJSkYfzizM2smcjUxoUsHzqVDo+pUE+EjRhYKoOfBXHqn7tQxHXtTxIl6jM3dcNyKGSK571arXWPyM3Fe3rF/ex0fMowoJEmI5Q5xw3DEpSqzcbOns3XSjN1/iLM2Xls+0DbIDllSnF9fsOAXGtuMNn0d79dlx88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sQRUKSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sQRUKSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922A41F000E9;
	Tue, 16 Jun 2026 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629078;
	bh=xyaPCi9D8EIL1mMIRchaSmdSeQVfXLHAEUw7XRrsrkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sQRUKSCMgf/9khIyrOJpzC0rp4/aawkEdu7p7bx3AKGmXNfPwKxwBy2QSFwXXZ9Y
	 hKaKbzF2KoZ5/lwqCzbzBRBC6Ke4Z0RPZ5sZXSoxitnaIJJ4InyN8OBREwAmeDgyHi
	 SrzS3spuxQwdNYuIyx27Gn9tVOnZS2sTUhJdsJxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 185/452] drm/amdkfd: fix NULL pointer bug in svm_range_set_attr
Date: Tue, 16 Jun 2026 20:26:52 +0530
Message-ID: <20260616145127.552958949@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -3567,6 +3567,9 @@ svm_range_set_attr(struct kfd_process *p
 
 	svms = &p->svms;
 
+	if (!process_info)
+		return -EINVAL;
+
 	mutex_lock(&process_info->lock);
 
 	svm_range_list_lock_and_flush_work(svms, mm);


