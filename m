Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DADF38C2C3;
	Sat, 17 Oct 2026 16:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255857; cv=none; b=phoxPF5rUejZvyAjH4/JxIMTqyxDdprNPhQdVBNIcDNfiO30Y7LQhqRQg3txeFVrGzoP2uD55s9IJ4COl+wyQortAqlLY0cSocNFzIGPMJSYYSp0xsarK80DCe7RVqTUP8J/37k5wcdKjEyYwfIvs998hoh56T8aDLP6sEDJ99I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255857; c=relaxed/simple;
	bh=TScP/nvzk94aI9PNIJWY1NRU2QWiGYpZTj74qLsvZvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwoazkDst5zO4pdvACeZrIuccOOGhmeyVYpV4r6+fWC7AQw9rJ2Yyd5HqZBHnyRWLZgkPpOR7CRRUzspULkEMsz+KDePHt7BgNv+Bl2h25yFFOvDPKgNJMlOknI/uzEZR8ajdp3SLNe33Mqvo57RmS8kaWDS+KmetVyfMz3Wvss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKOzb5A8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKOzb5A8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B251F000C4;
	Sat, 17 Oct 2026 16:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255856;
	bh=begaKhWuqbOiDdWkKAXg+fUjX8eLOU+NHGR9XXAZn0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKOzb5A8m8iW620cWiB99or+EmAfnf3fxSk2bTOwzkkHpponiYyhcdck6l6ncJ2v9
	 x+ROx9KrrJsB1ibVe24G42HnHGnYw3h5zoFoSOalkYqKDPk2F0rVIWg2+UxJ+cwfNc
	 FTcQpmHqlW+v/9rAKpr4eqkE3hQzmnA/xNdzSvAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0044/1674] smb: client: fix use-after-free of iface in cifs_try_adding_channels()
Date: Sat, 17 Oct 2026 17:38:36 +0200
Message-ID: <20261017160432.271053649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit d034e836eefd7ce75e588f7031cffbeec594f5ac ]

cifs_try_adding_channels() iterates ses->iface_list with
list_for_each_entry_safe_from(), which captures the next entry
(niface) under iface_lock.  The loop body then drops iface_lock for
the whole duration of cifs_ses_add_channel().

A concurrent interface refresh (SMB3_request_interfaces() ->
parse_server_interfaces()) marks all ifaces inactive and removes and
frees any that are not re-advertised via list_del() + kref_put(),
where release_iface() is a bare kfree().  Since niface typically has
no channel holding a reference, the list reference is its last and it
can be freed inside the unlocked window.  On continue, the iterator
advance step then dereferences niface->iface_head.next, and the loop
body reads iface->rdma_capable/is_active, both on freed memory.

Fix this by never keeping an unreferenced list pointer across the
unlocked window.  Each channel attempt now re-scans the list from the
head under iface_lock, takes a kref on the selected candidate, and
passes only that referenced candidate to cifs_ses_add_channel().
weight_fulfilled still tracks selection progress, so restarting the
scan preserves the original weighted distribution and the
weight_fulfilled-before-kref_put ordering on the failure path.

Add a per-pass attempts cap so a flapping interface refresh cannot
keep the inner loop spinning within a single tries increment.

Fixes: aa45dadd34e4 ("cifs: change iface_list from array to sorted linked list")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Acked-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 106 ++++++++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 42 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index d3619c8ab142b..35d94589013b7 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -187,9 +187,9 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 	int old_chan_count, new_chan_count;
 	int left;
 	int rc = 0;
-	int tries = 0;
+	int tries = 0, attempts;
 	size_t iface_weight = 0, iface_min_speed = 0;
-	struct cifs_server_iface *iface = NULL, *niface = NULL;
+	struct cifs_server_iface *iface = NULL, *candidate = NULL;
 	struct cifs_server_iface *last_iface = NULL;
 
 	spin_lock(&ses->chan_lock);
@@ -235,67 +235,89 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 			break;
 		}
 
-		if (!iface)
-			iface = list_first_entry(&ses->iface_list, struct cifs_server_iface,
-						 iface_head);
 		last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
 					     iface_head);
 		iface_min_speed = last_iface->speed;
+		spin_unlock(&ses->iface_lock);
 
-		list_for_each_entry_safe_from(iface, niface, &ses->iface_list,
-				    iface_head) {
-			/* do not mix rdma and non-rdma interfaces */
-			if (iface->rdma_capable != ses->server->rdma)
-				continue;
-
-			/* skip ifaces that are unusable */
-			if (!iface->is_active ||
-			    (is_ses_using_iface(ses, iface) &&
-			     !iface->rss_capable))
-				continue;
+		attempts = 0;
+		while (left > 0) {
+			spin_lock(&ses->iface_lock);
 
-			/* check if we already allocated enough channels */
-			iface_weight = iface->speed / iface_min_speed;
+			/*
+			 * iface_lock must be dropped while opening a channel,
+			 * and a concurrent interface refresh may remove and
+			 * free entries during that window, so no list entry
+			 * may be kept across it without a reference.  Scan
+			 * the list from the beginning each time and only pass
+			 * a referenced candidate to cifs_ses_add_channel();
+			 * weight_fulfilled tracks the progress so that no
+			 * iface is selected beyond its weight.
+			 */
+			candidate = NULL;
+			list_for_each_entry(iface, &ses->iface_list, iface_head) {
+				/* do not mix rdma and non-rdma interfaces */
+				if (iface->rdma_capable != ses->server->rdma)
+					continue;
+
+				/* skip ifaces that are unusable */
+				if (!iface->is_active ||
+				    (is_ses_using_iface(ses, iface) &&
+				     !iface->rss_capable))
+					continue;
+
+				/* check if we already allocated enough channels */
+				iface_weight = iface->speed / iface_min_speed;
+
+				if (iface->weight_fulfilled >= iface_weight)
+					continue;
+
+				/* take ref before unlock */
+				kref_get(&iface->refcount);
+				candidate = iface;
+				break;
+			}
 
-			if (iface->weight_fulfilled >= iface_weight)
-				continue;
+			if (!candidate) {
+				/* no usable iface. reset weight_fulfilled and start over */
+				list_for_each_entry(iface, &ses->iface_list, iface_head)
+					iface->weight_fulfilled = 0;
+				spin_unlock(&ses->iface_lock);
+				break;
+			}
 
-			/* take ref before unlock */
-			kref_get(&iface->refcount);
+			attempts++;
+			if (attempts > 3 * ses->chan_max) {
+				kref_put(&candidate->refcount, release_iface);
+				spin_unlock(&ses->iface_lock);
+				break;
+			}
 
 			spin_unlock(&ses->iface_lock);
-			rc = cifs_ses_add_channel(ses, iface);
+			rc = cifs_ses_add_channel(ses, candidate);
 			spin_lock(&ses->iface_lock);
 
 			if (rc) {
 				cifs_dbg(VFS, "failed to open extra channel on iface:%pIS rc=%d\n",
-					 &iface->sockaddr,
+					 &candidate->sockaddr,
 					 rc);
 				/* failure to add chan should increase weight */
-				iface->weight_fulfilled++;
-				kref_put(&iface->refcount, release_iface);
+				candidate->weight_fulfilled++;
+				kref_put(&candidate->refcount, release_iface);
+				spin_unlock(&ses->iface_lock);
 				continue;
 			}
 
-			iface->num_channels++;
-			iface->weight_fulfilled++;
+			candidate->num_channels++;
+			candidate->weight_fulfilled++;
 			cifs_info("successfully opened new channel on iface:%pIS\n",
-				 &iface->sockaddr);
-			break;
-		}
-
-		/* reached end of list. reset weight_fulfilled and start over */
-		if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
-			list_for_each_entry(iface, &ses->iface_list, iface_head)
-				iface->weight_fulfilled = 0;
+				 &candidate->sockaddr);
 			spin_unlock(&ses->iface_lock);
-			iface = NULL;
-			continue;
-		}
-		spin_unlock(&ses->iface_lock);
 
-		left--;
-		new_chan_count++;
+			left--;
+			new_chan_count++;
+			break;
+		}
 	}
 
 	return new_chan_count - old_chan_count;
-- 
2.53.0



