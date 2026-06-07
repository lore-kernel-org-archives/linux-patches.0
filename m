Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A127433372A;
	Sun,  7 Jun 2026 10:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829800; cv=none; b=bkqtjxpKYjX5Q02IX0WtnUHSFgJ/hEtLiyEmcf9pfTKz++i/wMXoblpre8qqOmuuUew5DunqG71zJkLW1uvCMxx5gkuyLLKq85Mc083zOYpsMtXLtDoTTKrCzTa7brNoUc7Qn1BVDXHFPrf+HjRR98nWQ/vypsOD2YVAYhLT2bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829800; c=relaxed/simple;
	bh=16iL4hKQ8WirjK9BYKbWrW6nBwJ59QtlnI29tacsdMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlRYkKPzZ9gFhQg5Do7IR57+SrDlK8PIan3fzfNHk9miuUZIZuWXTpOP2h7u8WOxIHN4DOYPqYwkWI2MzvhpNlyEhm6y4wqkS29C+Tft3c7Lofyg7NLNPMnDlha4b0LlhftlFSZqFb1kn9M2QaaqJzei0YMeam7rfBKJMS1cqDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wB36/WNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wB36/WNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734421F00893;
	Sun,  7 Jun 2026 10:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829797;
	bh=Z5Z6PWR6qyixSQFlBjAQyxBQnA9rbbQ6+oQJHWMy4jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wB36/WNVdHqQaRcKDsKT1oLxYq4i8ZX5jqXZ2AstNu/z+TK93qSEGmtFNRMs6thXM
	 ioGSGzxRz3DYV9gfwLOdL5XugodiAXxwCBIxsS8LlFSaAspfwVo1O+fpKgcvWo3tQk
	 8hx9NewZ/oyngUGV5RRT7rXI81MZHYgrrG3Qi1RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 254/307] drm/amdkfd: fix a vulnerability of integer overflow in kfd debugger
Date: Sun,  7 Jun 2026 12:00:51 +0200
Message-ID: <20260607095737.017968802@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Huang <jinhuieric.huang@amd.com>

commit 93f5534b35a05ef8a0109c1eefa800062fee810a upstream.

get_queue_ids() computes array_size = num_queues * sizeof(uint32_t),
which could overflow on 32-bit size_t build. using array_size()
instead, it saturates to SIZE_MAX on overflow.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2d57a0475f085c08b49312dfd8edcb461845f285)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -3194,12 +3194,14 @@ static void copy_context_work_handler (s
 
 static uint32_t *get_queue_ids(uint32_t num_queues, uint32_t *usr_queue_id_array)
 {
-	size_t array_size = num_queues * sizeof(uint32_t);
-
 	if (!usr_queue_id_array)
 		return NULL;
 
-	return memdup_user(usr_queue_id_array, array_size);
+	if (num_queues > KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
+		return ERR_PTR(-EINVAL);
+
+	return memdup_user(usr_queue_id_array,
+			   array_size(num_queues, sizeof(uint32_t)));
 }
 
 int resume_queues(struct kfd_process *p,


