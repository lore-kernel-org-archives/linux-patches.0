Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E202143739;
	Thu, 13 Jun 2024 12:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280685; cv=none; b=Phy5WFjX/T76PBIXBseoY6LAcK8IpH/smrOxYhf14uzV5Sj8uSguWVZBOJyX+Q5ek7H/9pZsz22mqFu893b6mufj6jSbvMQxoSMs1AYqY/tBMR2xzOuTKEuX39ZyXKOeN376r2YtkeDAIkDd14DCgOZtKPXTnN+Khty3QGgTfUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280685; c=relaxed/simple;
	bh=nfefBatcsV3O9vtZvH6J+ay/qWBaMIXEhy33wdgQHAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5ihkgZuY0yH/LOdHpUuKgdqXVas/IvV1EceAYaYIxTZQmioDURwCpUkcLcLbRaTLhwODRxnSsdTm8AhJevKW3lBwbPgqEw7al4RY3DKyXBTwToU6zD8Ys+A05hIsRuqTe7G6dGHM9SV2U/efaIliP751QrMhARvLG4MEk3fjaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWVwyHYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWVwyHYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22545C2BBFC;
	Thu, 13 Jun 2024 12:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280685;
	bh=nfefBatcsV3O9vtZvH6J+ay/qWBaMIXEhy33wdgQHAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWVwyHYS8FG1iCmVkl44iI/FG7Bv1BLrWXYeQlcJ86Ta8bHLLAkgv6JPACKP75Sdz
	 cGe+kP/vgosZW9AdCcEUhM8MqTm7F+7KMeqFyB8VhHcwHznofYDfThcpyA9XDobr8A
	 KooE45T0uwp37ezQbCqoR8o5x+kWPJXX2j0FqbQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 136/137] smb: client: fix deadlock in smb2_find_smb_tcon()
Date: Thu, 13 Jun 2024 13:35:16 +0200
Message-ID: <20240613113228.581695696@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -216,8 +216,8 @@ smb2_find_smb_tcon(struct TCP_Server_Inf
 	}
 	tcon = smb2_find_smb_sess_tcon_unlocked(ses, tid);
 	if (!tcon) {
-		cifs_put_smb_ses(ses);
 		spin_unlock(&cifs_tcp_ses_lock);
+		cifs_put_smb_ses(ses);
 		return NULL;
 	}
 	spin_unlock(&cifs_tcp_ses_lock);


