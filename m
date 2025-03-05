Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F3B13C67E;
	Wed,  5 Mar 2025 18:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198536; cv=none; b=k4v9VyHGSnYKzKHhhZyOwN2h3Z/Qkm2YDVllnvOCyss1gpPysjr5uvBZFXFJYQhX8yCzZcBKxfyyBQoViCxMjZMNAMS7OhYGAWuD8rSQgMHHmvLCcwKkRvPKneKzEyEUaRJPGtx8PcX2jX8UPOdotpFX9QDZAyUk1eQwyKGMMvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198536; c=relaxed/simple;
	bh=TX/aoo435JmCXpsSjNwlFAW7+StRxx0haTiUpQs54CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRZOC5c06he2VTwTdmb/woAJEDRyIwFIvb317olBePcUjcIPnHFpbzXmCYoRH85+IwNQktA3smWGv0vVQhS5+XWpg04KRITF2ifkpjnQB0hLrHIdMPuRfH9tyC8bXLh89MPuTMHKYNEiUCKrXs+cDm/1F0eP4yMN4hSgHcQI44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxs4SWJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxs4SWJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75291C4CED1;
	Wed,  5 Mar 2025 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198535;
	bh=TX/aoo435JmCXpsSjNwlFAW7+StRxx0haTiUpQs54CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxs4SWJblZTowXuf+GR9cjdkwU3m6xs169PXnSD7kmaMKFCJKUpTkdSaKL7HSemMt
	 Tcto0eCB3F/s/6c9o8SeQQe/UxveZ+OxQEEJdSAgC+HapsRYllgQ+ADjxF/qzEX2xr
	 lgAg64exGfHxebFR2xrQ2FpWZPS+2m4ePbcu3mTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 029/157] afs: Give an afs_server object a ref on the afs_cell object it points to
Date: Wed,  5 Mar 2025 18:47:45 +0100
Message-ID: <20250305174506.464144866@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 1f0fc3374f3345ff1d150c5c56ac5016e5d3826a ]

Give an afs_server object a ref on the afs_cell object it points to so that
the cell doesn't get deleted before the server record.

Whilst this is circular (cell -> vol -> server_list -> server -> cell), the
ref only pins the memory, not the lifetime as that's controlled by the
activity counter.  When the volume's activity counter reaches 0, it
detaches from the cell and discards its server list; when a cell's activity
counter reaches 0, it discards its root volume.  At that point, the
circularity is cut.

Fixes: d2ddc776a458 ("afs: Overhaul volume and server record caching and fileserver rotation")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250218192250.296870-6-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/server.c            | 3 +++
 include/trace/events/afs.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/afs/server.c b/fs/afs/server.c
index 038f9d0ae3af8..4504e16b458cc 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -163,6 +163,8 @@ static struct afs_server *afs_install_server(struct afs_cell *cell,
 	rb_insert_color(&server->uuid_rb, &net->fs_servers);
 	hlist_add_head_rcu(&server->proc_link, &net->fs_proc);
 
+	afs_get_cell(cell, afs_cell_trace_get_server);
+
 added_dup:
 	write_seqlock(&net->fs_addr_lock);
 	estate = rcu_dereference_protected(server->endpoint_state,
@@ -442,6 +444,7 @@ static void afs_server_rcu(struct rcu_head *rcu)
 			 atomic_read(&server->active), afs_server_trace_free);
 	afs_put_endpoint_state(rcu_access_pointer(server->endpoint_state),
 			       afs_estate_trace_put_server);
+	afs_put_cell(server->cell, afs_cell_trace_put_server);
 	kfree(server);
 }
 
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 9a75590227f26..3dddfc6abf0ee 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -173,6 +173,7 @@ enum yfs_cm_operation {
 	EM(afs_cell_trace_get_queue_dns,	"GET q-dns ") \
 	EM(afs_cell_trace_get_queue_manage,	"GET q-mng ") \
 	EM(afs_cell_trace_get_queue_new,	"GET q-new ") \
+	EM(afs_cell_trace_get_server,		"GET server") \
 	EM(afs_cell_trace_get_vol,		"GET vol   ") \
 	EM(afs_cell_trace_insert,		"INSERT    ") \
 	EM(afs_cell_trace_manage,		"MANAGE    ") \
@@ -180,6 +181,7 @@ enum yfs_cm_operation {
 	EM(afs_cell_trace_put_destroy,		"PUT destry") \
 	EM(afs_cell_trace_put_queue_work,	"PUT q-work") \
 	EM(afs_cell_trace_put_queue_fail,	"PUT q-fail") \
+	EM(afs_cell_trace_put_server,		"PUT server") \
 	EM(afs_cell_trace_put_vol,		"PUT vol   ") \
 	EM(afs_cell_trace_see_source,		"SEE source") \
 	EM(afs_cell_trace_see_ws,		"SEE ws    ") \
-- 
2.39.5



