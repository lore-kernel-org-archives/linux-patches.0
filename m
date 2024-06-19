Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81491422B8;
	Wed, 19 Jun 2024 13:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802869; cv=none; b=i0htSYYgZeTKmbElipQl/OeO+/yX+3451Uui1535rEi6C2ZQFNfQihdQO7s6WQc+Cm6HJhQ7u9viT/+ahCkmlUeJECXoBKyv47t1WbegnzmVHefpTF3ToR8Ny7jj0OLI/qRaJ2QL95aYv+oZxQDMHiCrLshx5qy9XPDePY9CKlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802869; c=relaxed/simple;
	bh=6UqHI/1G7nMtEWCLvaunXwbyKVgTM3pOdRVdUZr4PLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VoKabF7ALxE98XCZk5Z0ftrIgCkAfwvupoW5HQdvccmC/tGXbx3DEG7T1+0qoJOPHfzrwBlj+j5l9RkUqk4rcEi6JOQ76WymURNUGG8g8wQZfWXc1UX32A1AulAh1KVKSzj6Or7Tkk7HoybYXOdFwfsdUOYUqyAseAxUgq6BXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VU7AtiHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VU7AtiHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E17DC2BBFC;
	Wed, 19 Jun 2024 13:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802868;
	bh=6UqHI/1G7nMtEWCLvaunXwbyKVgTM3pOdRVdUZr4PLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VU7AtiHCC1EWpE4h2fDrvwzEmDUx/I+1ik479rk2Fz3gStSsBvF99iF0CWaYIDkJa
	 YJjugvCtAYkyaXyCP5O3kLYwxUnsxQxyIwZMNMeBrTzWnP3igC24jzgZAkaDNxj7ga
	 mhfKNErwig3ljZZKOi/2bzYmyKLyOthKTxCv2AQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 073/281] drm/xe: Use ordered WQ for G2H handler
Date: Wed, 19 Jun 2024 14:53:52 +0200
Message-ID: <20240619125612.651602452@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 2d9c72f676e6f79a021b74c6c1c88235e7d5b722 ]

System work queues are shared, use a dedicated work queue for G2H
processing to avoid G2H processing getting block behind system tasks.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240506034758.3697397-1-matthew.brost@intel.com
(cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 8bbfa45798e2e..6ac86936faaf9 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -146,6 +146,10 @@ int xe_guc_ct_init(struct xe_guc_ct *ct)
 
 	xe_assert(xe, !(guc_ct_size() % PAGE_SIZE));
 
+	ct->g2h_wq = alloc_ordered_workqueue("xe-g2h-wq", 0);
+	if (!ct->g2h_wq)
+		return -ENOMEM;
+
 	ct->g2h_wq = alloc_ordered_workqueue("xe-g2h-wq", 0);
 	if (!ct->g2h_wq)
 		return -ENOMEM;
-- 
2.43.0



