Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3C02CA6;
	Thu, 13 Jun 2024 12:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283084; cv=none; b=Su5bFyfGq39hRb0Sesx7DkKr13Mf7J3cVsobPKi9kVfJNCHjqZ0XI04aiFo34Wbo5iEhuWqVOEMN3zMQCPBuZi2o00I5wCMT1Rv7WelFUJcqWyIydHiJJXXU/BoFuvnUWq9/YE98IIvg9AbTJuiha+VfW1/QaDjybfFPGj+nKcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283084; c=relaxed/simple;
	bh=r0gp9cdDf2DqO03nRxDBQrm/hbWI3hBGPBnitlD5OW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdgCEQBPlP1nk93ZL3mvWlZXXP4VyrxKM5VEcx5BErBmG0p6swdtDm7JGwkpRqs3r0tpfuZtgQbeCl6tzvJHttn+8AbFexYNdsjvGG+n6Rw6P2e2jpBHmPXOg/pvJcqz7vLySttJDNXVFm88YMGXlpfNbmetk7LjjAkKd3K8NyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCkBUhYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCkBUhYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78A5C2BBFC;
	Thu, 13 Jun 2024 12:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718283084;
	bh=r0gp9cdDf2DqO03nRxDBQrm/hbWI3hBGPBnitlD5OW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCkBUhYhq/cD/wBuhLpRoWjS5jnwLTRC8WU7IFC5xwkLHpdyl/ujHrKQRk324j0EE
	 N21SvpC7E1dMcdfzxJEIAafxWlr/ngidIgx7I9NiCcY6cO/snGNF4xB4WF6zZH6317
	 t1D+IWWZd2rs8nhHbRdlNzOwfPhqiptCPZTc2GZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 85/85] smb: client: fix deadlock in smb2_find_smb_tcon()
Date: Thu, 13 Jun 2024 13:36:23 +0200
Message-ID: <20240613113217.416119879@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enzo Matsumiya <ematsumiya@suse.de>

commit 02c418774f76a0a36a6195c9dbf8971eb4130a15 upstream.

Unlock cifs_tcp_ses_lock before calling cifs_put_smb_ses() to avoid such
deadlock.

Cc: stable@vger.kernel.org
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -213,8 +213,8 @@ smb2_find_smb_tcon(struct TCP_Server_Inf
 	}
 	tcon = smb2_find_smb_sess_tcon_unlocked(ses, tid);
 	if (!tcon) {
-		cifs_put_smb_ses(ses);
 		spin_unlock(&cifs_tcp_ses_lock);
+		cifs_put_smb_ses(ses);
 		return NULL;
 	}
 	spin_unlock(&cifs_tcp_ses_lock);


