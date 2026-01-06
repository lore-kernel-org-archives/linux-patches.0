Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB19D35FF65;
	Tue,  6 Jan 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721766; cv=none; b=SPAK3mygU+bqUxwNfvTj6uEDUXJrB4tQKGMenfuKIzEJHHh4DBhYyeBOYQI3JeNVC4u3aE1G9uIR9OgI2yfesupt/FaSmL0JlkMOn0NJgP6JlCPmBfki/4GW+aINms3e5qcOS6Gyz7Fsv3RGDIdFwQbDpUa8uMmnTsMd9c3klgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721766; c=relaxed/simple;
	bh=ap9mCTBbXrB9TrGejOzecdnRN/sLQ88i73ofSyVfuFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsiXH5s5lodg9c8g8nBqtu6owhgbytSC1CcFPT57x/mbMd2e79ekcxI7nJ5tCArQEjeFX2IXMSTsgvegSmD1uBBcYfMhOjBKCYTI70uztloMAsmXvOZ/lUKsbAXdVh7+EddbebuaHoWFp1IwV4IZBryBmomycflJ0o+z6cqSMGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWiSnywI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWiSnywI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4DCC116C6;
	Tue,  6 Jan 2026 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721765;
	bh=ap9mCTBbXrB9TrGejOzecdnRN/sLQ88i73ofSyVfuFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWiSnywI+Ho5tyZbA3eqiDGFglYu3HDZHWaO1Hy7ONLRUovFtfwETFHYsg4oeTY5j
	 5o9P0ANVOzh+7RDKx/XIWSGPdM65jRqeq1qKP6ZogkE0sAnrJLTIpA1nY+B2rnWuCQ
	 TtiSKzAn2aEAK2bTESzD8SMK6igrNrDmZmNLRy8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/312] RDMA/irdma: Fix irdma_alloc_ucontext_resp padding
Date: Tue,  6 Jan 2026 18:02:20 +0100
Message-ID: <20260106170550.238576483@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d95e99a74eaf35c070f5939295331e5d7857c723 ]

A recent commit modified struct irdma_alloc_ucontext_resp by adding a
member with implicit padding in front of it, though this does not change
the offset of the data members other than m68k. Reported by
scripts/check-uapi.sh:

==== ABI differences detected in include/rdma/irdma-abi.h from 1dd7bde2e91c -> HEAD ====
    [C] 'struct irdma_alloc_ucontext_resp' changed:
      type size changed from 704 to 640 (in bits)
      1 data member deletion:
        '__u8 rsvd3[2]', at offset 640 (in bits) at irdma-abi.h:61:1
      1 data member insertion:
        '__u8 revd3[2]', at offset 592 (in bits) at irdma-abi.h:60:1

Change the size back to the previous version, and remove the implicit
padding by making it explicit and matching what x86-64 would do by placing
max_hw_srq_quanta member into a naturally aligned location.

Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
Link: https://patch.msgid.link/r/20251208133849.315451-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/rdma/irdma-abi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-abi.h
index f7788d33376b..36f20802bcc8 100644
--- a/include/uapi/rdma/irdma-abi.h
+++ b/include/uapi/rdma/irdma-abi.h
@@ -57,8 +57,8 @@ struct irdma_alloc_ucontext_resp {
 	__u8 rsvd2;
 	__aligned_u64 comp_mask;
 	__u16 min_hw_wq_size;
+	__u8 revd3[2];
 	__u32 max_hw_srq_quanta;
-	__u8 rsvd3[2];
 };
 
 struct irdma_alloc_pd_resp {
-- 
2.51.0



