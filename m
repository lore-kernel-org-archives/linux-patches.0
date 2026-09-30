Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6888E515961;
	Wed, 30 Sep 2026 17:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788870; cv=none; b=Q4zd9mdxb8O+TD3lziIuSGUG+NL85eTkroxB5KDjO85FwLVc+/5wt5/NoEcV/aS0rL0hsLt8wPoYsO0lYuxTrktY3bFS2aZSmqQ+eapBSdVQHvQGNPM1+k+59lqlLgiEqbu4M4FK9wiyrl6xuK9MrEPJlyO2eZOjHpQJ0zFCbJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788870; c=relaxed/simple;
	bh=Ztspjwxv9/6Jt2y1hYQ6Ddjffq6rHNOzp6UJU4K0M00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8Wtr4q1Mjhwj+GqxhWmX0G/e3OoENqORaOPQFAeQUiDjcD6M6UBG8qsehkyCxIsENBtamNAyG+8GnNRVsmSBfw9F9NpERVAgfki9CM1VhvwopHRmHUsGKi9pdDO/BfPIeLafU2ARSQRZTwhpHfmSJXhdEg4GXK/JuCco5G4AMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMNV9YY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMNV9YY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF371F000FF;
	Wed, 30 Sep 2026 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788869;
	bh=C2nn9KXGcdk975AwQ6MncildsLxcdys/EUIuUxhe1nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMNV9YY4LYFQ2xn8FMkYWWhnaS1+7E2PFozHZhnC1qtqmn860MjHBKKaRG+uI7gRc
	 jWVkz6QRzx1xOz/UdyzddES0L3eKPnm6vtltRXi2fgzL5xlWqUj8fDraduEl4aVudD
	 Ex+stq8q098KHYdkFF/RvRwzWylUf3BWP6PMeHus=
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
Subject: [PATCH 6.12 277/877] smb: client: fix rlist race and missing initialization
Date: Wed, 30 Sep 2026 17:19:48 +0200
Message-ID: <20260930152420.696424385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -187,6 +187,8 @@ cifs_signal_cifsd_for_reconnect(struct T
 				nserver = ses->chans[i].server;
 				if (!nserver)
 					continue;
+				if (!list_empty(&nserver->rlist))
+					continue;
 				nserver->srv_count++;
 				list_add(&nserver->rlist, &reco);
 			}
@@ -195,11 +197,15 @@ cifs_signal_cifsd_for_reconnect(struct T
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
@@ -1768,6 +1774,7 @@ cifs_get_tcp_session(struct smb3_fs_cont
 	spin_lock_init(&tcp_ses->mid_lock);
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
+	INIT_LIST_HEAD(&tcp_ses->rlist);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);


