Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD351FE44A;
	Thu, 30 Jul 2026 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423263; cv=none; b=rKcAhPttpKOEJGwn8sJeL2JVtso7WS+d6GVr0FIajjf7Y4kHxJuJb9b/HmVKgWBeysin7eCmIBYpCAE3jkC+RFcrlABb/qdeEk9s3/Wy2nbls5fKDIvbBmlpzAaK0cDvuP8Cs50T7iZbUeM2iLMB15YGZFt7uYY/SasyXEg/kCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423263; c=relaxed/simple;
	bh=ysLWxAqpbCrcJRDaTDwLIk68oSiMiAFO4XQVQFfYqsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsFllv/dNUPHSbfLfBwYcyMYDUsN7vwnItLh9ou/njmp3K2hE9ooO7lr4xCjmGzOEfxUhw0X07WRNpBZfwBUvLBD1ClGCgw1n9ENtb1juOfRK0F3o0tApAOpkacaLxoVC4v0RmXc8Q0Z93D3gar+2wYJqdkrr025eN2AYuZ9irU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZs+gb9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZs+gb9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924791F000E9;
	Thu, 30 Jul 2026 14:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423262;
	bh=CFswDvYZ0cnNA7gfgxAd3MxVetSBbAi11tX8Dll20hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZs+gb9rNHUoPdVJ2jANnF8PqKotymzKt5ecMT1LB5888Z1yoaUQqmafwMF2GBKvt
	 tLud2KoG8gAVpDbKzlJLrBzVN0hlpkaHHtcE+mARG1DiljFl1dlWOmW8+HZaTMGhgC
	 ZEbezCbG1FREN7vfVqnYe8QXr/g4Ct5fK1Hyd97w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LocalHost <localhost.detect@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 723/744] ksmbd: validate ACE size against SID sub-authorities
Date: Thu, 30 Jul 2026 16:16:36 +0200
Message-ID: <20260730141459.651551744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 5152c6d49e3fd4e9f2e857c57527aead752f1f87 upstream.

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
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index f8696399130889..0359cd10320269 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -743,15 +743,22 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
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



