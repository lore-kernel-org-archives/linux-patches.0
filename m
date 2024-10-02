Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92891CF5C6;
	Wed,  2 Oct 2024 13:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876272; cv=none; b=NVtlH6zcTPuEfnecX+TZuauF+ja+mrkUDvo+upAndUBbHT/dDjLEcEAR8GRgE+Firv1Q0JfgAeqLxgYdG9p7oyXIz/cC/Xg0t0EAE6XqbFSFoDbh2N7i0RKWJbjS0N353kSG6qfeJMgPKTszqB3onPtaaPr/GqUpsUrV6Pu+27o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876272; c=relaxed/simple;
	bh=xvmWxeO+8O4XXzAVODBVdMdZq05c7hg5FbxT6GYdDYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI7Sz7DmPaTKq0a8btan0Z4mC77RIYLXatfpfP1xjBo2jCK0iT6eCLhvS4j6SJmoKPaC/CX6OtairIUG0BTS7A7drE84Gam1lnkgZ8Wyq76VeeAYNuOG8szSRJWIxUIv6XgdV5VkoWxNVQFY3FKnIracmDe0jcCSa/d5LRvMd20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqSzCGgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqSzCGgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336CCC4CECD;
	Wed,  2 Oct 2024 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876272;
	bh=xvmWxeO+8O4XXzAVODBVdMdZq05c7hg5FbxT6GYdDYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqSzCGgYh7WNTWx98oecR/coNPNNYgfCP4qHAT2elVdjXUVEeL7v7k+6pamhY2+Kn
	 rUidmTKP5ukIcK5yvjUX8KNQ8jHIAOAudIf2LFUO5vsal+MhypmjdtR/mNOh35GSW4
	 Nasex9p+kXoc8eHSR2T2UiKzg0L8Bx0YgneWG4oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 386/695] RDMA/bnxt_re: Fix the table size for PSN/MSN entries
Date: Wed,  2 Oct 2024 14:56:24 +0200
Message-ID: <20241002125837.864320114@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit b930d0bac9c671c053dd66229010ca9298e84aab ]

HW MSN table size is always a power of 2. So the pages should be mapped
accordingly.

Use the power of two calculation while get the number of PSN/MSN entries.

Fixes: 6f6bfbc595fb ("RDMA/bnxt_re: Expose the MSN table capability for user library")
Link: https://patch.msgid.link/r/1724042847-1481-4-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 7c757351a0166..982e85ba211bc 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1042,6 +1042,8 @@ static int bnxt_re_init_user_qp(struct bnxt_re_dev *rdev, struct bnxt_re_pd *pd,
 			    qplib_qp->sq.max_wqe :
 			    ((qplib_qp->sq.max_wqe * qplib_qp->sq.wqe_size) /
 			      sizeof(struct bnxt_qplib_sge));
+		if (_is_host_msn_table(rdev->qplib_res.dattr->dev_cap_flags2))
+			psn_nume = roundup_pow_of_two(psn_nume);
 		bytes += (psn_nume * psn_sz);
 	}
 
-- 
2.43.0



