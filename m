Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D25218734B;
	Wed,  3 Jul 2024 11:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005001; cv=none; b=b23TAKwIqwNtBVw33QtxEPTIumRf+m9XPAk5yTJYowBdxSwtZlmHatoFkD6E515J1btRbK5aE57ucjs7Uppvco7OKB0QosSNCATlncIbINN7+0EtzaCNHJ27y2pyYZZDBKKzxp54Mmp4qxK5w5HMtQhvWH/s3/1vvPrZf6lWf+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005001; c=relaxed/simple;
	bh=NzYOTrFRFnyl74o6gTUoSqxIOrpRHB/iID599PpMHyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T33VOxQNm1akpB7ZSJSGb491ebTZKL1za+a7BjmTQ02qgFSvvWab5TaQuQ7qtPZHks8STDouNMWPdh9vmyxHHvAlPHeN8+XLXRAcJKnED3Jlz13cHoCfvCZxd5NlNsvvoAqbdo2hqIvBcZCZ1eyg9oh/iEy2sk4JM/so2IXpyrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwAZPETD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwAZPETD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33C9C2BD10;
	Wed,  3 Jul 2024 11:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005001;
	bh=NzYOTrFRFnyl74o6gTUoSqxIOrpRHB/iID599PpMHyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwAZPETDhEJjY75Kr2FflUzWpHl8luKkwXPrFjKd2oAE1gAEOcSv/GNMOKj14wOBE
	 iYGik0UJvFclZ1SEXxFYkW8iPjo6m/9waww1b/BhFJEEVQb888kZlKdp6C88g/s2fA
	 lh0AeD7Gb5cddijfSC9BZWNt6Coyyf/bxurwn9W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/290] smb: client: fix deadlock in smb2_find_smb_tcon()
Date: Wed,  3 Jul 2024 12:39:37 +0200
Message-ID: <20240703102911.568246001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f40b8de2aeeb3..adb324234b444 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -207,8 +207,8 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
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



