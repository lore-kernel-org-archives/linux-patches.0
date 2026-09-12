Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3E034E75A;
	Sat, 12 Sep 2026 13:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218631; cv=none; b=qB2TAstsoJYw5B0cBMUcc8RB0y3Ib5Of/3MO7GsYdwHdjxJPNZBm+/vH8oEMapmJZiTaXhOau0DiPW4OKEUiNx3NjSatMSMiwcGiwfhuuUHFLFsGeUXeLjbvxTCUsPzCoC6kAqaRP1oA/ZulHd0MmtmFEKvUCNjF01gUQNuPizo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218631; c=relaxed/simple;
	bh=egnTXbY/Rqf739OyjTqD7keXm3AGISiF1mdjb0Lpn9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMvG2bQPePRM+EwUXrUIJO5k9gAkbjcBoRXLgUjvIemc+tlqv4rkfdqUsh1MAOpP8eCyKC8Ctuf6Tg0DelzCEXA268MnghPbwAybQ6BYU1Wi9mmjGKIw4HH/US7OE2telcViZ7nvZ+tg0g/q+dJ87pyrgtlM5EXEd9aChkq26B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANITzypR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANITzypR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336D11F000FF;
	Sat, 12 Sep 2026 13:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218630;
	bh=RXHA3oDUy9DOFvlfS1Abdd8PGG6pLHlT2T2C1Sm/BgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANITzypRCe5ab4QmV8xBbI07WAZ/BY69nHPLxvhosVd4GXkESBJBqTMSx4++rEBVC
	 SLsoOkqlUo3gLq9gBwm8eIj8xKgIIRrzKP3MI397opt5jYZHIM5AN2B3/oSZ6JaW4T
	 8tl3LrB5zjGz/HctRsL2/qTXvya1+8/1jfK5zsgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhansong Gao <zhsgao@hotmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1184/1376] NFSv4: Fix incorrect argument passed to nfs4_delete_lease() in nfs4_add_lease()
Date: Sat, 12 Sep 2026 09:00:10 +0200
Message-ID: <20260912065633.940177891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Zhansong Gao <zhsgao@hotmail.com>

[ Upstream commit 468e458ffde907ba19acd2102ca1fbb8f6fbede2 ]

When nfs4_add_lease() races with a delegation return, it calls
nfs4_delete_lease() to clean up. Previously, it passed priv,
which can legitimately be NULL. Passing a NULL priv eventually
leads to a NULL pointer dereference in generic_setlease().

Fixes: e93a5e9306a5 ("NFSv4: Add support for application leases underpinned by a delegation")
Signed-off-by: Zhansong Gao <zhsgao@hotmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index facd4e28770be..54e991d598f7c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7812,6 +7812,7 @@ static int nfs4_add_lease(struct file *file, int arg, struct file_lease **lease,
 {
 	struct inode *inode = file_inode(file);
 	fmode_t type = arg == F_RDLCK ? FMODE_READ : FMODE_WRITE;
+	fl_owner_t owner = (*lease)->c.flc_owner;
 	int ret;
 
 	/* No delegation, no lease */
@@ -7821,7 +7822,8 @@ static int nfs4_add_lease(struct file *file, int arg, struct file_lease **lease,
 	if (ret || nfs4_have_delegation(inode, type, 0))
 		return ret;
 	/* We raced with a delegation return */
-	nfs4_delete_lease(file, priv);
+	dprintk("%s: raced with a delegation return\n", __func__);
+	nfs4_delete_lease(file, &owner);
 	return -EAGAIN;
 }
 
-- 
2.53.0



