Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7118A363C50;
	Tue,  6 Jan 2026 17:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721837; cv=none; b=KWIaJOJ76BKs1rzfTOd4AGahW8YAMt1Iz4iuAiFf2sqn45MGEbU7nSZeTqes6qY3Gbh7uEjNi2cuXBCxVe5hrIceXYtZOqaS09y65jLJYhXRsGZchMtqWgMXp73xYiobhfM1phl2iq36GSganJ1ZUgicU4bZ9eSg9bLGzg2RQII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721837; c=relaxed/simple;
	bh=+my1UPdPstnaG0Bq/1f+u4LIxMFE+4q1KGeIJlLFdRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJent85s7hOw/m5AxfkIyE5U77V6UVdQwZxLpJCLlN8vMIfmoJxTiSVJdAmbuGZotlvszWB4l8x4Uw/IJBHZB6qPJJXk1bWBEZuxMX7YtoFgZOmFzVzINAL7jvyCVHHZ1MrxP96rqGHxTTb9lLxKisbH5Vj77rx4YMBTrjTDvFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2baXE4Bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2baXE4Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B418CC116C6;
	Tue,  6 Jan 2026 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721837;
	bh=+my1UPdPstnaG0Bq/1f+u4LIxMFE+4q1KGeIJlLFdRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2baXE4BgaOQ83oo/8J4qkOZw28FCyqTF9KY3Sf8Nlb2lnIPmo+OgYcOJRJMNTB5/2
	 3obb5RmZjHop16B6KxKwoVTdfO8MPsYCv5urjgZkO69hAyiHSCLArzq69iwTa+n+k2
	 7Uzo0C5v3TL+CuD93N25SnP6jWg8n4TYS+R54HBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/312] RDMA/rtrs: Fix clt_path::max_pages_per_mr calculation
Date: Tue,  6 Jan 2026 18:02:39 +0100
Message-ID: <20260106170550.914113884@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggang LI <honggangli@163.com>

[ Upstream commit 43bd09d5b750f700499ae8ec45fd41a4c48673e6 ]

If device max_mr_size bits in the range [mr_page_shift+31:mr_page_shift]
are zero, the `min3` function will set clt_path::max_pages_per_mr to
zero.

`alloc_path_reqs` will pass zero, which is invalid, as the third parameter
to `ib_alloc_mr`.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://patch.msgid.link/20251229025617.13241-1-honggangli@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 71387811b281..2b397a544cb9 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1464,6 +1464,7 @@ static void query_fast_reg_mode(struct rtrs_clt_path *clt_path)
 	mr_page_shift      = max(12, ffs(ib_dev->attrs.page_size_cap) - 1);
 	max_pages_per_mr   = ib_dev->attrs.max_mr_size;
 	do_div(max_pages_per_mr, (1ull << mr_page_shift));
+	max_pages_per_mr = min_not_zero((u32)max_pages_per_mr, U32_MAX);
 	clt_path->max_pages_per_mr =
 		min3(clt_path->max_pages_per_mr, (u32)max_pages_per_mr,
 		     ib_dev->attrs.max_fast_reg_page_list_len);
-- 
2.51.0



