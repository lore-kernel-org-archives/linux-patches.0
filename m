Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077572CCB9;
	Thu, 30 Jul 2026 16:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427205; cv=none; b=utceGnDq6HoYfO2sj3gTCdzeIRupfR/GB9JDj6Xlq9ZxJEbbZr7+2diEpjSJvmGfHRQDj4AE11LURl6MQeHLIdFMCekhwVg8CcbH1+cD4wUMa2/6HGMOaW/eN3/7p1bwTdA1riTLXlc17ig2SlfgSshBGN9buqwnairxcxgrIXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427205; c=relaxed/simple;
	bh=kZMaKGAuraSz9F9lt2yykbM91ecHOjrh8MYobFSZbQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFq1eAJ7j3o7vNu4d/Z2B6UG1uLm51JFhAvmQf2HS6WKilme0pHgt1B5Gl5ION7Dy7cj5C+GXM+EbeXo5pRN23LdtZlaKbgMNUzoq2JMGtUNR5mTpUtkga17MADllF9vzhk0FhT6B0N3uhdLT9VXJ2ROR59Q3swQc0btEhfOHEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJ/thENN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJ/thENN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB831F000E9;
	Thu, 30 Jul 2026 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427203;
	bh=Q0EeOwrA+SA0/tfzYPlsLVKQPOxOwVKw3bVm0GOjhtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJ/thENNSo1iP2HLN/s/L1XuCbQuhOQhu/9e5sN6gGO+YOc75VUHFGqe/3fzlQLMI
	 l0C9E3fCh2QPz7c/LlygCBl9epmT6Cwo8twXD7peX4s3uRBsWZ7syVgSRjNFzdaK4E
	 Cn7WfuZI9r2ZigPYi+QV3hBUUITnJIG5G8i4C55s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	David Hu <xuehaohu@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/484] RDMA/irdma: Prevent rereg_mr for non-mem regions
Date: Thu, 30 Jul 2026 16:09:00 +0200
Message-ID: <20260730141424.359102300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit a846aecb931b4d65d5eafa92a0623545af46d4f2 ]

When a QP/CQ/SRQ is created, a two step process is used
where the buffer is allocated in userspace and explicitly
registered with the normal reg_mr mechanism prior to creating
the actual QP/CQ/SRQ object.

These special registrations are indicated via an ABI field
so the driver knows that they do not have a valid mkey and
to skip the actual CQP command submission.

Since these are real MR objects from the core's perspective,
it is possible for a user application to invoke rereg_mr on them
and cause a real CQP op to be emitted with the zero-initialized
mkey value of 0.

Fix this by preventing rereg_mr on these special regions.

Fixes: 5ac388db27c4 ("RDMA/irdma: Add support to re-register a memory region")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Reviewed-by: David Hu <xuehaohu@google.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 8ffbc790c1681e..1779d2a9945945 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3251,6 +3251,9 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
 	if (flags & ~(IB_MR_REREG_TRANS | IB_MR_REREG_PD | IB_MR_REREG_ACCESS))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	if (iwmr->type != IRDMA_MEMREG_TYPE_MEM)
+	     return ERR_PTR(-EINVAL);
+
 	ret = ib_umem_check_rereg(iwmr->region, flags, new_access);
 	if (ret)
 		return ERR_PTR(ret);
-- 
2.53.0



