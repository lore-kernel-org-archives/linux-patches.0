Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1342D8363;
	Tue, 12 Aug 2025 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022582; cv=none; b=lB67jW8mEDgMKyfAVzQCtPpAzxtGLdxpTQrv0vctFQ9LKwjDHKgEypSsMfRlJx6mZpEbCT806wkuSmHjLVMixsti+POoZu5A3LsyPDBLRzpzjZGSsnCeAIdICggOCDWc4RO59Yg2uO9fWUl4ewkCKyJzWQCX9MjHhzQ8KkCSNXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022582; c=relaxed/simple;
	bh=Ec+HXgrIBaB39I3tew0zByYx9FUa5P/6N5qq3aeyOao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PV5ov9EpZIotISP0esAHP9zGk0Hj4BrkeR0VPfzpCEwZ0FQjZ4PRAMLo1jLHG7pGmAUHUsFf3FreJtl6tYerLVcAQBDfmZG73TsbL9xDCcQLdXVBQ175p4Pl4mnL/a5X27HZWacEngWfE5TtB9yiu7l4zO2x1vR7buGUSBhdZfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb8mej2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb8mej2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08151C4CEF6;
	Tue, 12 Aug 2025 18:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022582;
	bh=Ec+HXgrIBaB39I3tew0zByYx9FUa5P/6N5qq3aeyOao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tb8mej2Y11P+B33bAu1LBDSbE2rmvzhJZaKNIoYaSF5ebf/GgwaYsv+H9BeMc6CvQ
	 XrYdoHhpSFsZYn6KC8ZHCA16uNw8fEv6Ms8qJQWDu6WW8496/j2JnT8/GEghQKhJ0k
	 E1+FhXm60h3MXFD2QfNsSHu3tL3G1BZ6k9YaeNtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/369] RDMA/mana_ib: Fix DSCP value in modify QP
Date: Tue, 12 Aug 2025 19:28:14 +0200
Message-ID: <20250812173022.176537996@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Shiraz Saleem <shirazsaleem@microsoft.com>

[ Upstream commit 62de0e67328e9503459a24b9343c3358937cdeef ]

Convert the traffic_class in GRH to a DSCP value as required by the HW.

Fixes: e095405b45bb ("RDMA/mana_ib: Modify QP state")
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1752143085-4169-1-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 73d67c853b6f..48fef989318b 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -561,7 +561,7 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		req.ah_attr.dest_port = ROCE_V2_UDP_DPORT;
 		req.ah_attr.src_port = rdma_get_udp_sport(attr->ah_attr.grh.flow_label,
 							  ibqp->qp_num, attr->dest_qp_num);
-		req.ah_attr.traffic_class = attr->ah_attr.grh.traffic_class;
+		req.ah_attr.traffic_class = attr->ah_attr.grh.traffic_class >> 2;
 		req.ah_attr.hop_limit = attr->ah_attr.grh.hop_limit;
 	}
 
-- 
2.39.5



