Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EB517B505;
	Wed,  5 Mar 2025 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198007; cv=none; b=sdc4WcuRQ17moU79++7IVGTjvggylEhr60a7e0v61SS0LLZ9izRCgCLJ/XaOeQIdzXazA9BMp83UTJwtyvEa3++w6Dl+Bu24MDMPgffBQUNQGr/4H2CPoahakCi9eZgE0IkJQxbJ4FEYMvk9646lcK2x8dFzQwNBtCg89EYlQRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198007; c=relaxed/simple;
	bh=HLVG3gfnVwv/KiNKPdrGOakXx9Vy2oeP/umLa3A5FLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx9xEbOkKhv5YeIR8YV3hBy9D+HZMRu9bFU/DefANREIE39Y9Ukz/wsZeq/NiOitUvz2R+3CY0ueyfvuJxYTDhMhfTdPSaB10B7AQV94XlCwzbJNCOOQPxdP5MYEA3/4fh+THdyculLspc6SoO6tP47GPbu4q6mcBCwWYbfkt/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXtU7wXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXtU7wXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F56CC4CED1;
	Wed,  5 Mar 2025 18:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198007;
	bh=HLVG3gfnVwv/KiNKPdrGOakXx9Vy2oeP/umLa3A5FLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXtU7wXoV3iZ33f23dX4cnUz1rZiEdsk5zt//Fxr1I85/Lfy1LZu3sU5YgCY8P5+4
	 SEo0ouIJ9BwhCaS5pZADDb5Z+T1G7d2M0UQJ4SH/XSc1UEVVAlOXS2xuhB1vmXwgU8
	 kG0p4PDlamw+8M8/sCwZUBR55lyeL0HUd+Ht4t2s=
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
Subject: [PATCH 6.12 032/150] afs: Give an afs_server object a ref on the afs_cell object it points to
Date: Wed,  5 Mar 2025 18:47:41 +0100
Message-ID: <20250305174505.105535129@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



