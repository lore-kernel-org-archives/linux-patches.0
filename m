Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6EB8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9775C4339B;
	Tue, 28 Mar 2023 14:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015149;
	bh=bkusqBlP8Nhq982QU41p/F6NHnnsnifh37i35c2iLxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cul+oyDc6a4vG+WBwip62b4Y5cSwBEsYFUcglVKv0tdeKlumhDxQbbKXiYUaDen/
	 IE6JEWbRS12SQqtg6KtvGvJB2bvVD4Tl6rmROoYPrYlt2Owzson14H2ALbhP8d+8WF
	 ls93m20ZytFla1BJkh027wC6Lsxj9oRGnLBG4nB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 166/240] cifs: dump pending mids for all channels in DebugData
Date: Tue, 28 Mar 2023 16:42:09 +0200
Message-Id: <20230328142626.583129985@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

commit d12bc6d26f92c51b28e8f4a146ffcc630b688198 upstream.

Currently, we only dump the pending mid information only
on the primary channel in /proc/fs/cifs/DebugData.
If multichannel is active, we do not print the pending MID
list on secondary channels.

This change will dump the pending mids for all the channels
based on server->conn_id.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_debug.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -215,6 +215,7 @@ static int cifs_debug_data_proc_show(str
 {
 	struct mid_q_entry *mid_entry;
 	struct TCP_Server_Info *server;
+	struct TCP_Server_Info *chan_server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifs_server_iface *iface;
@@ -471,23 +472,35 @@ skip_rdma:
 					seq_puts(m, "\t\t[CONNECTED]\n");
 			}
 			spin_unlock(&ses->iface_lock);
+
+			seq_puts(m, "\n\n\tMIDs: ");
+			spin_lock(&ses->chan_lock);
+			for (j = 0; j < ses->chan_count; j++) {
+				chan_server = ses->chans[j].server;
+				if (!chan_server)
+					continue;
+
+				if (list_empty(&chan_server->pending_mid_q))
+					continue;
+
+				seq_printf(m, "\n\tServer ConnectionId: 0x%llx",
+					   chan_server->conn_id);
+				spin_lock(&chan_server->mid_lock);
+				list_for_each_entry(mid_entry, &chan_server->pending_mid_q, qhead) {
+					seq_printf(m, "\n\t\tState: %d com: %d pid: %d cbdata: %p mid %llu",
+						   mid_entry->mid_state,
+						   le16_to_cpu(mid_entry->command),
+						   mid_entry->pid,
+						   mid_entry->callback_data,
+						   mid_entry->mid);
+				}
+				spin_unlock(&chan_server->mid_lock);
+			}
+			spin_unlock(&ses->chan_lock);
+			seq_puts(m, "\n--\n");
 		}
 		if (i == 0)
 			seq_printf(m, "\n\t\t[NONE]");
-
-		seq_puts(m, "\n\n\tMIDs: ");
-		spin_lock(&server->mid_lock);
-		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
-			seq_printf(m, "\n\tState: %d com: %d pid:"
-					" %d cbdata: %p mid %llu\n",
-					mid_entry->mid_state,
-					le16_to_cpu(mid_entry->command),
-					mid_entry->pid,
-					mid_entry->callback_data,
-					mid_entry->mid);
-		}
-		spin_unlock(&server->mid_lock);
-		seq_printf(m, "\n--\n");
 	}
 	if (c == 0)
 		seq_printf(m, "\n\t[NONE]");


