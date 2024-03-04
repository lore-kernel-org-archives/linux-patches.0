Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5122A8F58;
	Mon,  4 Mar 2024 21:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588379; cv=none; b=czI4QLYAqce2RDva0CDwRyoTh24+j5WjJ3zT2nWmsEi4CvETeq1THb1hzE3a7PtFy+Y0S3n5RTkMtsmEu71tM3eYuInimA9JUUwpnWUZ2l+pTcBt4RXvKwPmRFbXM4jMkinMsZpeBHPSCaBoaXWsrkhDmeUoMDDYYWxNmsn7tPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588379; c=relaxed/simple;
	bh=80+EAIP1ApPNRqKOIoD27biYf79DwkmzP1zJ+Ngl/IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mRetT7LxjRosjO56jJMPCmc9cG0OWL0IVBN3PUzFBsY/Q6u1pMwRyB1XlUpF2E4HmCgK7nC/QQNk5B++G90qAhXpV9a8gu7qB+AcCbRsPwMTxfFb/KeTQD1R5FVb8LdR26arz1nnlsZ+VDyZQoe8nYS+TcEawze7Kn3+9Ez4uwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrpcyXfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrpcyXfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE82C433F1;
	Mon,  4 Mar 2024 21:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588379;
	bh=80+EAIP1ApPNRqKOIoD27biYf79DwkmzP1zJ+Ngl/IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrpcyXfvQ97u31Cgy52CLa6RrUal6Puw9bwEnC/TkfmmjMRcFPkSkyGzyZglJJFWF
	 7i6Mf+pOQTYwlz/IQ5yqKctf5Jj3KfhDQHsE/7zvKziRIorF2dvK13A8JBTGVriTcb
	 ScGxgwsThmxWfDihgmiKLF7IdWvgjpCOP+LYxzzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.6 085/143] drm/buddy: fix range bias
Date: Mon,  4 Mar 2024 21:23:25 +0000
Message-ID: <20240304211552.642308346@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit f41900e4a6ef019d64a70394b0e0c3bd048d4ec8 upstream.

There is a corner case here where start/end is after/before the block
range we are currently checking. If so we need to be sure that splitting
the block will eventually give use the block size we need. To do that we
should adjust the block range to account for the start/end, and only
continue with the split if the size/alignment will fit the requested
size. Not doing so can result in leaving split blocks unmerged when it
eventually fails.

Fixes: afea229fe102 ("drm: improve drm_buddy_alloc function")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org> # v5.18+
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240219121851.25774-4-matthew.auld@intel.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_buddy.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -332,6 +332,7 @@ alloc_range_bias(struct drm_buddy *mm,
 		 u64 start, u64 end,
 		 unsigned int order)
 {
+	u64 req_size = mm->chunk_size << order;
 	struct drm_buddy_block *block;
 	struct drm_buddy_block *buddy;
 	LIST_HEAD(dfs);
@@ -367,6 +368,15 @@ alloc_range_bias(struct drm_buddy *mm,
 		if (drm_buddy_block_is_allocated(block))
 			continue;
 
+		if (block_start < start || block_end > end) {
+			u64 adjusted_start = max(block_start, start);
+			u64 adjusted_end = min(block_end, end);
+
+			if (round_down(adjusted_end + 1, req_size) <=
+			    round_up(adjusted_start, req_size))
+				continue;
+		}
+
 		if (contains(start, end, block_start, block_end) &&
 		    order == drm_buddy_block_order(block)) {
 			/*


