Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B45A6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C59C433F0;
	Tue, 10 Jan 2023 18:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375197;
	bh=dz66EUCcqx8l/oOmnqhUF/KCioY2Pcb7d43g009Oaz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flEoTsZMlzW/mASewqLd/F+I0RU7vre6im0uo2bB9cpII5a694JCN7QEFWHqSU/c/
	 Bow3CQttawSXoFNLT3FWbxtrAAf1erKU/clDU9adfUbtxGbF25bIQKzkjprZQhfC46
	 oYvS9B+nUdto/t/7vnEU2AcZUfOHYDy8qy5tUm+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 111/290] cifs: fix missing display of three mount options
Date: Tue, 10 Jan 2023 19:03:23 +0100
Message-Id: <20230110180035.617944101@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

commit 2bfd81043e944af0e52835ef6d9b41795af22341 upstream.

Three mount options: "tcpnodelay" and "noautotune" and "noblocksend"
were not displayed when passed in on cifs/smb3 mounts (e.g. displayed
in /proc/mounts e.g.).  No change to defaults so these are not
displayed if not specified on mount.

Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -656,9 +656,15 @@ cifs_show_options(struct seq_file *s, st
 	seq_printf(s, ",echo_interval=%lu",
 			tcon->ses->server->echo_interval / HZ);
 
-	/* Only display max_credits if it was overridden on mount */
+	/* Only display the following if overridden on mount */
 	if (tcon->ses->server->max_credits != SMB2_MAX_CREDITS_AVAILABLE)
 		seq_printf(s, ",max_credits=%u", tcon->ses->server->max_credits);
+	if (tcon->ses->server->tcp_nodelay)
+		seq_puts(s, ",tcpnodelay");
+	if (tcon->ses->server->noautotune)
+		seq_puts(s, ",noautotune");
+	if (tcon->ses->server->noblocksnd)
+		seq_puts(s, ",noblocksend");
 
 	if (tcon->snapshot_time)
 		seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);


