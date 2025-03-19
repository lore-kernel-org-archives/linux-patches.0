Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574331DE8AB;
	Wed, 19 Mar 2025 14:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394977; cv=none; b=rogEcwURN+SoyHmpHBeNocNk/JMHGK3baNkYw+bOmk4zcDC9slvQQnlOomvKVzj9f+IKlbKtijKkXEoEzPt10Oa99O6WPZWRIM7SWrVLh28HY+69JKvKREUA/chQ5YJMSiXuD49b/1p3vfgBo7YWE64u5fjK1pFjoh+olB8Z6jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394977; c=relaxed/simple;
	bh=yFndqrjTd938M2Q4qXsaa96fACsnZ3vAOoy+Jst0sms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lfiDORxrCSlXXcHYcKDXpjg+rgjX4baFVb00qLDHAUhWUAa4+hXxWtPhgTdE9N8JvrIV7+eRya+AidwjjOCH3Am63ewX4k+N9HeyvlpVVrcxgd94S4fTnpxP1sPs4/+jsgGvNAelEo1P4H2TLYbxIi/kUF4fGYGR1QeldIiPsQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eISHw9K4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eISHw9K4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7CBC4CEE4;
	Wed, 19 Mar 2025 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394977;
	bh=yFndqrjTd938M2Q4qXsaa96fACsnZ3vAOoy+Jst0sms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eISHw9K4bCR5hH7eGdl0UeDA+5G2lsbHLlI9Td1QcRbWaRXLbKJnx/Vxz7nJy4czW
	 ZsfbEcrdueUDanATbLRkZsrVD2y7J0H4raInCVPoALcQuPxTd1AIalDXScBmC3Q6na
	 PLcm35GAcvKQNF2y/ZCRgm9UCERx0jbevAnXZzbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 214/241] drm/xe/userptr: Fix an incorrect assert
Date: Wed, 19 Mar 2025 07:31:24 -0700
Message-ID: <20250319143033.045632066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit 9106713bd2ab0cacd380cda0d3f0219f2e488086 ]

The assert incorrectly checks the total length processed which
can in fact be greater than the number of pages. Fix.

Fixes: 0a98219bcc96 ("drm/xe/hmm: Don't dereference struct page pointers without notifier lock")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250307100109.21397-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit 70e5043ba85eae199b232e39921abd706b5c1fa4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hmm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_hmm.c b/drivers/gpu/drm/xe/xe_hmm.c
index d7a9408b3a97c..f6bc4f29d7538 100644
--- a/drivers/gpu/drm/xe/xe_hmm.c
+++ b/drivers/gpu/drm/xe/xe_hmm.c
@@ -138,13 +138,17 @@ static int xe_build_sg(struct xe_device *xe, struct hmm_range *range,
 		i += size;
 
 		if (unlikely(j == st->nents - 1)) {
+			xe_assert(xe, i >= npages);
 			if (i > npages)
 				size -= (i - npages);
+
 			sg_mark_end(sgl);
+		} else {
+			xe_assert(xe, i < npages);
 		}
+
 		sg_set_page(sgl, page, size << PAGE_SHIFT, 0);
 	}
-	xe_assert(xe, i == npages);
 
 	return dma_map_sgtable(dev, st, write ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE,
 			       DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
-- 
2.39.5



