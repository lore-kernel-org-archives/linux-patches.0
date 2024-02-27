Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A87C13AA43;
	Tue, 27 Feb 2024 14:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042923; cv=none; b=JpB7N3gbfhquThkQtPwCU1eYFBM1aiww1//jKIOYUHRKRNVUuA6bKRHY3arpySMCury+eiCB8YvkLknAOFbz0Cm4ZdFlDMwZ4QT9S0k9Fy5eyrnrgGdNwSfpVebPdlQydhxNGrzYE32ceU3JKOMhjMQxOdZyIUCVlw71FKbXRBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042923; c=relaxed/simple;
	bh=Eooh/YLrmfejrW2h2wJ9Iz7TBTrjKhhj2pQLhQRrPSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mg8hjiZiaI8n2kUSsj5bU9P0q+fnWiLH0cPmpbHAAVAJ+eC8tN+u3NYYZj3fzSBsLfOD/a4kNxRtInb0DpBG7j9BDRBItn4VQyaezYrsjv1MV6t7Fb7owktcuPICgEuMdoOopac0yqhxpUwauHOIOlAtDAVLrSrhXDKCUWzd3ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZy6b+ri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZy6b+ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E4C433C7;
	Tue, 27 Feb 2024 14:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042923;
	bh=Eooh/YLrmfejrW2h2wJ9Iz7TBTrjKhhj2pQLhQRrPSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZy6b+riX/RMXielQsmjermmsc6eJAHK1Ya+QgZAJA4pqVpkg9q67wAB3j3AFO4N+
	 136E1J1u/oUrfGig5QK99KDoxlf7iLDCbCU5iGlrZRWAN3Rho4QweO0z731klL2RuG
	 Zj1tXb4NqaHnrvi03Cw1zDhohWZr4UCIY1NYohvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/245] powerpc/rtas: ensure 4KB alignment for rtas_data_buf
Date: Tue, 27 Feb 2024 14:25:40 +0100
Message-ID: <20240227131620.160114192@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 4da9baa0fbe8c..d01a0ad57e38e 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -70,7 +70,7 @@ EXPORT_SYMBOL(rtas);
 DEFINE_SPINLOCK(rtas_data_buf_lock);
 EXPORT_SYMBOL_GPL(rtas_data_buf_lock);
 
-char rtas_data_buf[RTAS_DATA_BUF_SIZE] __cacheline_aligned;
+char rtas_data_buf[RTAS_DATA_BUF_SIZE] __aligned(SZ_4K);
 EXPORT_SYMBOL_GPL(rtas_data_buf);
 
 unsigned long rtas_rmo_buf;
-- 
2.43.0



