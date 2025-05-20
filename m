Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4456224677D;
	Tue, 20 May 2025 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749982; cv=none; b=Qlc2UwOVHPOSJv5rzmfle6Blvfu6Vy029HpZvBo/wRRTMBcZDUqGGxD/dEVXy/nrmfMUO+Y3fwNAUYw7nodi2WAIkTDuLEc5QON3AKop9BwPm8qJDbbiOw8l2hYqVMu6CjzQD8VW47xm6/UGn78vzNB3ARYkyZWyZVXWHNe5U58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749982; c=relaxed/simple;
	bh=4Z3NQ9tTBdBu3OQL5eN/buZqrG6+4S/EoNUPYSjaB/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tf2lapU6wMLpVT+KaLAOyx0d/XfFigVvj5MVVuWWuFWyvTCsQQeWiCX1nahYuj2OKs96BpyvHS+kaJsz326irPad/NGGOF7PLFXYdtwIIgkfbx3UeuRtvBH5HwNRbZ0TXumfytD6oSwR/Bb/tcLLEpAynpzW8dfhynVtpOuWi/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7C5DX6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7C5DX6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7ACC4CEE9;
	Tue, 20 May 2025 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749980;
	bh=4Z3NQ9tTBdBu3OQL5eN/buZqrG6+4S/EoNUPYSjaB/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7C5DX6NyWn8y0JgD/cAV/S/bDHPrh9Pbrqq4uXiy9CaOBGCivEYtkqLKBOzkXvLS
	 Ld1Z26WStXDInErGYeSLIvxQNpKACeKlM7s8qEmW7nSBytQDBIWu+hoYPs2QHu7z4H
	 1gu3a/g/l3tcwtPeLQUmrT3IO6c4FEnI/UWMZzCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 091/117] net: qede: Initialize qede_ll_ops with designated initializer
Date: Tue, 20 May 2025 15:50:56 +0200
Message-ID: <20250520125807.600303437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


