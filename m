Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEFB1DA327;
	Wed,  3 Jul 2024 11:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005960; cv=none; b=l+dZLRuT9+y3tbPuuARuO6q2aAU2fCUhLPdZi2FR1esV7SXHUusAo5ER1ZAaQR6Yo6d7QWzi00j0Xkfsgn/KI0rYK6Y64QCyJz7XKTJsjMCsOkGPSWgdgWpbdt1+2YHiMuys1CI0AocPkMiChxAtSCPo/MaT6kuDvT8iYbVdHp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005960; c=relaxed/simple;
	bh=5Et5hwzlAkGXBEURLttI2o7OUupuWvUe7cLnNIcDYd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvFNywmkkMgDDE1KUbUHL3d9qR7QYM0JG0o8NFu/o7GRkp3U3mfYfIG7ZlHb2UXGcd4a1aZ30eTGsKhWljaV9MW+PrdI6uni4zCF3ZgZfZjeKkDp34FrYbx7SQ/zSdFX4UzgX2bilSbQsVMYIIbGaJPpAT6Ql2+bIm7wQQrC0JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ghf65vTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ghf65vTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CE5C2BD10;
	Wed,  3 Jul 2024 11:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005959;
	bh=5Et5hwzlAkGXBEURLttI2o7OUupuWvUe7cLnNIcDYd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ghf65vTrk5Rt9EjexwwzUnNYh4OwKs4B9A+vDY25MF5OhUcpf39Ja/b/GODDCxBv2
	 /I9L5scX+cdEv7hRSXxuTARrqQDJY9iqjoB07BDnzWHPhHWpwF23U+W3XMpSUL7TiE
	 +9E+FUuLQHqv0uoaZ3dOtODAZJuCQrCXGwidJ5FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/356] smb: client: fix deadlock in smb2_find_smb_tcon()
Date: Wed,  3 Jul 2024 12:39:50 +0200
Message-ID: <20240703102922.726381965@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 02c418774f76a0a36a6195c9dbf8971eb4130a15 ]

Unlock cifs_tcp_ses_lock before calling cifs_put_smb_ses() to avoid such
deadlock.

Cc: stable@vger.kernel.org
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 0f2e0ce84a03f..ffae3a7f46ce4 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -194,8 +194,8 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
 	}
 	tcon = smb2_find_smb_sess_tcon_unlocked(ses, tid);
 	if (!tcon) {
-		cifs_put_smb_ses(ses);
 		spin_unlock(&cifs_tcp_ses_lock);
+		cifs_put_smb_ses(ses);
 		return NULL;
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-- 
2.43.0



