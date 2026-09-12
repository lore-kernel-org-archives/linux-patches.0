Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71DE35AC1E;
	Sat, 12 Sep 2026 08:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200244; cv=none; b=U9sIOQ63nsbqK70DLyavUTFjsZuZuDgOrXp3mTle8hSG3x3ji3/5DN/1tfPTqFM7YAbKC8goecAMnDccC9df9uxWeegO1xT6D37hZY2juF1QYB20wIV+r4qln4j5a4nEtQfZlce6rg+3ev46RROF0L8apsNw9cRuymhHv4aUnN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200244; c=relaxed/simple;
	bh=W8Gx5VSo3GwFBZ9Lig3kKxjsNhoT/nQt8/ZAttb+fJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbehCozJ7jGummP5wZdMky9QelF9hiKg2CtkBgYSNG0JXUAR9cbTWayiNozAO2E8ExDNVWXNtC0owTIyXy74WHJS3l2Bmo8YUhvLAjzjn4W7TFXS8iqGZJPYpKizWthLJ55+svKKS9PW46vKFdRzBcO6KaZJvgW/k30TpWb8K8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8UicbHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8UicbHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9491F000FF;
	Sat, 12 Sep 2026 08:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200243;
	bh=HmUI1xkk2U2mfTq9EfrARCvNm0xqZyxPtIQcO7nfVrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8UicbHZqZXRCLF3Rjdjh7zgpLxngNVTa+BzmNqMfCYmyoTs9T/B5OGiaRCvCYq8B
	 8LY+fmEnuGApeTDi6TldhYXVEDyq19STomgYovpqF7qGgwy/lK1f6NRBsWzfsdzRf3
	 LQ3dHyOsFyeYlM3npQkbhxE1Ut5Cit+IqHrIcbeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0750/1815] drm/msm: remove objects from evit list after pinning them
Date: Sat, 12 Sep 2026 08:41:40 +0200
Message-ID: <20260912065706.512915739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Maniscalco <anna.maniscalco2000@gmail.com>

[ Upstream commit 83723f32cb3de23d45c1ac09241b5e0cfb32cc9b ]

Once objects are pinned they should not be kept in the evict list as
that will cause drm_gpuvm_validate to keep ieterating a growing list of
objects needlessly.

Once an object is pinned remove it from the list.

Fixes: 2e6a8a1fe2b2 ("drm/msm: Add VM_BIND ioctl")
Signed-off-by: Anna Maniscalco <anna.maniscalco2000@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/742166/
Message-ID: <20260723-evict_list_fix-v2-1-bd0725e56253@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_vma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gem_vma.c b/drivers/gpu/drm/msm/msm_gem_vma.c
index c4cfe036066b7..7441d4a01d31d 100644
--- a/drivers/gpu/drm/msm/msm_gem_vma.c
+++ b/drivers/gpu/drm/msm/msm_gem_vma.c
@@ -458,6 +458,8 @@ msm_gem_vm_bo_validate(struct drm_gpuvm_bo *vm_bo, struct drm_exec *exec)
 			return ret;
 	}
 
+	drm_gpuvm_bo_evict(vm_bo, false);
+
 	return 0;
 }
 
-- 
2.53.0



