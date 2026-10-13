Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEC447AF65;
	Tue, 13 Oct 2026 12:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894203; cv=none; b=SL1Tfi7+A9R3UqyhQ8ecEM8pgWiF33CuzGKFN23FzvUqgJlIlDZjhO1nE/MYhTOepoXJsx4vd/cQpv65HKpn12dB4pHL5zA+cZ/Z1nFsoqbc9EGhWhvZa0xMHdy0eI3+K9ZoYpZzLHqGYDmuhNOAa3jrUqK1C3qoxZkxRcOuAbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894203; c=relaxed/simple;
	bh=MkTDskCiW8ccz8yFQXIYmLW+FxK6p0Qz0nvbgTscCKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuuTvFz5wubMBu5YBETLRuHuuJri1BrT77Fr997DUXfTLl68w5kkiBVdEHPgGX/5EtuSiHjWwMW2OiZuSJ2r6iT8Fn2gri9WfTY06CvCJ5pT9usxjrxIreFCgF9dXfSBTUiaHsqJbrFisknJHsPN/psliIH2GZ4OMYHxqO842MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGZO0qrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGZO0qrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8C91F00893;
	Tue, 13 Oct 2026 12:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894202;
	bh=6UZogdb6NboDl3EPK/7b0xLHMilplkGMZuJlWi7BLAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sGZO0qrUltx88ULxeEqlsxHrw1Drh8d9yUjTOYv5FftUCM9FWmT/kpNKaQGHhO/84
	 B0kw4LqSD3RWkxaCfQsNMsUhKm5+gMdZadnuYLDu572oWN3WgWdE1RoU2Erd3WTNkS
	 MHmpU/KrPTuo1XHPl/0zyziSWqjdLgwQa9qOTPkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 479/621] RDMA/rvt: Return NULL after port allocation failure
Date: Tue, 13 Oct 2026 13:37:54 +0200
Message-ID: <20261013112932.201441763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 2982eaf3b9d2d953318c74cd6f1b7576ea6d7b1f ]

rvt_alloc_device() deallocates the IB device when its port array cannot
be allocated but then returns the pointer to the released allocation.
Callers treat any non-NULL value as valid and dereference it, resulting
in a use-after-free.

Return NULL immediately after deallocation so callers can propagate the
allocation failure.

Fixes: ff6acd69518e ("IB/rdmavt: Add device structure allocation")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-1-b9e9641268a5@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/vt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index d22d610c26963..4f73e643b9e50 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -54,8 +54,10 @@ struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 		return rdi;
 
 	rdi->ports = kcalloc(nports, sizeof(*rdi->ports), GFP_KERNEL);
-	if (!rdi->ports)
+	if (!rdi->ports) {
 		ib_dealloc_device(&rdi->ibdev);
+		return NULL;
+	}
 
 	return rdi;
 }
-- 
2.53.0



