Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039108;
	b=L6dEIavCOY1wS9/rvkuyVT+sCFACnChEtSWxduuD053hEF23Ggc6OVjd0maf6QE0WNaH
	 jYAxMfBCpImjriRn1z6b6pOaiAKQ60r1eLqo8uqQFq2XG1Oa+2P7c2q/wcmBJofix1b1t
	 XmvcN9HhEKHd0/VRGlBz4k3tzKxdth9sTUQvpK44mjmlLSDio6PL8ma1I+oW+9Sl3sIj5
	 ZXu4H89Izy8o9rNNehq/GUHQNGUNhz2Xl/uRR2atzpMeefubzbhxzr+1FnGhx8LOCSY5R
	 tT2itNZT/pWZ+fWdruxs/fySwSwdoZhgrgGfWwhYvprU8VJ7RcrVJ7ls2JDSgCo2Lhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WKhWRnHXWK48sbrF/En6zPefOt1GRcVCeWHjSjY88co=;
	b=tvuqrdwyxnDzNd80B9K+d3EqIDkJ3T5+zIKtvbJLwFXYTBypX/s6PO6zWi9/kcI17etA
	 gVgzZKNhkBLYnn18dHkXxldhy69LJ0dYRp/WIy3hthmpKtz0NnQCeWZec/jD6w+gLqgNK
	 +aqW6wqKQQsGtdCyUIg9J8CAXcmxxVkoPGkktn+kQmrXpA0BtLRR35HtsZKfpWS8CIMdO
	 i0EOf34Hwm0A9iX9Cvy6lspE4fsyFBw1AQBansRao0ZFXjGtEnrDsHcEPCoiGNfcKmdjM
	 VlyuIqLfhckOcdKymSM+selkwj7gIACNOL9TWqqQEGM2jquVGYngiNFlQOukI1fcRMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BxrniLA2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF65606A325;
	Wed, 18 Nov 2026 21:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BxrniLA2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEF21F000C5;
	Wed, 18 Nov 2026 21:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039108;
	bh=WKhWRnHXWK48sbrF/En6zPefOt1GRcVCeWHjSjY88co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxrniLA2dru9+/ksEMXG/kYJQFQbc1yvOPgyaRE4v4L/lYAoLS6IqDAJGh2SuAo9D
	 b9AMvy5svwWHhN1AOF7EZh1evQMsMtNmQjGWpVkrazhejUzTjAHDAyxIog06q5tpf6
	 JzgzfXYCWJKn9XmKa+hxSwNWy/7xKk6o9AbD0GTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1982/3318] accel/qaic: reject BO sizes that overflow page count
Date: Wed, 18 Nov 2026 15:43:24 +0100
Message-ID: <20261118150421.529682544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

[ Upstream commit 568d4cb5dcc5ec4e22975699b6ea67a30806884c ]

create_sgt() receives the BO size as a u64 but stores the number of
pages in an int. qaic_create_bo_ioctl() page-aligns the user-supplied
size without an upper bound, so DIV_ROUND_UP(size, PAGE_SIZE) can exceed
INT_MAX and truncate when assigned to nr_pages.

When the page count wraps to a small positive value (for example a BO
larger than 16 TiB on a 4 KiB page kernel), create_sgt() succeeds after
allocating only a handful of pages while the GEM object still records
the full size, so the request never fails with -ENOMEM. The temporary
pages array and the allocation loop both use the truncated count, so the
backing SG table ends up smaller than obj->size. Later slice operations
validate against obj->size and then clone ranges from this short sgt.

Compute the page count as a u64 and reject sizes that do not fit in
nr_pages before the narrowing conversion.

Fixes: ff13be830333 ("accel/qaic: Add datapath")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260708031959.966009-1-alvinhuang0603@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_data.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index 7beab1309e369..b29d5d509a6de 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -15,6 +15,7 @@
 #include <linux/math64.h>
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
+#include <linux/overflow.h>
 #include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
@@ -447,7 +448,12 @@ static int create_sgt(struct qaic_device *qdev, struct sg_table **sgt_out, u64 s
 	int order;
 
 	if (size) {
-		nr_pages = DIV_ROUND_UP(size, PAGE_SIZE);
+		u64 nr_pages_u64 = DIV_ROUND_UP_ULL(size, PAGE_SIZE);
+
+		if (overflows_type(nr_pages_u64, int))
+			return -E2BIG;
+
+		nr_pages = nr_pages_u64;
 		/*
 		 * calculate how much extra we are going to allocate, to remove
 		 * later
-- 
2.53.0



