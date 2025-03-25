Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A8E55B;
	Tue, 25 Mar 2025 12:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905911; cv=none; b=lapCnslHDp2eC5KGiHkCo07qsQiVGCQEDnd5AS0EFTwnC66GbyvVts8pIPwSmXC4D/bskksLymrIOJ8PrW14hPY5OCl+W/q2FF6UGDrSdtS8sdQ/M4GQJPvO5ND6LKBbzgZcsm2ZVPu+I5M6pdK5jlZO8OtZTRGbGmScJaVLc8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905911; c=relaxed/simple;
	bh=sDQjGI/FQbDeliczrsHg2jfwVKEciWjka/Op3pkSH/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDwVMl73+uLGIDXNdgPPV1h75Y01GBLXHFV5kER8flxAgE5RC802ND5jrdY9ze13uDpRcHufSonM1PPG3FsThY8Bmd6a28cGauLErvJ1PqMzn6eV6R66EAcnaoa/tDx92QGTgWHgr/0senz9mM9ekIAyECWYvUUAQCPiXHgRHmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z14QVR5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z14QVR5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39F9C4CEE9;
	Tue, 25 Mar 2025 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905910;
	bh=sDQjGI/FQbDeliczrsHg2jfwVKEciWjka/Op3pkSH/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z14QVR5PCq6F4GDVSMnKgG3+bd0hJxjxdda34ub+eWngSOuSUnTpimsVGDFRRcdR9
	 dcMnZYscVft55YWwt4GBm/HC7C+7Nc0AVr6yrIu2nCv5158lN/q1pelTQIAe3vaj2r
	 e9XDntgRI5xEvT/xgnGvjZrTfNkabladjgA40Wb8=
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
Subject: [PATCH 6.13 032/119] accel/qaic: Fix possible data corruption in BOs > 2G
Date: Tue, 25 Mar 2025 08:21:30 -0400
Message-ID: <20250325122149.885053172@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



