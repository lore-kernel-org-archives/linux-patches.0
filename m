Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3978A6AA0;
	Tue,  5 Dec 2023 03:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPif22Kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD953C433C7;
	Tue,  5 Dec 2023 03:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746497;
	bh=x017ePMRf+bKFJVOz2nFHV5d5FlHSvo6YegdAD4d6bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPif22KdTAIgNJA083/rc2JL5eTLHsIeZAH0CRjd47SgfAp1LMbxnsK9AHJJJC50p
	 1QInR2uy2A1wUxcC87eQmWgxDE5aeiHbVdbW9ZrBXCbrZrX54yZM+HuSqQ6Y6qrMuv
	 mh9cs5H54puw3MwsXMZR31F9D0NopoI1pgaEs1Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Danilo Krummrich <dakr@redhat.com>
Subject: [PATCH 6.6 045/134] nouveau: find the smallest page allocation to cover a buffer alloc.
Date: Tue,  5 Dec 2023 12:15:17 +0900
Message-ID: <20231205031538.416091213@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dave Airlie <airlied@redhat.com>

commit e9ba37d9f9a6872b069dd893bd86a7d77ba8c153 upstream.

With the new uapi we don't have the comp flags on the allocation,
so we shouldn't be using the first size that works, we should be
iterating until we get the correct one.

This reduces allocations from 2MB to 64k in lots of places.

Fixes dEQP-VK.memory.allocation.basic.size_8KiB.forward.count_4000
on my ampere/gsp system.

Cc: stable@vger.kernel.org # v6.6
Signed-off-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230811031520.248341-1-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 0f3bd187ede6..280d1d9a559b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -318,8 +318,9 @@ nouveau_bo_alloc(struct nouveau_cli *cli, u64 *size, int *align, u32 domain,
 			    (!vmm->page[i].host || vmm->page[i].shift > PAGE_SHIFT))
 				continue;
 
-			if (pi < 0)
-				pi = i;
+			/* pick the last one as it will be smallest. */
+			pi = i;
+
 			/* Stop once the buffer is larger than the current page size. */
 			if (*size >= 1ULL << vmm->page[i].shift)
 				break;
-- 
2.43.0



