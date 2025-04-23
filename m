Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045C628CF52;
	Wed, 23 Apr 2025 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421055; cv=none; b=klbb6Gl1GTm/bzIFGCQCSUhp6llmePGOnnYQucB7/Ykr/nFtjGouq4L8ZdKJeD1PedXHsvniTHAeq6CAuC/NJ4wXkjLJCyiDjxRVnWPyDBr2bVZVoj8dtESvLG+VljMAz68vpnRZPoiE5vMpAbDCckVH6aF7TdtPrcOJVq0ozQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421055; c=relaxed/simple;
	bh=x0DsJjQNNVxmKHlqxAHvoFODrigvJXc75dAsGvJD8iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYDgFbX3QiI/ZrETAioHJCY1NmhfZaBaM/SyZrIGdNutzB5haZ9e1K0ryFOrOhradjfYgTd236xxhWW6oBBFCH7QGQfd4WQVNAcocIv1GFSxD30WsKOcz04oYz3NX6ZbrS6Q0m2Pza8dL0cRMujfAy/KVsJ7beIZsfmobKUzfHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5T3lpuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5T3lpuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CD0C4CEE2;
	Wed, 23 Apr 2025 15:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421054;
	bh=x0DsJjQNNVxmKHlqxAHvoFODrigvJXc75dAsGvJD8iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5T3lpuoUF+XgZ2RvPXsFhmj6IQ7lNIsjQfBsk4vLf5lJtqDO46cinXjPqOokKSIZ
	 ui54onebSvyHxqQLevYkoNzJ74hucve+4H1mYWN5kDdFbvtn4npF3LnJ4geuRfFR98
	 ygzaBpMNv0W9uo654bm5z0FhjjzJHcKFpYKdPDQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karina Yankevich <k.yankevich@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 139/393] media: v4l2-dv-timings: prevent possible overflow in v4l2_detect_gtf()
Date: Wed, 23 Apr 2025 16:40:35 +0200
Message-ID: <20250423142649.116416273@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Karina Yankevich <k.yankevich@omp.ru>

commit 3edd1fc48d2c045e8259561797c89fe78f01717e upstream.

In v4l2_detect_gtf(), it seems safer to cast the 32-bit image_width
variable to the 64-bit type u64 before multiplying to avoid
a possible overflow. The resulting object code even seems to
look better, at least on x86_64.

Found by Linux Verification Center (linuxtesting.org) with Svace.

[Sergey: rewrote the patch subject/descripition]

Fixes: c9bc9f50753d ("[media] v4l2-dv-timings: fix overflow in gtf timings calculation")
Cc: stable@vger.kernel.org
Signed-off-by: Karina Yankevich <k.yankevich@omp.ru>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -764,7 +764,7 @@ bool v4l2_detect_gtf(unsigned int frame_
 		u64 num;
 		u32 den;
 
-		num = ((image_width * GTF_D_C_PRIME * (u64)hfreq) -
+		num = (((u64)image_width * GTF_D_C_PRIME * hfreq) -
 		      ((u64)image_width * GTF_D_M_PRIME * 1000));
 		den = (hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) *
 		      (2 * GTF_CELL_GRAN);
@@ -774,7 +774,7 @@ bool v4l2_detect_gtf(unsigned int frame_
 		u64 num;
 		u32 den;
 
-		num = ((image_width * GTF_S_C_PRIME * (u64)hfreq) -
+		num = (((u64)image_width * GTF_S_C_PRIME * hfreq) -
 		      ((u64)image_width * GTF_S_M_PRIME * 1000));
 		den = (hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) *
 		      (2 * GTF_CELL_GRAN);


