Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3014C5172EC;
	Wed, 30 Sep 2026 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784876; cv=none; b=QVuw4Ho4cLmqbqmrq3y4gDBJiTDeUiGXyJC/8R3hfnT8m2qhJCorgOq9+2Y7w2nxrs6dkm+KH+5CpshMEfwx+md8b86Obr6uxNyNC9hN18dxTzsJTNnwXjRWxrOq0xmqMPZj+E9V/1DLONkIBefBgvJ19zd70oLacXNRCtZYrYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784876; c=relaxed/simple;
	bh=TwfAWgfMjTmb4JVw1E7DqIUW0ZvkaLYtXI0KXPYBrZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCQ/FBmUgu24/LSPmaordKRLwuyTl1bgtWLhNnh/Uc98pHsKOAN4MRsVCOM4+PL2M1Sg6+YSRkvVWMHNLISb/qeB0stSXekGAOTzxCHTWoBNdBLJdD5FyPZJFuLNU4Z8FuoNf1F5p0vsIT8gC8Ol9XpUp3VW7g2xBU1P2bQ0EPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNkZY2b1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNkZY2b1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692231F000FF;
	Wed, 30 Sep 2026 16:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784870;
	bh=PEbE8wyidsbWb/izKqAPEQ4Naz7TXQm7m/Ml3it6sDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNkZY2b1gpIz/ijy64DFRQgw8K2o6Z4eiVtrmSIjYDhi2IZgo35tjHSMPpZPmBwkt
	 CYR/csWaDSpHT/nYFWhn4zG14i0+zdI5N5o1I4+e7TLtndYHgPfOeSn3cduXt5BulT
	 yQRHzODQfnSram2pdxXaRkUHA+rRxmxlW25DOTg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LocalHost <localhost.detect@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 301/982] ksmbd: validate ACE size against SID sub-authorities
Date: Wed, 30 Sep 2026 17:17:17 +0200
Message-ID: <20260930152423.273736278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5152c6d49e3fd4e9f2e857c57527aead752f1f87 ]

set_ntacl_dacl() validates sid.num_subauth before copying an ACE, but
does not verify that the declared ACE size contains all sub-authorities
described by that field. An undersized ACE can therefore be copied
and later make the POSIX ACL deduplication walk inspect data beyond
the copied ACE boundary.

The existing initial bound check is also too small. It only ensures
that the ACE size field is accessible before set_ntacl_dacl() reads
sid.num_subauth farther into the input buffer.

Require enough input for the fixed SID header before accessing
num_subauth, reject ACEs smaller than that header, and skip ACEs
whose declared size cannot contain the complete SID. This makes the
validation consistent with the other ACE walk paths.

Reported-by: LocalHost <localhost.detect@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 051df6536f7a3..7a0396db6f1d2 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -749,15 +749,22 @@ static void set_ntacl_dacl(struct user_namespace *user_ns,
 		for (i = 0; i < nt_num_aces; i++) {
 			unsigned short nt_ace_size;
 
-			if (offsetof(struct smb_ace, access_req) > aces_size)
+			if (aces_size < offsetof(struct smb_ace, sid) +
+					CIFS_SID_BASE_SIZE)
 				break;
 
 			nt_ace_size = le16_to_cpu(ntace->size);
-			if (nt_ace_size > aces_size)
+			if (nt_ace_size > aces_size ||
+			    nt_ace_size < offsetof(struct smb_ace, sid) +
+					  CIFS_SID_BASE_SIZE)
 				break;
 
 			if (ntace->sid.num_subauth == 0 ||
-			    ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+			    ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+			    nt_ace_size < offsetof(struct smb_ace, sid) +
+					  CIFS_SID_BASE_SIZE +
+					  sizeof(__le32) *
+					  ntace->sid.num_subauth)
 				goto next_ace;
 
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
-- 
2.53.0



