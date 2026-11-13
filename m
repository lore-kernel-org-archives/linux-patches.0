Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585479;
	b=SO3HR7Mr6kdOHCWCUpG7h6T1nExuydpGxZGkBTW2unMIzsAoQ/pK0eY/zaUnMApI3L10
	 pc3KjLBgra1M9M+j/cAvfRnfxHy5I85TiVln2qsczeJ6Lmmsoylc2R8H0OyzCGsGRoc0l
	 iUi6YmM9f5WFp0j/PRoYb37YaIfQslmBFT40O7ip0djY+4DmmzrcmtGZbgllEwRlxgHV5
	 yvZYLHO+imY2m8GiKOvkrbPTKws0rkP1u8+tazi6pOg3kMocvOVjT9IWm/FOdhDBrGWnX
	 NeJIV+c9ojY4iAyUP6UU5jc8OmNErW+2evwcQwafnvXI4/KyRScI0SB9R6OFJN79ThA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=utCvsZmYHXZ4Oy0lKehUKKDNO3M5xy3aq+Rfd3uWrGQ=;
	b=k7xYBqauMNQho3Y88/PP8cwZeDxGVdiKm8yn89tf/cftsSJuADrZfccpXc5qkXS1H3De
	 ynq3p2inwa521GBkMI5IcOlDomBchacFD9mMZIy1ssv4nOkjFlPruN/B0TRxmHMHssEXS
	 22sDH9bhl0MzwTDJ+G0on89OOnSNYy276VZWuTAMGaCJiZDMG1xB6396Y0TjTZLsj7905
	 M+tsxU9HtKwpFb4nwA3r4zaw76yEBRm6q00FZu9MAdI9VZQGZ+14C4p0Bl1Vi9r5LF5cD
	 4tFNnL89zgd7vaWgGrMZkFULZEVBCEwdg9kGDz5xODQW0BZMd5xDxthnhJuMF39ulKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QcetaeWC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E451606A330;
	Fri, 13 Nov 2026 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QcetaeWC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF5A1F000C6;
	Fri, 13 Nov 2026 15:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585478;
	bh=utCvsZmYHXZ4Oy0lKehUKKDNO3M5xy3aq+Rfd3uWrGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QcetaeWCHn78B4TrWIhNbg3QUVGJ47aMX3XJwiX3kyfs79SokUZaZGGZjodGrCzAp
	 AD25nu4hWNRR/TimTCF3BzJVVscRG+KeZ5WNUTzGzQa5hXVjaG9mNaAV1olBT1HcsM
	 yy0TYp5Q3N+Qem6jFTRa5JKipIBUXzIqUY7ZkjbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 130/507] ksmbd: do not read past the DACL in the access denied debug message
Date: Fri, 13 Nov 2026 10:47:14 -0500
Message-ID: <20261113153758.854839979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index f8bd8e2ed33e5..b95f8c2d6f3e6 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1665,8 +1665,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	}
 
 	if (granted & ~access_bits) {
-		ksmbd_debug(SMB, "Access denied with winACL, granted : %x, access_req : %x\n",
-			    granted, le32_to_cpu(ace->access_req));
+		ksmbd_debug(SMB, "Access denied with winACL, requested : %x, allowed : %x\n",
+			    granted, access_bits);
 		rc = -EACCES;
 		goto err_out;
 	}
-- 
2.53.0



