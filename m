Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E6213BAC3;
	Thu, 23 May 2024 13:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470717; cv=none; b=CYJmQaHZ1F5KG3b2DfxmRX/hvJUT6RoAY9dhNxA7l9HfGHdg1+c5SiQiQ8y8IrNsnVDtGmEjXdsXitJJtxK78V8XUZcp9QcLFt7Z6H7WaW3dLapSLIQtzW4x3xJu7kSNULHZWfoEr8xEI6tT7FXVHaO815BMpqHR5UDkVtHLM4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470717; c=relaxed/simple;
	bh=NSpkwXX9ZFOgw9XRgENvaTmS2vi+YLsO8YaXuH9Y8lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muMbkmcsuUPyRcZE3guf8VTgNvesEuKN31fO9IepIPtbYYpCM4y87+ZECYH40XPbJ2Pv+Z3hNz3a6hCd7/r+hp723mbTqTfkfJWoG6dypj0CGAqX3lvSGBH3nyT5i2aGU06C/mTGgSuWWvBB3wVBkgRXOZeb2WxUnLDBlRafQq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjjwdAYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjjwdAYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD75C3277B;
	Thu, 23 May 2024 13:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470717;
	bh=NSpkwXX9ZFOgw9XRgENvaTmS2vi+YLsO8YaXuH9Y8lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjjwdAYdrGFqNyqJnRgN+/wM4co5JYPvv3qy5/xaqFFEzxwiisSrHFYMn7p2Dk0gd
	 3bt2uHFXl+uEPacpafVX65OitmAKfqEJEioCxG6RsMAHzuIr2o67IVt//nttWpflTe
	 ti4P7ZVxDEAp5+xQKKhPZOolDQkfIzjuozWAbPeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/102] ksmbd: fix possible null-deref in smb_lazy_parent_lease_break_close
Date: Thu, 23 May 2024 15:13:29 +0200
Message-ID: <20240523130344.885038027@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 5fb282ba4fef8985a5acf2b32681f2ec07732561 ]

rcu_dereference can return NULL, so make sure we check against that.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 7bdae2adad228..58bafe23ded9a 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1152,7 +1152,7 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 	opinfo = rcu_dereference(fp->f_opinfo);
 	rcu_read_unlock();
 
-	if (!opinfo->is_lease || opinfo->o_lease->version != 2)
+	if (!opinfo || !opinfo->is_lease || opinfo->o_lease->version != 2)
 		return;
 
 	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
-- 
2.43.0



