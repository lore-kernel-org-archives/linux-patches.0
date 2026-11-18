Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053035;
	b=qlH6W7aZOZw2lNYYO48zzfwz0bH2hb8cT2OBFsvPbcOyw3RIjLW/sOEWAdHnAHjL78LP
	 gLOfC7XKULYnm/olPuujmS9CVC6MeqmgJBy5HkWNjO8CEr2hMzxOFfYjoqWB/Y5ujBaii
	 FYDhdFTWjdMCBYM9j/MAwb7oygR8oQuWjhfO3bn1I2ygMrGaGiLSRuHg8sloivNeSF/5o
	 88V/lsGOa/MHsqncWTvph7tlhhCVnzYK18F6m/MD45oLnXbOZih346hACpzehqMbj8eLo
	 NS/KB244ppTUBytBUViz/IZc0DaLPEP+RoUTLiEga111mlH4VK2AZQNZkUfnme55V8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RKJxYGURzGvw402ePAD3j0GomTfegmbU8w0bS7v+CXs=;
	b=itDb6kEab3MHa1Ad8twvtFfPxsXlGjmQfDm4aDa443EUcUA7vdy8icFk/U44MD+fYhuo
	 sLzylkWWzW62ArBcuqhIVI9ugDNfod94/QSyrTXAfZVgoRq8fRa7eSSrSgjjqeIuK2JCQ
	 kwadetcA4wpW0h77S0XvSQCdfhHshxXxNh1Bn2aIzmMNmwVRMIts6WCeMFd4qG8Em0XMo
	 DNVuPF3X5xgTwJFRfU3hoPw/xufZTH8QcQykNQIGoWujBx2f6leeIbrrDrD+X+9VzAEin
	 m5ojynNsIarqlWeOBTUKn5xDT1nXQ0tZFxXHiwuJtG1O0dKTp7GPPtK5rgbtkxUcKcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoKMgxwy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F1E606A31C;
	Thu, 19 Nov 2026 01:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoKMgxwy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FF61F000C4;
	Thu, 19 Nov 2026 01:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053035;
	bh=RKJxYGURzGvw402ePAD3j0GomTfegmbU8w0bS7v+CXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UoKMgxwyreMGtUEKRkquNpUtCfPWt4O2G8a7uNwq3q1xC4HFDdpgM/LY2Rjq941a9
	 S4ZYIy4kSIR5vn9oJa0mQIgd5TMxPQe9dC8i+zNMPt0QJfh68B2z9YG75EOrs2slrT
	 /l+bRVaQpHzf73Oi/AQP+accGcaKzDCEzGRL6iFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <bird@lzu.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0774/2214] smb: client: fix buffer overflow in SMB2_tcon()
Date: Wed, 18 Nov 2026 15:40:50 +0100
Message-ID: <20261118150042.621567491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

[ Upstream commit 73cc469b0ff7551f8537ea919709973e6dc4f514 ]

In SMB2_tcon(), unc_path is allocated with a fixed buffer size of
MAX_SHARENAME_LENGTH * 2 bytes (672 bytes). However, the user-controlled
UNC path (tree) length is passed to cifs_strtoUTF16(), which assumes the
destination buffer is large enough and writes strlen(tree) + 1 UTF-16 code
units.

Commit 62a1a439e0fd ("cifs: clean up handling of unc= option") removed the
length check on UNC mount options, allowing mount paths to exceed
MAX_SHARENAME_LENGTH while retaining the fixed-size buffer allocation in
SMB2_tcon(). Consequently, an oversized UNC string causes cifs_strtoUTF16()
to write past the end of the heap object, resulting in a slab-out-of-bounds
write. Furthermore, if a tree exceeds MAX_TREE_SIZE characters, strscpy()
truncates it in cifs_tcon::tree_name, causing subsequent reconnects or
failovers to fail.

Fix this by first verifying that the length of tree does not exceed
MAX_TREE_SIZE, returning -EINVAL if it does. Then, dynamically allocate
unc_path based on the length of tree so that it safely accommodates all
UTF-16 code units for paths within MAX_TREE_SIZE.

Fixes: 62a1a439e0fd ("cifs: clean up handling of unc= option")
Cc: stable@vger.kernel.org
Reported-by: Xin Liu <bird@lzu.edu.cn>
Closes: https://bugtracker.nebusec.ai/f/3292
Assisted-by: LLM
Suggested-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
[pc: remove unused MAX_SHARENAME_LENGTH]
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Adjusted context to preserve the existing cifs_stats_fail_inc() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 35e3be4933595..198e134b664e8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1769,8 +1769,6 @@ static inline void cifs_stats_fail_inc(struct cifs_tcon *tcon, uint16_t code)
 	cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_failed[code]);
 }
 
-#define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)
-
 /* These are similar values to what Windows uses */
 static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
 {
@@ -1804,7 +1802,15 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	if (!server || !tree)
 		return -EIO;
 
-	unc_path = kmalloc(MAX_SHARENAME_LENGTH * 2, GFP_KERNEL);
+	total_len = strlen(tree);
+	if (total_len > MAX_TREE_SIZE) {
+		cifs_server_dbg(VFS | ONCE,
+				"%s: tree name exceeded %u characters\n",
+				__func__, MAX_TREE_SIZE);
+		return -EINVAL;
+	}
+
+	unc_path = kmalloc((total_len + 1) * sizeof(*unc_path), GFP_KERNEL);
 	if (unc_path == NULL)
 		return -ENOMEM;
 
-- 
2.53.0



