Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50619247DEA;
	Tue, 20 May 2025 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750325; cv=none; b=GBFrbW3/N0iCTDwHZQFzdoS5WUOSICk74oAvuB8O1B/NE/QvKdyj4WvYrZ3PqTvQ47O9QhqRDp+Uv3XByP2cOF463Rqs2bQtlULJwqAbavgM6nPcmxOfidD2BNcgiPz8DzZqQjL4kE4stfDwiX3xZKEtMLPGlXoj3nf3Oq/xaVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750325; c=relaxed/simple;
	bh=zHObVoiILrErZdHErEQTsGoXh4dHvwksDHDgcZJ1wSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2nVLJBJffGZz51wPuCmvnFc95uVTCEFn7y/bJZ+AW6QflwaPfp066z03FieB06HEsva4J1vFEzxL7lOtWwcTAhn/at7mMNM2weyomlflug2h1bLc0ztLZZ2eYfHG6Bo/euW7EQu7PavDLsMGbyToPlEAiqyf4VijNIVyxEOcCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I38XtTwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I38XtTwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9348C4CEE9;
	Tue, 20 May 2025 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750325;
	bh=zHObVoiILrErZdHErEQTsGoXh4dHvwksDHDgcZJ1wSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I38XtTwlNK4yZcX6p+YUyJGpi5f0yVo23ggtJDAKCuVbowLgWllrpMvkgsErdiv9e
	 8c4OuHqHAM1u9l+/3nSsZBS3+EbPkhRcCA52Qo8qbW7Qerm4lGQbZUznRmiFka3CJX
	 XfXhE7fKFaAIz5tpir5tu5HowbBSUqe4Hi/Z3aKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 116/143] net: qede: Initialize qede_ll_ops with designated initializer
Date: Tue, 20 May 2025 15:51:11 +0200
Message-ID: <20250520125814.594883617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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


