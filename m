Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2408489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DE5C433D2;
	Fri, 10 Mar 2023 14:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457928;
	bh=akcG0TXqyqxMwyESgca7hpY2wS4MPmevEaoWxI8ZF3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+9RYgou7t+4uFrOZdgCay8ZfG/vWPnmQLKflr/Fid5MgjunpAtOv6SzVgo5M1puJ
	 +6GyuU1HonoDAJR8eZ1kYRaifWpbQMM7M7cWCmTywKgSE6dNq4MMOfqFBRK/VUD6YI
	 8AYxPaKdy6hvn446bRSPtnmv9qKS9S3VwQCfA7BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/252] powerpc/rtas: ensure 4KB alignment for rtas_data_buf
Date: Fri, 10 Mar 2023 14:37:56 +0100
Message-Id: <20230310133722.014731153@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 836b5b9fcc8e09cea7e8a59a070349a00e818308 ]

Some RTAS functions that have work area parameters impose alignment
requirements on the work area passed to them by the OS. Examples
include:

- ibm,configure-connector
- ibm,update-nodes
- ibm,update-properties

4KB is the greatest alignment required by PAPR for such
buffers. rtas_data_buf used to have a __page_aligned attribute in the
arch/ppc64 days, but that was changed to __cacheline_aligned for
unknown reasons by commit 033ef338b6e0 ("powerpc: Merge rtas.c into
arch/powerpc/kernel"). That works out to 128-byte alignment
on ppc64, which isn't right.

This was found by inspection and I'm not aware of any real problems
caused by this. Either current RTAS implementations don't enforce the
alignment constraints, or rtas_data_buf is always being placed at a
4KB boundary by accident (or both, perhaps).

Use __aligned(SZ_4K) to ensure the rtas_data_buf has alignment
appropriate for all users.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 033ef338b6e0 ("powerpc: Merge rtas.c into arch/powerpc/kernel")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230125-b4-powerpc-rtas-queue-v3-6-26929c8cce78@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 07d1ef762936d..7c7648e6f1c22 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -56,7 +56,7 @@ EXPORT_SYMBOL(rtas);
 DEFINE_SPINLOCK(rtas_data_buf_lock);
 EXPORT_SYMBOL_GPL(rtas_data_buf_lock);
 
-char rtas_data_buf[RTAS_DATA_BUF_SIZE] __cacheline_aligned;
+char rtas_data_buf[RTAS_DATA_BUF_SIZE] __aligned(SZ_4K);
 EXPORT_SYMBOL_GPL(rtas_data_buf);
 
 unsigned long rtas_rmo_buf;
-- 
2.39.2



