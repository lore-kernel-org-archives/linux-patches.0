Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967CCAD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D111FC433D2;
	Wed,  4 Jan 2023 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848939;
	bh=4r5S2G9TNj2o2zkuitumm9+llmmLGUaSHxvKX1YW4Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5t097sxDS8GAvHtcDA6P7RSbvG4yDJltlOhKXstSAsWmFn6ptjLrMd9EW4Ve9d/i
	 tNPntLkMtJNvpHQgzC/ZuYUwUf/Swvto3/DIkQ14SNfi2IFzxuOYE9ZzQ6/Pr+Htdi
	 P4toPMiNPa5S+XNxQHhuuUEPQf7adUfzQSBhOPpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 107/207] cifs: set correct status of tcon ipc when reconnecting
Date: Wed,  4 Jan 2023 17:06:05 +0100
Message-Id: <20230104160515.298684559@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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


