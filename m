Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A9BAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F95FC433D2;
	Wed,  4 Jan 2023 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849216;
	bh=4r5S2G9TNj2o2zkuitumm9+llmmLGUaSHxvKX1YW4Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSZnzFQ/tO0L/px1qZmW8pNNBFTC2OQwQY7jAy/0VUU5ERtmwGCbIgm+sv1knChDT
	 3vGQiM1PUO5M3m1rMlrWZ7UD1p/5UKR7/ObpzszbtJ7OGkeyaz47lmjP8r6jZ1x/5M
	 TufNPWb8jVRSEjeGTWgnoy5twoEFIBStVoIWXeH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 084/177] cifs: set correct status of tcon ipc when reconnecting
Date: Wed,  4 Jan 2023 17:06:15 +0100
Message-Id: <20230104160510.190957955@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

commit 25cf01b7c9200d6ace5a59125d8166435dd9dea7 upstream.

The status of tcon ipcs were not being set to TID_NEED_RECO when
marking sessions and tcons to be reconnected, therefore not sending
tree connect to those ipcs in cifs_tree_connect() and leaving them
disconnected.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -279,8 +279,10 @@ cifs_mark_tcp_ses_conns_for_reconnect(st
 			tcon->need_reconnect = true;
 			tcon->status = TID_NEED_RECON;
 		}
-		if (ses->tcon_ipc)
+		if (ses->tcon_ipc) {
 			ses->tcon_ipc->need_reconnect = true;
+			ses->tcon_ipc->status = TID_NEED_RECON;
+		}
 
 next_session:
 		spin_unlock(&ses->chan_lock);


