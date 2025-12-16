Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2521F35F8D4;
	Tue, 16 Dec 2025 12:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887344; cv=none; b=st5j/sH2dpAVkCZbIZYLwLodsLYaqRkXmcPrr916helHo5+AsRzJpOLbnW92NUNKkdjfW9wqLvLfbGEjwTiZN6wnlFrNBL8UEZfNjUhEWEs098Emj99ftVlVJ/BXRD6M7Mbz4KPnNMjB3SieV4NqpNWsYwqnDWrxh83Yk4ET7hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887344; c=relaxed/simple;
	bh=ogPPyU9qZrWfV9sKIJXlYzYTi5S0nXkdrNXZYaSHH94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VvBnyfKHyipoLQ1gS2nktjTasToQCGYzheVB25AekqGT0g9yQ9r97geJjHemV7+CKVkWfaoZjNGtUKiAO+N+/zszO905QtgDO0BTufLdvhGaqmkhcDskHBaDljSrqCEzijFgzNaW8uX/wowTbp0yaJ0WQT13/Uk3h0XdKeb+h0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iUo2ase; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iUo2ase"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED6DC4CEF1;
	Tue, 16 Dec 2025 12:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887343;
	bh=ogPPyU9qZrWfV9sKIJXlYzYTi5S0nXkdrNXZYaSHH94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iUo2asepqdown2SOLvWdN+bs9YL0bUZ69Sqc5X5vQjh6Pef+3cNX6CB/HnRaBWuB
	 QKTC1vV1aR2tGzkPsN++rRmTizCQxYDit1X7niglJqmi87NvF6inqYW44kkppStU0R
	 G78Bm58gLituKJOKYfDghhxBaNaJQN4kMrj5wmmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 200/614] drm/xe: Enforce correct user fence signaling order using
Date: Tue, 16 Dec 2025 12:09:27 +0100
Message-ID: <20251216111408.624748288@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit adda4e855ab6409a3edaa585293f1f2069ab7299 ]

Prevent application hangs caused by out-of-order fence signaling when
user fences are attached. Use drm_syncobj (via dma-fence-chain) to
guarantee that each user fence signals in order, regardless of the
signaling order of the attached fences. Ensure user fence writebacks to
user space occur in the correct sequence.

v7:
 - Skip drm_syncbj create of error (CI)

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20251031234050.3043507-2-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index cb5f204c08ed6..a6efe4e8ab556 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -344,6 +344,9 @@ void xe_exec_queue_destroy(struct kref *ref)
 	struct xe_exec_queue *q = container_of(ref, struct xe_exec_queue, refcount);
 	struct xe_exec_queue *eq, *next;
 
+	if (q->ufence_syncobj)
+		drm_syncobj_put(q->ufence_syncobj);
+
 	if (q->ufence_syncobj)
 		drm_syncobj_put(q->ufence_syncobj);
 
-- 
2.51.0



