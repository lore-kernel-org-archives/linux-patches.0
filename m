Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DC05328AE;
	Wed, 23 Sep 2026 14:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175187; cv=none; b=DIW7Hmroz8mdga/fVNVqBjr3zqF1aZr3wkmnRRWLakZXPgIlvBdwyOoforsGh3cV2oYQn9ETDPWVrGRt3aWA2+dIGc3T+dgekTdXRFW/n8wXYm1rwr7cMjVnLTKDkREGSGp08nf9QWug4xv2Zr6GHKlXpW5qz6goDGWd/DB4GAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175187; c=relaxed/simple;
	bh=jXSIwymDqb/R9txFJWyEcHyUdXXhJe6wkuzJgNyHpaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0Itqtgzbk8wH6ajwIh/7sPPXiOZQfsaJfoaf3ndodpdfugtbq2Bypp7vGJNZpvX8CGzZS0NZjCabp9HYa6jdxkrZdrNYq9qOW49tozKupPgBQC4FfHr6e1gAqMycxvX2XIrx4JyRY4KyBVCdZIkrD4LAR8ujWyEyZi4AHLvmvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYGe7LNk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYGe7LNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB67D1F000FF;
	Wed, 23 Sep 2026 14:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175185;
	bh=MeM6ZwmF9VErecpsQ5Weo2On0tkvxbSJLF11WWhFlNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYGe7LNkmHMPsBrP/HUxgRwdDupOMAflqLBlqwQw4FWIfxqlbl/wIVfvbA9EKiqXS
	 Z3UJC2Pbvy/fimCLHtrw+ex3ugstA7DEiaxWe0svRh2craiG6J5TODra/G6Js2+gHc
	 akGPFyAph6sr0EQ8GYpEFI9OXX4O6AnKQ57H0XiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.18 346/398] smb: client: fix rlist race and missing initialization
Date: Wed, 23 Sep 2026 16:07:00 +0200
Message-ID: <20260923140652.397833092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 5f270f091256da1338c3631083e15d7f83cc05e1 upstream.

TCP_Server_Info.rlist is allocated via kzalloc which zeros both ->next
and ->prev to NULL instead of pointing to itself, making list_empty()
always return false and list_add() dereference a NULL ->prev pointer.

Also, cifs_signal_cifsd_for_reconnect() can be called concurrently
from multiple cifsd threads, allowing the same server's rlist node to
be added twice into the local list, corrupting it.

Closes: https://sashiko.dev/#/patchset/20260911204446.1719356-1-pc%40manguebit.org
Fixes: df0e03a4fb94 ("smb: client: fix potential deadlock when reconnecting channels")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -171,6 +171,8 @@ cifs_signal_cifsd_for_reconnect(struct T
 				nserver = ses->chans[i].server;
 				if (!nserver)
 					continue;
+				if (!list_empty(&nserver->rlist))
+					continue;
 				nserver->srv_count++;
 				list_add(&nserver->rlist, &reco);
 			}
@@ -179,11 +181,15 @@ cifs_signal_cifsd_for_reconnect(struct T
 		}
 	}
 
+	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(server, nserver, &reco, rlist) {
 		list_del_init(&server->rlist);
 		set_need_reco(server);
+		spin_unlock(&cifs_tcp_ses_lock);
 		cifs_put_tcp_session(server, 0);
+		spin_lock(&cifs_tcp_ses_lock);
 	}
+	spin_unlock(&cifs_tcp_ses_lock);
 }
 
 /*
@@ -1823,6 +1829,7 @@ cifs_get_tcp_session(struct smb3_fs_cont
 	spin_lock_init(&tcp_ses->mid_counter_lock);
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
+	INIT_LIST_HEAD(&tcp_ses->rlist);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);


