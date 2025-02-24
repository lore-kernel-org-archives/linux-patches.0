Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DD22571CE;
	Mon, 24 Feb 2025 14:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408219; cv=none; b=cLor4Yl4ipF5mdM+WQdqjSmjckr2aHGN9SZR52Sxug7JCf1URNHXRUFo5lXu2nE8Dy/jl+BNyJ7VVUxkTT/bIUdtQl/ovxIHhEgyCbW0Ndv7aYYvvkZibeG10De2E9IOqZkt2q4/YWOZH+zXNj857IfjJsbPkaWf/WcsCdQT8us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408219; c=relaxed/simple;
	bh=quIso30uEu751dSf6BT0uaSmiHuTt0F8BOU7hULC62s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im5JGx4Hb/Yh7OPid11kJL95BFdiL/Jl2qQc6BW5OAlvAJBBrg587p3oNwMaJt4FXghgRlB46psinLB0jNqL+zJz12bgTkWGvwrbq1LllnVwF+chzmMseWYqLWfRySv/lcaFkopaY6ILQ5Ndb4ZSe90Qf94+fhk5mSSXt3q2a2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDahTI2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDahTI2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12856C4CED6;
	Mon, 24 Feb 2025 14:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408219;
	bh=quIso30uEu751dSf6BT0uaSmiHuTt0F8BOU7hULC62s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDahTI2inufaKBpjknGHNnpz4W1o/G0zR1hQZ4Ri3pnBHq+2YTqJ3bySunhRtnKx+
	 e7ispAc5AH0vFCf2DQYTB3wp1wRQYfSjCUu0/csZ2FRPeNQntI2zr9Z7kyYk948T14
	 UIaSpbzNvdjSMLdUUgfnYOzJaOrgUSbYrfM84g9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/140] nouveau/svm: fix missing folio unlock + put after make_device_exclusive_range()
Date: Mon, 24 Feb 2025 15:35:01 +0100
Message-ID: <20250224142607.024258081@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ec9f307370fa8..6c71f6738ca51 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -593,6 +593,7 @@ static int nouveau_atomic_range_fault(struct nouveau_svmm *svmm,
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	struct mm_struct *mm = svmm->notifier.mm;
+	struct folio *folio;
 	struct page *page;
 	unsigned long start = args->p.addr;
 	unsigned long notifier_seq;
@@ -619,12 +620,16 @@ static int nouveau_atomic_range_fault(struct nouveau_svmm *svmm,
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
@@ -640,8 +645,8 @@ static int nouveau_atomic_range_fault(struct nouveau_svmm *svmm,
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



