Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C9E348879;
	Tue, 11 Nov 2025 01:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823769; cv=none; b=rwNTxQbAyVluvISmFNStDpWYRzEdILe8uFKKjM6iSzMuaYEOR35EtyJABf3Y2DES2nhMlKr7v2ykMvWZadfJaAWqkq+tUupv0OyHLcYRFDRb6FTHUReLeNwCWR550WyGHZ0QiVlCRy8XcCaebHSE4/4S0tQXjU5PpjvVaIci4P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823769; c=relaxed/simple;
	bh=Oa+uYcc/NjAZxHn6DROJ6HHfKgtzDcpBsZWgd1m3kx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed1HG2WeZMUn1OCIUXqPKWB3CLX0QKxQyNg5/jJhtczT3nb5GV3fvPDpaR8PP0v3UYL+os7IJWkGygLUvNgVUeQMfv7gCJi8qq07OuVcGGZQWErqD2bvUnv0be6CFIRmec5CsPyazkGwHu+TT+03sKsxMNwX0yvZ6p7XDJl7AxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSqMgUxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSqMgUxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B1CC16AAE;
	Tue, 11 Nov 2025 01:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823766;
	bh=Oa+uYcc/NjAZxHn6DROJ6HHfKgtzDcpBsZWgd1m3kx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSqMgUxCuDqGyeyBGXSNpimpIMG7OY5peVcZtXjT32POnRWSE4BT8fg2RousutMmM
	 bmPeFoDWxVY2GvmrGw651Zjy+Xwk6U95oxilsvs9FYBI0uRVVUi+G6clGM2c633zgP
	 D9nMZoBCagBUV3YeXVU8SLRtsUQxJVd0GtzumE8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xion Wang <xion.wang@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/565] char: Use list_del_init() in misc_deregister() to reinitialize list pointer
Date: Tue, 11 Nov 2025 09:42:51 +0900
Message-ID: <20251111004533.973509850@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Xion Wang <xion.wang@mediatek.com>

[ Upstream commit e28022873c0d051e980c4145f1965cab5504b498 ]

Currently, misc_deregister() uses list_del() to remove the device
from the list. After list_del(), the list pointers are set to
LIST_POISON1 and LIST_POISON2, which may help catch use-after-free bugs,
but does not reset the list head.
If misc_deregister() is called more than once on the same device,
list_empty() will not return true, and list_del() may be called again,
leading to undefined behavior.

Replace list_del() with list_del_init() to reinitialize the list head
after deletion. This makes the code more robust against double
deregistration and allows safe usage of list_empty() on the miscdevice
after deregistration.

[ Note, this seems to keep broken out-of-tree drivers from doing foolish
  things.  While this does not matter for any in-kernel drivers,
  external drivers could use a bit of help to show them they shouldn't
  be doing stuff like re-registering misc devices - gregkh ]

Signed-off-by: Xion Wang <xion.wang@mediatek.com>
Link: https://lore.kernel.org/r/20250904063714.28925-2-xion.wang@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 6f9ce6b3cc5a6..792a1412faffe 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -299,7 +299,7 @@ void misc_deregister(struct miscdevice *misc)
 		return;
 
 	mutex_lock(&misc_mtx);
-	list_del(&misc->list);
+	list_del_init(&misc->list);
 	device_destroy(&misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	misc_minor_free(misc->minor);
 	if (misc->minor > MISC_DYNAMIC_MINOR)
-- 
2.51.0



