Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7712B46B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ABBC433EF;
	Mon, 16 Jan 2023 16:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886643;
	bh=GK3uS2YGzwlIugRXPjBa5V2Q03Xx+Ft4e0L3FDl/Er0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2hkbJfM/B1ztF/TW55BRJICwrebVoHMokgLPBrCm8nDyTpkn0dvZ5hHRb0q6OCHp
	 GROe8dWQYsrOmhIqydJ7Flvq+X/gUWDuwE1f/jg71qsmvqytwYzOgb7MMU+6w2P30e
	 bPBnOOKFUfHLx3jmPVMHAECOGHmFRbX9uUkMWQ0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 507/658] cifs: fix missing display of three mount options
Date: Mon, 16 Jan 2023 16:49:55 +0100
Message-Id: <20230116154932.707328593@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
@@ -609,9 +609,15 @@ cifs_show_options(struct seq_file *s, st
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


