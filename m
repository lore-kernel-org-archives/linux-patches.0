Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D0D435A9E;
	Thu, 30 Jul 2026 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425501; cv=none; b=mtQg9NoG/FmWHrhdaZ6ZnEp7GP0fl6UJbI9RXzdoI9KzSkYwVs+sA5udHSXp1Dtfr5iMXHIunx8G591+0eodhR7C2NEl1ViPSSeSsHqyT99kqEGHcK8pjTgNum5Bmh7YSafxP/E9odFk4ovl7ASad1aCZTMS8W4jMtiBop1+JPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425501; c=relaxed/simple;
	bh=YnhzX1u9Sji5hc9dDGg4SlSw7DDsrrMmnIUx5M/SodU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N57X5YX1zqi2CayEnwWcdHL7nvpezi7/VeDLPstGkZHf9kz+BJrutMO6ICLAIGTRspzcU9WWeD24+IEqXZfpwqIsBZ6gAbUrt2gOjCFz0C504qXsoaBjnP6CX3EihZJdn16ENoNv2l9YuEpBUat4vD9uetTn3063/9GG5AuuYBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sin3LnQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sin3LnQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD77D1F000E9;
	Thu, 30 Jul 2026 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425500;
	bh=rnnhF30sIF6Z6zZy+hTJVzZQBxZ8NyzS2eQEbfMYwkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sin3LnQLb2qfKEJBHjePNt3RskR5sC8CmNz0lgiFUj7NQBoYcKGKDqiI/FvHHJmbA
	 qNB1OUaPGcpZEhPpBgdy9+Y8EaXJVAX2HXSNWrb6wLam716wCXswWStoipySkHuwQc
	 AsUB0Yoofk46ZivQH8tGs8yc9vQW1hB624pHRXK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	David Hu <xuehaohu@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/602] RDMA/irdma: Prevent rereg_mr for non-mem regions
Date: Thu, 30 Jul 2026 16:07:18 +0200
Message-ID: <20260730141436.973651923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 92b56338819ef8..255c6d21756ba4 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3252,6 +3252,9 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
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



