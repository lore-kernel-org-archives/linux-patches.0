Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4DD4502F;
	Tue, 16 Jun 2026 17:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631333; cv=none; b=YX4THUX0loYtFdIZgXBGpvvEQD5GxJp9CYlzRMw+sMJJrD7vPtsNNYctcOD75k05fbKh8bLwLOAI4KUUQu5/U1gqIM3rbQ/QJz/YAvSce7YFKBY2a6qTFRqP5piMR0JH9yfjlIX7C/bnJHtHCOVX0gIk6Pt1i90Sxq8fBbk5ghw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631333; c=relaxed/simple;
	bh=L3l3k06sV5R8UaxPGC9PXa7TnsCdnwbhKitlMO/edfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcfdbsiISz1qRuGwfqXoDncl7HLWCbimiD4i0LhYuREfQJ57Mzq4YcJ7/BYFJLW5n1SRbi87OvuEI/jAlVmKpvRulfTdLj5gQR0s222lB4zdsn1I1Gz6j09bU/LvVPXp9bRJMPVS0rYaDXlj7EbrwEWLka3pgtEMqt3lv67kmzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFCVWke4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFCVWke4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2F01F000E9;
	Tue, 16 Jun 2026 17:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631332;
	bh=ocUwywtCwyaUFRanUW/0wD4MCI+2DW57wGmHkFN8Ko4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFCVWke4+wKakbm++i+jBeiaDCL/pttePT0TdISstS/i87MhrpYr1rruKvY+5kxhp
	 UUOh9dU4WGP2CgmLpHtkXsmxdwuGTs8tbyJ/seZ/AQ5OQJ9wrb0jMicsfm5jmu7uQS
	 1wuD9hcurwMMzpb/p00VIN2aGHH4KuiKI/wFBa0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 174/522] drm/amdkfd: fix NULL pointer bug in svm_range_set_attr
Date: Tue, 16 Jun 2026 20:25:21 +0530
Message-ID: <20260616145134.285780229@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3404,6 +3404,9 @@ svm_range_set_attr(struct kfd_process *p
 
 	svms = &p->svms;
 
+	if (!process_info)
+		return -EINVAL;
+
 	mutex_lock(&process_info->lock);
 
 	svm_range_list_lock_and_flush_work(svms, mm);


