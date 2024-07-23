Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE63F158A30;
	Tue, 23 Jul 2024 18:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759512; cv=none; b=gA3xJ3PvPPRIRG5tX+JEL86Uc3QY90BfXAEi7Fy27AdCnp94LnQkp+4es1L4OPwE+GYMtWJKvxlPhtF5ICGDtCsB2d18fKIdB5izC4V/gGaJiBSGruy3tYxKCiV7BW5t14eSRj8lJSGcphtdGXe9ob57SRXhYWc5g7kXkDfIlSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759512; c=relaxed/simple;
	bh=f0ErGEEmuvN2iMEFK3TTBILI35c/1ES6B0qfLx70Tl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOESITb3KrvQI/DfRDKG5Zc5/1zwyqZ/njeBoCzCtjYmKcmi+PiPRMeRjtnD+ssjWM40sUnSDKrk3eDO0Vq338QM8M33LWhLwqu8Ro+Oi3TJ03N4w6MG+lpWrN5sQOhq50boY91uP3TgW2MMtc8Q7sNPae6hteg+ca3kQD/Q71E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJPT5Aa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJPT5Aa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55479C4AF0A;
	Tue, 23 Jul 2024 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759512;
	bh=f0ErGEEmuvN2iMEFK3TTBILI35c/1ES6B0qfLx70Tl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJPT5Aa4SyG/aaM3SOskk9kiD1x9yCKYQH+G1SAGkiujGF9iEpljlgpyx9HTZap8H
	 Pi0DNurzcfo6jvqrd7mmRZa4yd4KZ9RsY10M+jAX4/sV8wk0n4ijXIP+L7Zh09S/2U
	 kKISaBJcTt1igQayTnr1zmn8Ctrk+gGfO1drW4mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Mastykin <mastichi@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/129] NFSv4: Fix memory leak in nfs4_set_security_label
Date: Tue, 23 Jul 2024 20:23:04 +0200
Message-ID: <20240723180406.184722764@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Dmitry Mastykin <mastichi@gmail.com>

[ Upstream commit aad11473f8f4be3df86461081ce35ec5b145ba68 ]

We leak nfs_fattr and nfs4_label every time we set a security xattr.

Signed-off-by: Dmitry Mastykin <mastichi@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f0953200acd08..05490d4784f1a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6268,6 +6268,7 @@ nfs4_set_security_label(struct inode *inode, const void *buf, size_t buflen)
 	if (status == 0)
 		nfs_setsecurity(inode, fattr);
 
+	nfs_free_fattr(fattr);
 	return status;
 }
 #endif	/* CONFIG_NFS_V4_SECURITY_LABEL */
-- 
2.43.0



