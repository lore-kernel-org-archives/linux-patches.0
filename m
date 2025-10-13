Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0915F30E85B;
	Mon, 13 Oct 2025 15:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369663; cv=none; b=oHC4cZCHiyrB5raf+yiX/7e2srlAfN/JW77fU6kjHhAexZYcrlWpkdbTIHgHZ3pBPChU/64MMzxMD/iv11SkuDWB/akjsVRZhJN5/20Z44q03Ltqy8kb7cpzG+190mbaSchVSsWXpNxwdYDyju62qb6vJCALREYZ1ituNEnYzrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369663; c=relaxed/simple;
	bh=o9eDurtjHrCzx0YkQ9cndzQqYhYf0yLouX9BUMzpSaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRaK9BAiDNTBtTfqn+YKDIYj9WG3MK955Cqw1E9w/lnS1Vn6rwuf56pm/+TvIjfc8xE0fxWuMc9f7HMWbyQVGc/JQe3WyCN1ju6ezTMalYWB9BSDrT+HJygF2Z9TCg7y521eYwQewGHYNH/wrJJaTVzD+BsRnZ7FOkDjKzp10vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BB1aRHzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BB1aRHzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD62C19424;
	Mon, 13 Oct 2025 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369662;
	bh=o9eDurtjHrCzx0YkQ9cndzQqYhYf0yLouX9BUMzpSaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BB1aRHzuemii2nGKZUf5zkb6/ktMS5ISrllMDup08p8Uxf6Zfh3ZM9sC+TrMQd0Vx
	 /4yeBW99WrCEJgkCLb9AIY9KfLjbYObSN+vteX0WKyGbVyzBVBWOajKEzXWBm5vvgO
	 0IQRfROv6/IRKVmQMvHfHtKiLEbSsUh3eGv0gMjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 325/563] drm/msm: Fix missing VM_BIND offset/range validation
Date: Mon, 13 Oct 2025 16:43:06 +0200
Message-ID: <20251013144423.035908700@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit 3a3bef68a6c15d079646a964ebc4dc8bb0aedb06 ]

We need to reject the MAP op if offset+range is larger than the BO size.

Reported-by: Connor Abbott <cwabbott0@gmail.com>
Fixes: 2e6a8a1fe2b2 ("drm/msm: Add VM_BIND ioctl")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Tested-by: Connor Abbott <cwabbott0@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/669781/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_vma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gem_vma.c b/drivers/gpu/drm/msm/msm_gem_vma.c
index 209154be5efcc..381a0853c05ba 100644
--- a/drivers/gpu/drm/msm/msm_gem_vma.c
+++ b/drivers/gpu/drm/msm/msm_gem_vma.c
@@ -1080,6 +1080,12 @@ vm_bind_job_lookup_ops(struct msm_vm_bind_job *job, struct drm_msm_vm_bind *args
 
 		op->obj = obj;
 		cnt++;
+
+		if ((op->range + op->obj_offset) > obj->size) {
+			ret = UERR(EINVAL, dev, "invalid range: %016llx + %016llx > %016zx\n",
+				   op->range, op->obj_offset, obj->size);
+			goto out_unlock;
+		}
 	}
 
 	*nr_bos = cnt;
-- 
2.51.0



