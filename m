Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27C724337C;
	Tue, 20 May 2025 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749594; cv=none; b=ehuudt5YQBQr6J+5SvDC+DlKoSimld/dr5ug0SUBHofekNtD0grKoIF2X+gCJtuSYcQ8vmXUT9HZMFjMRWn1D7A/FfS8MqfB1GUy8aPAnzhLhiF698+TmtntwLb2x2seth3xh+iyqghUeq7fEOOxhpT5lVUH9IJ9h9CNdiwA4lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749594; c=relaxed/simple;
	bh=1XWSK+aVLEua948AZpPZwEnMYTMsn2Vi+gGKo74UYGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhUHK/5bjEd2lgBC3COzB4HiI44Q/70XwOUsq0eXLaHHcaV9CQr1HUvFzTfpolyhGgej6eJTI2KHlK9ThUMx/cKp9TFJk45ZqiarqGuXxBIm0K9af/G7ph+gw9/NKNyqD+tH8L5zcJNFmfQ19kyw3cNvfi2oIxk1kT/GsTGUzoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/6/H6R6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/6/H6R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4246CC4CEEA;
	Tue, 20 May 2025 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749594;
	bh=1XWSK+aVLEua948AZpPZwEnMYTMsn2Vi+gGKo74UYGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/6/H6R6AS8I86Ytdyd0sVI87S4yI5+LJelR0CPxgawSHKA3g2WQIjKmzso+8FTos
	 9WCWNwXN2LDZWdJs3TvNC7vxg9POJkt0MOMdQcX2DzO3ISK477mMhQUIy6yiSrmqa1
	 YWjVr5CcDx5ZU6cU2U3r8cpRlpepi2CHYe21c9+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 64/97] net: qede: Initialize qede_ll_ops with designated initializer
Date: Tue, 20 May 2025 15:50:29 +0200
Message-ID: <20250520125803.158548759@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -204,7 +204,7 @@ static struct pci_driver qede_pci_driver
 };
 
 static struct qed_eth_cb_ops qede_ll_ops = {
-	{
+	.common = {
 #ifdef CONFIG_RFS_ACCEL
 		.arfs_filter_op = qede_arfs_filter_op,
 #endif


