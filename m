Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208514;
	b=YBSIjf9A8/DWXy9g6PoD1Xh3hmUc730gAAHOlETkYdWIdF9pfAG/xaIBuMSap87vV6XX
	 vGjPn3Ah0WzCX6QJjN38g7xaaj/zGdymeCMGDdaUZvChdg6M8w6GvMcUbsKtY3zMufwjE
	 uIN9yEuZp2MzVuLe1pCr9twhLeWljXtBXjMBKnTV43sN81m5fHVJtEpzfQmnvg3J2r2Nr
	 ItUtvRp3b/ev/meye0OE+U1EfxfXaN3oAhfnn0iN8r6Rm1VxLPYB0JAeYtiWT82d8h67e
	 2z/FMFOP6pg7sYxbQw3EcWANjcayc8cOPJDnVnkUqmSBbIem4V/yOIURTPM8H5aJwAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c9CUStdlUMhP8+gNVcqrRZ1zKqPdNcHYKQwiOji3TxY=;
	b=FaAAipxY0Oovm8XdzXwOOOYtzO8D3X1OsUMJRtuFlmYy/gg0bt+9BfdLUTkT39KSxjDZ
	 wpUSpMTq4jTC/gMEmCFJHMleW3I1XbiJUFCiCFLREGslIjDVisY5Yii6M2hmk3KS5lylo
	 EqQH0ts/sgjztym2XQkVp4/7h+EQaWqOE/K8oNC6RV72MwbbpAfawRrDc+dS6Hv3YEdyN
	 /N0d6rKFpfJM3jNWKO4Da0pWt/VhNb/v+KeWqaAlvdvduhM3Np3ZGpje7pFh4aOnGETRg
	 iFQH6+qd/5imLTzbogNhYdr8uBeMyQvkk6XZj7D0ZlyTYLI3dVctwNgcil6f5Re0KNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNzi83Xb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE67606A31A;
	Wed, 28 Oct 2026 17:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNzi83Xb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E671F01825;
	Wed, 28 Oct 2026 17:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208513;
	bh=c9CUStdlUMhP8+gNVcqrRZ1zKqPdNcHYKQwiOji3TxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNzi83XbKpV1aLE3LlzbEkTQoa9n8tI+sEHA/aMiVgnAPuyHfmPvZ2s7b4/y6t1aX
	 Ley8tX3lcY6RIHLlIEehK7BTnAKsMN9dVUqppA1mZb6I3TFABPlYVsPRSwsf58sZF7
	 F4MlqgAa3Zywt35m04pLXq2829E7LykQK9Vprjx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/516] smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
Date: Wed, 28 Oct 2026 17:54:15 +0100
Message-ID: <20261028170005.959842282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 6bd360447941357e959414a525aa62576a448116 ]

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFLNK == S_IFDIR | S_IFREG).

Clear S_IFMT before setting S_IFLNK for native and SMB1 symlinks.

Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ Moved the fix from missing reparse.c to smb311_posix_info_to_fattr() in inode.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index b11a919b9cab0..be31bc04a7125 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -632,6 +632,7 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct smb311_posix_qinfo *
 	/* fattr->cf_rdev = le32_to_cpu(info->DeviceId); */
 
 	if (symlink) {
+		fattr->cf_mode &= ~S_IFMT;
 		fattr->cf_mode |= S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
 	} else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
-- 
2.53.0



