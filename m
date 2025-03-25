Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2229E26B956;
	Tue, 25 Mar 2025 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906292; cv=none; b=g4b/GyRdVh8tSFpW7uyvIdeqvCqDibjctYfSupqIv3plLm0mO3pzx3wBfsLrvMuYYnMk/gOtJ0/nYOvEKJ45Vvb6p7gdfM6hVENUqBcmxf/m6M19EUrchqklkwS0h10LjXboe0AWfd7lLV7mWMhZiOjw4wTpAPhRx4er1UIt7Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906292; c=relaxed/simple;
	bh=VQ4Kdy5qKaPKnxXcm5GwthaGs8mWiOZ+87K/584/9Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCrme4qW2YHeloBWlNpj62ZugjO0x+O0IRzwSI9bsrGMSTvw5Nsm0+JuwbUETul8Nh5x+4wQ6Z+CVoU2rdGGAqID2vJEpCoSOmbZOlwjAWrpB/eAwnsH9514QYR+KM/h1Y1SyJMDRCj29GhO6zXgifJcq5jBX+lNRlyUnrumElk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Onv9jN+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Onv9jN+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CB8C4CEE4;
	Tue, 25 Mar 2025 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906292;
	bh=VQ4Kdy5qKaPKnxXcm5GwthaGs8mWiOZ+87K/584/9Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Onv9jN+4zG7aqWtxWaqWAtbclxf01kqA5cbXtrnXhE0ctr1S5yf+T8K/ayz+tHkrL
	 9UcY0cxrv3bxNsybPsUdwj6NW6U5anrW26xaaZWYOZTrh/lekO4oo1e6XCh9NKIWbN
	 mYPrzdFt8NpofMyckay3dgIZef6/ZKcCkGHzU8iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Troy Hanson <quic_thanson@quicinc.com>,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/116] accel/qaic: Fix possible data corruption in BOs > 2G
Date: Tue, 25 Mar 2025 08:21:59 -0400
Message-ID: <20250325122150.033758259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffrey Hugo <quic_jhugo@quicinc.com>

[ Upstream commit 84a833d90635e4b846333e2df0ae72f9cbecac39 ]

When slicing a BO, we need to iterate through the BO's sgt to find the
right pieces to construct the slice. Some of the data types chosen for
this process are incorrectly too small, and can overflow. This can
result in the incorrect slice construction, which can lead to data
corruption in workload execution.

The device can only handle 32-bit sized transfers, and the scatterlist
struct only supports 32-bit buffer sizes, so our upper limit for an
individual transfer is an unsigned int. Using an int is incorrect due to
the reservation of the sign bit. Upgrade the length of a scatterlist
entry and the offsets into a scatterlist entry to unsigned int for a
correct representation.

While each transfer may be limited to 32-bits, the overall BO may exceed
that size. For counting the total length of the BO, we need a type that
can represent the largest allocation possible on the system. That is the
definition of size_t, so use it.

Fixes: ff13be830333 ("accel/qaic: Add datapath")
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Troy Hanson <quic_thanson@quicinc.com>
Reviewed-by: Youssef Samir <quic_yabdulra@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250306171959.853466-1-jeff.hugo@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_data.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index c20eb63750f51..ffcdf5738d099 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -172,9 +172,10 @@ static void free_slice(struct kref *kref)
 static int clone_range_of_sgt_for_slice(struct qaic_device *qdev, struct sg_table **sgt_out,
 					struct sg_table *sgt_in, u64 size, u64 offset)
 {
-	int total_len, len, nents, offf = 0, offl = 0;
 	struct scatterlist *sg, *sgn, *sgf, *sgl;
+	unsigned int len, nents, offf, offl;
 	struct sg_table *sgt;
+	size_t total_len;
 	int ret, j;
 
 	/* find out number of relevant nents needed for this mem */
@@ -182,6 +183,8 @@ static int clone_range_of_sgt_for_slice(struct qaic_device *qdev, struct sg_tabl
 	sgf = NULL;
 	sgl = NULL;
 	nents = 0;
+	offf = 0;
+	offl = 0;
 
 	size = size ? size : PAGE_SIZE;
 	for_each_sgtable_dma_sg(sgt_in, sg, j) {
-- 
2.39.5



