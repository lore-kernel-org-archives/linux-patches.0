Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B925E2E5B36;
	Mon,  1 Dec 2025 11:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588586; cv=none; b=t4ra0u8E8PubXoAL/ltpIYOnuG3RKFmgx2UxGgK3A4WIc/LUjtsCp0vuEOXZkoAYovMfhcJobcFeTw3DJsJ64fzwB02MXD6IGFCCmLh8sLAbCiocQuP34W27qZRskt3lASsyts48nqM5Sb11+RPMCIfrA+8/bOquJvLAedUHv8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588586; c=relaxed/simple;
	bh=5Qbth5hsRpYG3Dg4wNTbr8zrvhGr0lEXE2wM0C642Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGMLjLpOzZ/Ufsp/5dklZgLaTxdNwtxUBnNIdfKPsW0dUnxhSXqCOf0tBunTSrpzI0dtc4B1FoRvfhr2bD2/gIdmfU/O6RE8c7QpOykIWpLglouw2LcFytDuwXE6LhXxGJ5AVf4v7pKRJ3yvMn9og6HOjqhW6glBRvNu5hcoD9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6EWn1tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6EWn1tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378E2C4CEF1;
	Mon,  1 Dec 2025 11:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588586;
	bh=5Qbth5hsRpYG3Dg4wNTbr8zrvhGr0lEXE2wM0C642Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6EWn1tmJW9H8dzerVb8qG9FbNMYKNe5O7Vpm7Ydw2S+ZajZcIPM+dwyHHT2drp5o
	 pBh36msKYfPw94eMiNvQunpimnUBcayvHedx2fCLk+7r54RHN8ozjROPMdNUXm4CSu
	 zSaJ0LK4IrX4KvZDvWM/B6nved0JjAQins3UWaEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/187] nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing
Date: Mon,  1 Dec 2025 12:23:28 +0100
Message-ID: <20251201112244.851606770@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit a890a2e339b929dbd843328f9a92a1625404fe63 ]

Theoretically it's an oopsable race, but I don't believe one can manage
to hit it on real hardware; might become doable on a KVM, but it still
won't be easy to attack.

Anyway, it's easy to deal with - since xdr_encode_hyper() is just a call of
put_unaligned_be64(), we can put that under ->d_lock and be done with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7a4d7158c55f2..4e9b63c471af7 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -355,7 +355,9 @@ static void nfs4_setup_readdir(u64 cookie, __be32 *verifier, struct dentry *dent
 	*p++ = htonl(attrs);                           /* bitmap */
 	*p++ = htonl(12);             /* attribute buffer length */
 	*p++ = htonl(NF4DIR);
+	spin_lock(&dentry->d_lock);
 	p = xdr_encode_hyper(p, NFS_FILEID(d_inode(dentry->d_parent)));
+	spin_unlock(&dentry->d_lock);
 
 	readdir->pgbase = (char *)p - (char *)start;
 	readdir->count -= readdir->pgbase;
-- 
2.51.0



