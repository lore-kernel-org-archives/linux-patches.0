Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622485;
	b=IZgOP8yH1ZvY4vdOnH/oWYymKmJ4R85nu1zBGTFlEC34qEmXT/1YcUBy++8rB0cbTVFk
	 TDJAGiRQ24aElBHu0PaeHd2fQKpll27PxIiQ9RnRVZ8nLARcS0iVglV8bcaF/UPZd3iU8
	 sfCkYG1AFHxMqicAjfN4O1tU1LSV7nwKr7sFsLGfmpMBmekpVSK+DWhpYNTdV5FrSt3CH
	 +JMOlcYnN/wq7Wg0rW4DYkXBsEkLysRG4lLoCoNlWBvE1/3fUDlCa8EXt/oWrm/xIOeTy
	 ZGe5MwiPdF85bYK+zsBFYDxakCQKETyFlt+0WlEQCmpDKA/2Xou60VppAO2pRCnU13Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=i7ghuWXl39NES6qC7AC/IxUwquCS7WvDHYvOWdMOHAA=;
	b=bvGp++hUf/nB+9z8/qrifsZeU77Mcpz/9WRlotSoG9W5Q2/zEPsp+OfKmLVZDODV6TxZ
	 bT9XyvaGi+Y2xqP2p8eojRaO8rMjMJjJqhW2fmYSgEYpPALZ9Buraj6kHeAE2JxDUzl1V
	 LPNFgQOgMUwzfkwkFi6aLEDK3j+VsDmJ2/K7hyYlNPbvYpB4zTdIKW7OsQSqiVMg2Wp6Q
	 kq9KUIYmaau913KTnF+92EKT/SRUldPKVPVpO105KOPLRem3JwOSYZeZTuMgwLrhfUpVJ
	 BkUmJ1MKGC6n7RrkTVhnZW1N7a3Z0UhyWj0zDqu8VjbIjPRwzww4LynYMnQzMTM0jQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XORtGNzq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85851606A33E;
	Wed, 25 Nov 2026 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XORtGNzq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A7E1F000CF;
	Wed, 25 Nov 2026 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622485;
	bh=i7ghuWXl39NES6qC7AC/IxUwquCS7WvDHYvOWdMOHAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XORtGNzqVsfuWkfzqRX8+ncjRpjlBkz0WwhMwW4i2M5SZv/episrm5pZgrZOgwTCS
	 K7y8cr9GofN2SptK9bnloKydhz+zH8+mKX0to89las4NhdegeBC5ZjiQX9fakJwE50
	 6kvplLtaitun/R51R1KKMXFETdhvoUG9xo8ISwbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 554/990] tools/nolibc: fix readdir_r() with 64-bit directory offsets
Date: Wed, 25 Nov 2026 15:32:01 +0100
Message-ID: <20261125143835.075169821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 00c81514ad49110574e4b9bdbc448551004161f2 ]

readdir_r() stores the result of _sys_lseek() in an int. Directory
offsets are opaque cookies which can use all 64 bits: ext4, for
instance, gives 64-bit processes 63-bit hashes, and
0x7fffffffffffffff as the offset after the last entry. Truncated to an
int, such an offset is negative about half the time, and readdir_r()
takes it for an error.

Since commit 4ada5679f18d ("tools/nolibc/dirent: avoid errno in
readdir_r"), readdir_r() fails at the first entry whose offset has
bit 31 set, which on ext4 is usually one of the first few, and returns
the truncated offset as the error number. Before that, only -1 counted
as an error, which the last entry always hits: readdir_r() then
returned errno, usually 0, without filling in the entry, so the caller
got the previous entry a second time and never saw the last one.

32-bit processes get 31-bit hashes from ext4 and are not affected.

Keep the offset in an off_t.

Fixes: 665fa8dea90d ("tools/nolibc: add support for directory access")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260925211600.119116-2-danishkhateeb03@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
[ sashal: Renamed _sys_lseek() to sys_lseek() in the readdir_r() hunk, since this tree still uses the older helper name. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/dirent.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/include/nolibc/dirent.h b/tools/include/nolibc/dirent.h
index 61a122a60327d..be0eaefea7a41 100644
--- a/tools/include/nolibc/dirent.h
+++ b/tools/include/nolibc/dirent.h
@@ -67,6 +67,7 @@ int readdir_r(DIR *dirp, struct dirent *entry, struct dirent **result)
 	struct linux_dirent64 *ldir = (void *)buf;
 	intptr_t i = (intptr_t)dirp;
 	int fd, ret;
+	off_t off;
 
 	if (i >= 0)
 		return EBADF;
@@ -86,9 +87,9 @@ int readdir_r(DIR *dirp, struct dirent *entry, struct dirent **result)
 	 * readdir() can only return one entry at a time.
 	 * Make sure the non-returned ones are not skipped.
 	 */
-	ret = sys_lseek(fd, ldir->d_off, SEEK_SET);
-	if (ret < 0)
-		return -ret;
+	off = sys_lseek(fd, ldir->d_off, SEEK_SET);
+	if (off < 0)
+		return -off;
 
 	entry->d_ino = ldir->d_ino;
 	/* the destination should always be big enough */
-- 
2.53.0



