Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB742A8D0;
	Mon, 24 Feb 2025 14:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409000; cv=none; b=Uz5iWMppHxXtzDKBSYIqGRjJBRrx2a9g11RxZRemHMPXgbMELdipsgBP8s/I0/mQFjLd/pglgCF+h7Z3X0fEZfFP4I4TPZhPV1IYfNL3bXJGvKwQI9X3CsMh4YM+gJXsyfrSBnc2rPYjUmzsKM3XJyu1SLK1Uu8nDvN58zKkKJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409000; c=relaxed/simple;
	bh=4aWHtNS5BA493WwavhnXoG1AZW7YLn2FzcG6tEEkpfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTdsxwZZKJIBVVewY6l0uylPhFM0sPAxkImeLLCu+7Bu1WAR0PtOSUrZlBETJmWmjluPzRm0+aMOU4gdaPqkUnMRUrQPKbARdalOK8UbbgWbggBBNaFYrFruQOfY+DAIl+TTjZzlr3KPer+1D2dMxsrMiIsysmZ3jzSgx6yjz7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KS/bSS3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KS/bSS3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DEDC4CED6;
	Mon, 24 Feb 2025 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408999;
	bh=4aWHtNS5BA493WwavhnXoG1AZW7YLn2FzcG6tEEkpfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KS/bSS3HCrq88zgjz2+JpLdRd8kLImmVPtwPsseeTsmQKDqRfKztuJ3ol2IoQyLp2
	 fnMFy2Dz3FSJbJDAFIf6ND62Sn4p67x+tlFCzW1yPPUDXZDFso7J4DM/clyRC8eHt6
	 yeBFbr09O8QRv+STMVq83Uqvx/TvtbUmJBotn0fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 068/138] nouveau/svm: fix missing folio unlock + put after make_device_exclusive_range()
Date: Mon, 24 Feb 2025 15:34:58 +0100
Message-ID: <20250224142607.147698976@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit b3fefbb30a1691533cb905006b69b2a474660744 ]

In case we have to retry the loop, we are missing to unlock+put the
folio. In that case, we will keep failing make_device_exclusive_range()
because we cannot grab the folio lock, and even return from the function
with the folio locked and referenced, effectively never succeeding the
make_device_exclusive_range().

While at it, convert the other unlock+put to use a folio as well.

This was found by code inspection.

Fixes: 8f187163eb89 ("nouveau/svm: implement atomic SVM access")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250124181524.3584236-2-david@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index b4da82ddbb6b2..8ea98f06d39af 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -590,6 +590,7 @@ static int nouveau_atomic_range_fault(struct nouveau_svmm *svmm,
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	struct mm_struct *mm = svmm->notifier.mm;
+	struct folio *folio;
 	struct page *page;
 	unsigned long start = args->p.addr;
 	unsigned long notifier_seq;
@@ -616,12 +617,16 @@ static int nouveau_atomic_range_fault(struct nouveau_svmm *svmm,
 			ret = -EINVAL;
 			goto out;
 		}
+		folio = page_folio(page);
 
 		mutex_lock(&svmm->mutex);
 		if (!mmu_interval_read_retry(&notifier->notifier,
 					     notifier_seq))
 			break;
 		mutex_unlock(&svmm->mutex);
+
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 
 	/* Map the page on the GPU. */
@@ -637,8 +642,8 @@ static int nouveau_atomic_range_fault(struct nouveau_svmm *svmm,
 	ret = nvif_object_ioctl(&svmm->vmm->vmm.object, args, size, NULL);
 	mutex_unlock(&svmm->mutex);
 
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 
 out:
 	mmu_interval_notifier_remove(&notifier->notifier);
-- 
2.39.5



