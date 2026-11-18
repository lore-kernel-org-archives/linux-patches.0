Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058939;
	b=4scQ058WPsNIu8+hq3WOyw4HJRdSEh7FWw3BiwWmQd4tZzsMD3Ol/Jgtl6CvW2j40+M/
	 BnBCcvXUV1BWq/6OJysGl+u+oMRn4NxuaNCEfXuxHG60xWkyr4G4gj1rnszKAOHSFHa17
	 P+9PXYBRuGCq3L7erGoJV1jCLDHIwORLp/3r+qnRr8FGNW4FfP4rokJNHgEj3BRB6RKMM
	 JBlC62y8HblYWqZ+5pS0SmNgsIhMgj4ML+CYQV0mfvfGuVniHYLvVV0WkUiEawcmRvavM
	 XXVv5XjBk5Oinl1Fxpq2xfhSILV09EPpo347fTTf8zo5pWdgvkoUpbYw4TUoHGcy93Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7GjEMdYahm3lyJWfjOU6zJETEcFMdzwkNviSmziHvlw=;
	b=vSoWjunTulu/7SQ9ZP+i1FjWDZ32RZsQAobCt45pdoFkg84qrodGxqJrdiqHVMevKmEA
	 ED062mW+EPgnSfFH+CIsuOwTCbtQfNqy9Nk1uxeGWw4j4683ybgg6KJrdSFzo1i6bixHv
	 9N1ZfrHuRWn5VapBVsxdowBxeIYlNP/eFQeNLpTd88tq+bN0nx5gEYRncOwby9TBv0Cry
	 mtogIAPqjhNPtHwckyykTJISiQ03QWKcMFS+yQSkzmscyiDOtDVsUT7farocpqi3T1CBl
	 WQL2LkDG4M86DtNgEhyGuou8VQkn0ZIbgIFm2b5d0X4an2P9ue7YVdhCTjurYwRfAlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xl+4oyKB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA76B60A2602;
	Thu, 19 Nov 2026 03:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xl+4oyKB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8411F000C8;
	Thu, 19 Nov 2026 03:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058939;
	bh=7GjEMdYahm3lyJWfjOU6zJETEcFMdzwkNviSmziHvlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xl+4oyKBLxaB63pEhYXPr40NBNC3FGf/aQuABMlohX1bX73EE1Uj+v15hPdqNqt4h
	 5CBBFsGk8Wl/PkazHVDkg0HG2EFJ36uX7Zr9ierl6Iit1q4BRMFoV+IMHynkfeGguz
	 2NzS86rdJW1GL464oM/532AfpBcCE7NcaGGcYlcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <bird@lzu.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0623/1848] smb: client: fix buffer overflow in SMB2_tcon()
Date: Wed, 18 Nov 2026 15:44:21 +0100
Message-ID: <20261118145941.512983253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context to match the existing MAX_SHARENAME_LENGTH location and direct -EIO return ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9380cb3ea9743..0878a6423d5a2 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1703,8 +1703,6 @@ static inline void cifs_stats_fail_inc(struct cifs_tcon *tcon, uint16_t code)
 	cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_failed[code]);
 }
 
-#define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)
-
 /* These are similar values to what Windows uses */
 static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
 {
@@ -1738,7 +1736,15 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
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



