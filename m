Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038924;
	b=GzrhvyECg5YzJPfeKoI6Jq3pjSs/DWvB5XeesNGqVvell9tHZ3gR7f7G7ZXbptSkcolM
	 YrfhiReJJ4yGOnHUcXjlnLpHxafBADBOsSfqvLCp3TrsV8EBj91RIsVW1QeF2t8JDgDXT
	 RTW1l0LMuFbfONoSYZEdez+78Lq2zyYX1ff1ztaD9SqSxcNaHV02XSbNzcazmPbb66fc0
	 IZ3aWrRGW7u1cezpxIbu6j3Viju1TOuJjLpKXk+kQNTgYATxaKDissgWouKh9E0meBK11
	 2TiZVhG/PiEw5J5skJf9ZAWJdAgG6dpDmUQUqnLV6OsZ8gliVm7X/MBCWXORRBAzbDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgQVQAlbQMjHVpaoxtU/ZaWlDV04TxuNv7DHwfcp2do=;
	b=S87C9h6g4jLVXJyoicyIEvf/74QYnbJmu8QPRG5jdveoqbd2jznCKKT4elKYrHAS5iaw
	 +r2s52dyrCBFRDdBdKfs6gJX9xQT2dKIzWU7a4CJ+sriBRGrxDiFc9hVjR9hC/Xaeku/A
	 3wB4MI+Uv5xAzQAsWh4yS+DEIO59K/I5q0FJQ23UCa7E3Mz2OwNUpqcZ6zFO/36dWF5Fh
	 G3SsXBYij9zJ7goQNnDhQXV+Fg4b7BSZ74MgDHKegQ0KB0jriVCycViN4J04dd/57zjXQ
	 jWxbCewaNcW+wKPmj8enF6A2FwgNf/qOw9FOUPrPGo7KFvtj+iBgLqyWDp0P6o3ZPRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09TTy6eu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E079606A320;
	Wed, 18 Nov 2026 21:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09TTy6eu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B9B1F000C4;
	Wed, 18 Nov 2026 21:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038924;
	bh=ZgQVQAlbQMjHVpaoxtU/ZaWlDV04TxuNv7DHwfcp2do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09TTy6eu14I3nVgkovsZd8/3bKGT5XS3yhIdVJqbLI77vOYJ8O4WloI1tnNQ8jVBj
	 V0TXMzM0lbNoyYlRU2nIkjcbqDXKZKxuPmgkLHrfNL/1emA1TQgKGtoyYtx8Q0ndGe
	 F9w4igF/iCehZoR0+SKgPXHkrLceU5eCQQJePNpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1914/3318] ksmbd: do not read past the DACL in the access denied debug message
Date: Wed, 18 Nov 2026 15:42:16 +0100
Message-ID: <20261118150419.425948579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 8296a64df5448548f410fb246c1d88a93609602b ]

When smb_check_perm_dacl() falls back to the POSIX ACL and then denies
the request, its debug message prints the access mask of the ACE that
the second DACL walk stopped at. On that path the walk ran to the end
of the DACL, so the pointer is one past the last ACE. If the DACL is
the last part of the stored security descriptor, the message reads 4
bytes past the buffer, and KASAN reports a slab-out-of-bounds read in
smb_check_perm_dacl().

Print the requested and allowed masks instead. They are what the check
compares.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Adjusted context for the broader access mask check at the check_access_bits label. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 40b2e6b499457..6147322bb4b0d 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1640,8 +1640,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 check_access_bits:
 	if (granted &
 	    ~(access_bits | FILE_READ_ATTRIBUTES | READ_CONTROL | WRITE_DAC | DELETE)) {
-		ksmbd_debug(SMB, "Access denied with winACL, granted : %x, access_req : %x\n",
-			    granted, le32_to_cpu(ace->access_req));
+		ksmbd_debug(SMB, "Access denied with winACL, requested : %x, allowed : %x\n",
+			    granted, access_bits);
 		rc = -EACCES;
 		goto err_out;
 	}
-- 
2.53.0



