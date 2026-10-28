Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210632;
	b=AV8RgfMA2/ZqMeI0VGevVIMqpm1rNccLBALwehiVU5bqX3UQAkZ+5WxxZeDDyetT+ttY
	 6w3SaLFHjvNvgVI8uUFKgXoonGrFYtmYfBNls9u5YuuugRYT1UTQe792J52RajyhxcSIg
	 dptBR5O7KfuYLbAwv6KO7/iuHWqAn9JpD1JgAXi9m3iFV/037WCaJJwEdTd3perm0Cyz7
	 CQT1BwooVwHWK4ykZ0I5vPHk6xN9QZThIJHQMNhPkuRVnUpfkumVyDPWjbRgXbvgwWD28
	 RiPCTCBOIGofiCQXmTaS4fQUfDd9IEqcTcD1a2yF9nX84kgVXoocBElatJOtuDj9Ryw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pOS/6ZL4KoFnlUc+2dxJKUmeIdhLlO7gu6lnnwbsYOs=;
	b=y8bokcNO6CeTzIfB/iCwwWmYqPv+5leq9ddS3Aczt5wHBmrC9EvjZ8RbcDGct+DwrX35
	 ZJtWJexGVVTUAqvK2qFH1lonticM9M2IFEZTRQyIuAaY8nKTA0MvdECMjl40wBXj7JNm8
	 kETJC4dvVnJ7kPAlf8QzX+CqaDM/iKNS88E/IKyyE6dB2oQWz4A3sySkXbxYC0d2Y1zXp
	 7jcSH+Bwa7Chd3y/t54JWeWp/uTeLux+zhZN8G350KAiQWoc8x3G0BnvOIMH4zFOE9bP1
	 oHbPnyG4HxRxNmPaZqK1RnqtyaicRo7OoMJtmoNi+fEppkcPKjoPYalGdoZ3pJMBnlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTtU7VIS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA0A606A31A;
	Wed, 28 Oct 2026 18:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTtU7VIS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67FB1F01825;
	Wed, 28 Oct 2026 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210632;
	bh=pOS/6ZL4KoFnlUc+2dxJKUmeIdhLlO7gu6lnnwbsYOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTtU7VISbeg24Qu61+xU4wAz6SMw49dSCmM36Ui/XyOL/1h+xIh2ekyLvPfH1ev0C
	 ArUqNQbUfvPTWcxT5bnF89HpjYsv+6r8J5B1GU7deLEr1Ot7s3zqHuBgMkZewL9/ap
	 5iI0L9njLa3KqQEs2fEAMuAWguPzD/fy4BIOs6uc=
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
Subject: [PATCH 5.15 095/571] smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
Date: Wed, 28 Oct 2026 17:54:02 +0100
Message-ID: <20261028170010.276699926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index bb0b172c5a74d..388904b6bc030 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -623,6 +623,7 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct smb311_posix_qinfo *
 	/* fattr->cf_rdev = le32_to_cpu(info->DeviceId); */
 
 	if (symlink) {
+		fattr->cf_mode &= ~S_IFMT;
 		fattr->cf_mode |= S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
 	} else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
-- 
2.53.0



