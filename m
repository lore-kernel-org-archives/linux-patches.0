Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1422839FC2;
	Fri, 24 Nov 2023 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/dICeDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929A5C433C7;
	Fri, 24 Nov 2023 18:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849573;
	bh=o8TsG039JWbgjco7wYLXRSuEnywK/PfufRUYz6JfeJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/dICeDk39pKWEs9V0oufBcUXtJT04a7KD4Ox4bP67lS68l1Zv+W+sKis4z5ZhyGx
	 Ra0WlUA/yxPlLfABH6F09KGignOMofneEyKGA3nWor7epDwqTfnsnK9yRYE0TBgxeu
	 0EX87Dq3HRpbFyvEQXBZiL2BUBnqemSO6CAyp/K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Ekaterina Esina <eesina@astralinux.ru>,
	Anastasia Belova <abelova@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/530] cifs: fix check of rc in function generate_smb3signingkey
Date: Fri, 24 Nov 2023 17:46:41 +0000
Message-ID: <20231124172035.208003515@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekaterina Esina <eesina@astralinux.ru>

[ Upstream commit 181724fc72486dec2bec8803459be05b5162aaa8 ]

Remove extra check after condition, add check after generating key
for encryption. The check is needed to return non zero rc before
rewriting it with generating key for decryption.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Fixes: d70e9fa55884 ("cifs: try opening channels after mounting")
Signed-off-by: Ekaterina Esina <eesina@astralinux.ru>
Co-developed-by: Anastasia Belova <abelova@astralinux.ru>
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2transport.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 23c50ed7d4b59..a136fc4cc2b5f 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -452,6 +452,8 @@ generate_smb3signingkey(struct cifs_ses *ses,
 				  ptriplet->encryption.context,
 				  ses->smb3encryptionkey,
 				  SMB3_ENC_DEC_KEY_SIZE);
+		if (rc)
+			return rc;
 		rc = generate_key(ses, ptriplet->decryption.label,
 				  ptriplet->decryption.context,
 				  ses->smb3decryptionkey,
@@ -460,9 +462,6 @@ generate_smb3signingkey(struct cifs_ses *ses,
 			return rc;
 	}
 
-	if (rc)
-		return rc;
-
 #ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
 	cifs_dbg(VFS, "%s: dumping generated AES session keys\n", __func__);
 	/*
-- 
2.42.0



