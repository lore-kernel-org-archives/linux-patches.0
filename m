Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCD8383C7B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302032; cv=none; b=nMyg/ja8bLJZ7KrzJhVXVpi5jwA/ddA+CP9Edn/9eSyRtDWOvugN7M8LMp835gITE1Ds7vtar9bKCeJ0oo4vl/26NOliCjx9luIg283bzKonaT6KMZPwtgyZpZFq79bBNAryO7Fw+IgTNkhRpgdoPY5tVOB/J3j2+K7fsPR29eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302032; c=relaxed/simple;
	bh=SAglDrCuZLPx3lj9cTsxlDzD/ZzdtaqDulL3isYZ580=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNjvvHbcCJDbVHogW6UKRpJP2cToUkxIqYCxKFbCf+PUXj9/Y4DSr4qYJoh9VtYSR5867sLbE8QK0VUz7lN8o4biz8C7CMMknC5FNbdAp6WuAHHYJf/1eOieoy+S1DIfHR7QrzvvpptkQrdZ+cTTXN39f2BdXr8tLPqYwHGrLcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mD1oOCq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mD1oOCq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65774C19424;
	Sat, 28 Feb 2026 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302032;
	bh=SAglDrCuZLPx3lj9cTsxlDzD/ZzdtaqDulL3isYZ580=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mD1oOCq4GgLVlz9nqmfOctMIGvMgBRLOeSM7MZoxPZP+nc8t5U9uqFMWklVrKkm7e
	 HUh5BB3WNQgLilAH+RFO49QMYb38jCfZSNaOtqCrEymG8STtSS//PmW/fAM4QUYx58
	 OzqgveHpAYFuSy0ljyAghPZ8wOKxyABZFX7Vh10BLsUYsVtFKuIAFfg9DlgX6Pr1MJ
	 QRgS6+uGphbK06F2iQ1TS4fMf1bK3WVKrJcjRfKKUzh9n/fdQgjNkAKKPsKr5atyDj
	 tH2HTPmvqC3X74mfzuWIY1bW1UupLEqunu5t5koactI04vroVS+0FMiohTEjCEPjIS
	 lKBwIEcr2IgqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: YunJe Shin <yjshin0438@gmail.com>,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.6 002/283] RDMA/umad: Reject negative data_len in ib_umad_write
Date: Sat, 28 Feb 2026 13:02:24 -0500
Message-ID: <20260228180709.1583486-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: YunJe Shin <yjshin0438@gmail.com>

commit 5551b02fdbfd85a325bb857f3a8f9c9f33397ed2 upstream.

ib_umad_write computes data_len from user-controlled count and the
MAD header sizes. With a mismatched user MAD header size and RMPP
header length, data_len can become negative and reach ib_create_send_mad().
This can make the padding calculation exceed the segment size and trigger
an out-of-bounds memset in alloc_send_rmpp_list().

Add an explicit check to reject negative data_len before creating the
send buffer.

KASAN splat:
[  211.363464] BUG: KASAN: slab-out-of-bounds in ib_create_send_mad+0xa01/0x11b0
[  211.364077] Write of size 220 at addr ffff88800c3fa1f8 by task spray_thread/102
[  211.365867] ib_create_send_mad+0xa01/0x11b0
[  211.365887] ib_umad_write+0x853/0x1c80

Fixes: 2be8e3ee8efd ("IB/umad: Add P_Key index support")
Signed-off-by: YunJe Shin <ioerts@kookmin.ac.kr>
Link: https://patch.msgid.link/20260203100628.1215408-1-ioerts@kookmin.ac.kr
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/user_mad.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 2ed749f50a29f..285f251fc014b 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -514,7 +514,8 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	struct rdma_ah_attr ah_attr;
 	struct ib_ah *ah;
 	__be64 *tid;
-	int ret, data_len, hdr_len, copy_offset, rmpp_active;
+	int ret, hdr_len, copy_offset, rmpp_active;
+	size_t data_len;
 	u8 base_version;
 
 	if (count < hdr_size(file) + IB_MGMT_RMPP_HDR)
@@ -588,7 +589,10 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	}
 
 	base_version = ((struct ib_mad_hdr *)&packet->mad.data)->base_version;
-	data_len = count - hdr_size(file) - hdr_len;
+	if (check_sub_overflow(count, hdr_size(file) + hdr_len, &data_len)) {
+		ret = -EINVAL;
+		goto err_ah;
+	}
 	packet->msg = ib_create_send_mad(agent,
 					 be32_to_cpu(packet->mad.hdr.qpn),
 					 packet->mad.hdr.pkey_index, rmpp_active,
-- 
2.51.0

