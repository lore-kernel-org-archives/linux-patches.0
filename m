Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3771C28D854;
	Wed, 23 Apr 2025 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421071; cv=none; b=ujui9TCeyyvpmoD3iZFlRl2T636LX3fyrdzZWLzKS73MukwV07cGfsqb6SpRAGghGOYGxTHzdec/AgCj3vc9yZf3/X9tynspxQ8FwhpFjuurssG0wi2oV37khPBf3IJ+yRvQ5cPP/VQwlfSZn2GRsmt3flDDHb/ZkwllxNAJ/aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421071; c=relaxed/simple;
	bh=YOYAv+YwPa4kh5yGVBQI7MEyDsTgh20PimoPWYQvbfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnKRP217sxAmKqHcU8Y9k3+i/6JJNcAy4ifvHpag2Pw0RBeBHyxbi1eRaop2U8a5SDJVzNm/Ufkfdzt0TVX8F1lpGumOgCH++KYYvb5Ax+kAMK76j5KYsY8yETvj+9HSdhUPEppNtgMDiRSLC24kVtzkBb+5KOTZo24tPBmwFds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWhiAwxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWhiAwxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6506DC4CEE2;
	Wed, 23 Apr 2025 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421070;
	bh=YOYAv+YwPa4kh5yGVBQI7MEyDsTgh20PimoPWYQvbfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWhiAwxmyVa7a3MAQdl/ZIZ8EDM/OOVdNJqBZ7nCEyIdlojQkbQjl2LxHI5LmIOnr
	 ivOS1jt2EyvA/TnnYYRlcx1ZGXP23Fi8hBLNkVTXgmadleJUENWGz0IjZfZZ8RPWEy
	 zQPQR9ZkUmKMRnzGHl9dKqF6ONXjgzwupi+d9v98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 144/393] media: venus: hfi_parser: add check to avoid out of bound access
Date: Wed, 23 Apr 2025 16:40:40 +0200
Message-ID: <20250423142649.330699316@linuxfoundation.org>
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

From: Vikash Garodia <quic_vgarodia@quicinc.com>

commit 172bf5a9ef70a399bb227809db78442dc01d9e48 upstream.

There is a possibility that init_codecs is invoked multiple times during
manipulated payload from video firmware. In such case, if codecs_count
can get incremented to value more than MAX_CODEC_NUM, there can be OOB
access. Reset the count so that it always starts from beginning.

Cc: stable@vger.kernel.org
Fixes: 1a73374a04e5 ("media: venus: hfi_parser: add common capability parser")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -19,6 +19,8 @@ static void init_codecs(struct venus_cor
 	struct hfi_plat_caps *caps = core->caps, *cap;
 	unsigned long bit;
 
+	core->codecs_count = 0;
+
 	if (hweight_long(core->dec_codecs) + hweight_long(core->enc_codecs) > MAX_CODEC_NUM)
 		return;
 


