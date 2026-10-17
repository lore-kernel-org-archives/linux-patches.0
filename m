Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955FB3803DC;
	Sat, 17 Oct 2026 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257567; cv=none; b=k7Ig5VnGDdnjXZpV3YtyDbdMcNb8eEnEFedYfjdsPzGXhq3yrTzLHhA43ThfIkbYHc7gzAvddA7bLo/w/dzIa9S+cyy6CY15DtdT5/VqyWapeu2h2Qb8oUVMprJ2U9h0YIlOqPydNZbGny5C+RPb+pXoN5WPxn7fp/TRBzliW1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257567; c=relaxed/simple;
	bh=g+O9hMZvKNTrFD04uen1jBHMJVSVDaBKVVx5IT13IW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayGK1NgVx3G23wDVgsj7LhhxtkByvomNL/I8jZk5bkl1YykvaUh4gUBmYSggQye29RmONLa9uWyqKWQx+AeBRRU1xIxMRSYmngn3Fvw4gtwMDVI1Yz3SLYeMDFiaYPG/NcbHhKZqxebCAN6/6o5DgBZjUIJWNPqskDsGRXLQuPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ol6/SAXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ol6/SAXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FC71F000C4;
	Sat, 17 Oct 2026 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257566;
	bh=HutFpUu5Jq6PH8IAo4D/J8U/IMT/mpS23m5igGBZHF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ol6/SAXNOjdfceJJ2FYfBQE7sXiHJEGObvAQSC7JaytXdZ65X2pU+DPgUTHAKd97f
	 ZFFM0+IN1eUPJ8++/F+V72DIw9eAaPwigq372mAs6tQKF+FB0dcNPKlch/fA7LWjw7
	 5+cVx1VN08vhjGS+9oZzVor/VhIEtSPs91YeiC18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Dinaburg <artem@trailofbits.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0599/1674] wifi: ath12k: copy M3 firmware when reusing the buffer
Date: Sat, 17 Oct 2026 17:47:51 +0200
Message-ID: <20261017160446.458293819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Dinaburg <artem@trailofbits.com>

This fixes my 6.6.y backport of upstream commit 05090ae82f44 ("wifi:
ath12k: check M3 buffer size as well whey trying to reuse it"). There is
no corresponding upstream commit, because upstream never had this bug.

When the existing M3 buffer is large enough for the new m3.bin, my
backport releases the firmware and returns early. The new image is never
copied, and m3_mem->size keeps the old length. Upstream instead jumps to
skip_m3_alloc, which copies the current image into the existing buffer
and records its length. As a result, after recovery or resume, 6.6.y
gives the firmware the previous M3 image whenever the new one is the
same size or smaller. A larger image is reallocated and loaded.

Replace the early return with the upstream goto skip_m3_alloc. The
previous patch, a backport of upstream commit 00575bb44b2c ("wifi:
ath12k: fix reusing m3 memory"), keeps the allocation size in
total_size. So copying a smaller image no longer changes the size passed
to dma_free_coherent().

Fixes: 9a38ba5561d9 ("wifi: ath12k: check M3 buffer size as well whey trying to reuse it")
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 86cc61dba0946..8dc1c8e0c7b16 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2543,10 +2543,8 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 
 	/* In recovery/resume cases, M3 buffer is not freed, try to reuse that */
 	if (m3_mem->vaddr) {
-		if (m3_mem->total_size >= fw->size) {
-			release_firmware(fw);
-			return 0;
-		}
+		if (m3_mem->total_size >= fw->size)
+			goto skip_m3_alloc;
 
 		/* Old buffer is too small, free and reallocate */
 		ath12k_qmi_m3_free(ab);
@@ -2564,6 +2562,7 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 
 	m3_mem->total_size = fw->size;
 
+skip_m3_alloc:
 	memcpy(m3_mem->vaddr, fw->data, fw->size);
 	m3_mem->size = fw->size;
 	release_firmware(fw);
-- 
2.53.0



