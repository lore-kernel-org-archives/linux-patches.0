Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71944231829;
	Tue, 21 Jul 2026 18:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660010; cv=none; b=BQQrG/MhiymDwQXw5oldDu0Hn/W8eVLfLmWhyTuKfKGq7BR0ZgBynWXnFZM2qWsdMMhd50z5F4PLNyzv+IknIGuBEzuIRzZApHRfD2Xapadbe4oG6QrCgsAaEXzX0IryqV3Y0zvcuJcAyLNsF9b6nEoq3++JGgm5ydyQj7IJkHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660010; c=relaxed/simple;
	bh=91BYt3Bk0GRJua31hyKvKchWUSN72jqLRYUvLaoXXIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lz/8selkdT0dNglp/hvXDLYdw6fYGkGuWpeuX4v0slkVQKzvi01zo4zsoAUTlWGi4l0dqMrd9XMpgz45I8QfYcHtehkydoiE6UwbhpGIe09kYimTLj/Q874/Q3wcTvqm1qG+KUzxCltv8mlIBclajnMAo/zZc31m4ZTxCVqEZbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K31th42f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K31th42f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77C51F000E9;
	Tue, 21 Jul 2026 18:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660009;
	bh=GH4gPJ1VZk/BF9I7S1+NWLPXR6mhKuBYah0xKcDNwKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K31th42ftvo2alISGhNRVt0jP6w/NSJVvXkpgg4VbL2v5J4Nncp7TWsn1hGSj4oZD
	 /+odkm2mowpnGjiMjvIABE2JukDH34Z+c9LwmR7Tpw1vbVrbddXDBzlWR+er2qrseA
	 Rr192ms3ZlDFqUAywcuhijsnk4WrB9j9o5mDr4AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0816/2077] RDMA/bnxt_re: Reject GET_TOGGLE_MEM when toggle page was not allocated
Date: Tue, 21 Jul 2026 17:08:09 +0200
Message-ID: <20260721152612.037117618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 33a215f499b0643cd88a32ab5b8de1547be419c6 ]

If a user calls BNXT_RE_METHOD_GET_TOGGLE_MEM on a device that does not
support the CQ/SRQ toggle feature, uctx_cq_page or uctx_srq_page will
be NULL.

Add an explicit -EOPNOTSUPP return after capturing the address from
uctx_cq_page / uctx_srq_page if the address is zero.

Fixes: e275919d9669 ("RDMA/bnxt_re: Share a page to expose per CQ info with userspace")
Fixes: 181028a0d84c ("RDMA/bnxt_re: Share a page to expose per SRQ info with userspace")
Link: https://patch.msgid.link/r/20260615224751.232802-16-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/uapi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 2891b18b9437f5..ca6b1630cd83db 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -277,6 +277,8 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 			return -EINVAL;
 
 		addr = (u64)cq->uctx_cq_page;
+		if (!addr)
+			return -EOPNOTSUPP;
 		break;
 	case BNXT_RE_SRQ_TOGGLE_MEM:
 		srq = bnxt_re_search_for_srq(rdev, res_id);
@@ -284,6 +286,8 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 			return -EINVAL;
 
 		addr = (u64)srq->uctx_srq_page;
+		if (!addr)
+			return -EOPNOTSUPP;
 		break;
 
 	default:
-- 
2.53.0



