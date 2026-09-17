Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D920A4E73BD;
	Thu, 17 Sep 2026 15:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660551; cv=none; b=AUJ6okLLus6Kb2G1tELhEHCsSuALV4hiiw9yDBbZuHnGEOxFkiYraaPoBTSObp+mJny+903Z5Bd+okZ+wRwzsTys1g9Qf7jlbrU3mlWSaeLn8sT5ko5OHg6LnGFZ+3JiLBf/JPyaEqbxikPuh5sHsZvPHebK82HP9/NHr4DjzDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660551; c=relaxed/simple;
	bh=vrrmJ9oY216gVgRPCFssNyMMpPZ/X984cWI/wL7o09I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lohByQeMTXHOY2HGeOuObrzFC2OQ1961IVszCwP4GnvdqXIN963+RMMjDB6Dq0ScZ6PujKIZJ1QICq/OjTr3F3PFvcPYC/ciG6KuSgMuqnDvqaUqT3m7CiOa6ZaiIZiAc6Ri6zT+WPMWUP5ZaXcJScOtrLVjopmAN43env0qSgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjuN+boy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjuN+boy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DBF1F00893;
	Thu, 17 Sep 2026 15:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660549;
	bh=+soOy404VatnP+fT3K94LEyINuhM2qw8dxT1Nrh4wXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjuN+boyGwiLFkF9jbjvcJPDWczs70bmySiq4t6ZjVPSj5fMYzxqNmXoR3bEeU23q
	 guWEOoJDYL891Is/N8ZH5EV+VylBd/w1wKNdsmWaW2v3oDRNa2xRaHviuGeFn6M6ym
	 +Fzk+787i+DDQsRuB9z2KiralT5pWFyyogepOCHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Lesuisse <arthur.lesuisse@ulb.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 630/733] smb: client: fix uid/gid override in getattr with posix extensions
Date: Thu, 17 Sep 2026 16:15:38 +0100
Message-ID: <20260917151408.263928590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit cf4d35896621b7298eef51b7a465e5c0cb22f670 upstream.

When mounting with 'multiuser,posix' options, cifs_getattr() overrides
the server-provided uid/gid with the current process's fsuid/fsgid.
This is because the condition only checks for unix extensions
(tcon->unix_ext) but not posix extensions (tcon->posix_extensions).

With SMB3 POSIX extensions, the server provides real uid/gid values
just like with unix extensions, so they should be preserved rather
than replaced with the caller's credentials.

Add a tcon->posix_extensions check to the condition so that uid/gid
from the server are properly reported in stat results.

Reported-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
Closes: https://lore.kernel.org/r/DB9P190MB2012266F6B8DECBE5D26A1798DB52@DB9P190MB2012.EURP190.PROD.OUTLOOK.COM
Suggested-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2988,14 +2988,14 @@ int cifs_getattr(struct mnt_idmap *idmap
 		stat->attributes |= STATX_ATTR_ENCRYPTED;
 
 	/*
-	 * If on a multiuser mount without unix extensions or cifsacl being
-	 * enabled, and the admin hasn't overridden them, set the ownership
-	 * to the fsuid/fsgid of the current process.
+	 * If on a multiuser mount without unix extensions, posix extensions
+	 * or cifsacl being enabled, and the admin hasn't overridden them,
+	 * set the ownership to the fsuid/fsgid of the current process.
 	 */
 	sbflags = cifs_sb_flags(cifs_sb);
 	if ((sbflags & CIFS_MOUNT_MULTIUSER) &&
 	    !(sbflags & CIFS_MOUNT_CIFS_ACL) &&
-	    !tcon->unix_ext) {
+	    !tcon->unix_ext && !tcon->posix_extensions) {
 		if (!(sbflags & CIFS_MOUNT_OVERR_UID))
 			stat->uid = current_fsuid();
 		if (!(sbflags & CIFS_MOUNT_OVERR_GID))


