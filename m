Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AE724468C;
	Tue, 20 May 2025 14:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750783; cv=none; b=Vs87wgZa1PJhqYpqSLL9sAFrbZIU+YWEVN2QfE24LS9pCBnHvcZJ2fBONNGDh/HZIFk8RzEXz1z1Y1DmcfnfwVdSenk7/KuIgyW48zT8GvP2Z9OP1H1nzsSFwB30mPgvQ1mTjn/5dm/sQN1L+UipRi1gtWEPIwh9CSY3vzTmbFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750783; c=relaxed/simple;
	bh=k5GBe7YWOo9ZVMbg+VB61eN7en+hKkm3do64RCxZyD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K86ijGZohpsjAhn6Xgi/dcaaciWlLSynemEjB4W/t7Vtcv04chio8Hvh8ylaHd29lGFs3JlbojjMdpHZruQKDdBCHeMcxL0fv/5VkpDaj/MmnqqrPeti7sShMPKw29Wk4a79fz9nEwK+9qk+/703gbGWsE/VrlLLWEU/neSZ/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTVxr23i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTVxr23i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B508AC4CEF1;
	Tue, 20 May 2025 14:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750783;
	bh=k5GBe7YWOo9ZVMbg+VB61eN7en+hKkm3do64RCxZyD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTVxr23i+h1/JpPeSvsXUebWnISgJj3McGmNYrpw9fRzsAyDYoSJvfXvW6X2DO27n
	 hDkWsWZCOZ2cIuTLrxBVzuDvJN9viscsPt2mT8U+kz+s2UEu74CS29vZVd6n2Mm/o7
	 qL63gOD3mP6qsKnd3xpXeZzYSNUHoLrMeudj9Vb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 120/145] net: qede: Initialize qede_ll_ops with designated initializer
Date: Tue, 20 May 2025 15:51:30 +0200
Message-ID: <20250520125815.252646459@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 6b3ab7f2cbfaeb6580709cd8ef4d72cfd01bfde4 upstream.

After a recent change [1] in clang's randstruct implementation to
randomize structures that only contain function pointers, there is an
error because qede_ll_ops get randomized but does not use a designated
initializer for the first member:

  drivers/net/ethernet/qlogic/qede/qede_main.c:206:2: error: a randomized struct can only be initialized with a designated initializer
    206 |         {
        |         ^

Explicitly initialize the common member using a designated initializer
to fix the build.

Cc: stable@vger.kernel.org
Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
Link: https://github.com/llvm/llvm-project/commit/04364fb888eea6db9811510607bed4b200bcb082 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20250507-qede-fix-clang-randstruct-v1-1-5ccc15626fba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -203,7 +203,7 @@ static struct pci_driver qede_pci_driver
 };
 
 static struct qed_eth_cb_ops qede_ll_ops = {
-	{
+	.common = {
 #ifdef CONFIG_RFS_ACCEL
 		.arfs_filter_op = qede_arfs_filter_op,
 #endif


