Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918953E49C7;
	Tue, 21 Jul 2026 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658083; cv=none; b=Udyq8y7FDbk0rlSeUkG0VAi5zj56XnEOZL4f7AnHy3x7Tffovyr5selfrJ+sN0N+d4e+/n6evddrf/7CBkNanW27fJj0vlCwaOsp75Ianlczg24QDDaM8v6ImyGkDUstbb0WTU5JKp2sqdNT32qFV1UR5Dr/efvwVMcaAc/hG3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658083; c=relaxed/simple;
	bh=ZPpFnWUSjDn7PWyImiI9nZXmOngI52A/yKc0dmczNiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwveXJD+6sJumYGQGyum++5ObkeAQPn3ZiEg+ezsObeGeLdZ2cXvzFaT1rsqYaeplwzzTPt9/NyKiP0UiwxLM6b4eUlHc1mM3dRbV4P4LMUJRyEkJkA83K23+E9h5ua3ipAuVxJ3mz1Qu2tQ7oebvp8EJZlni03+galI2Cd98Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/XavE2m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/XavE2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBA01F00A3A;
	Tue, 21 Jul 2026 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658082;
	bh=crnIypo4IiOT/zx7aOzjDpA5jYakOZGkKXOeC28DA4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/XavE2mZ0SBGEFqbIfXnOqm5/CrL8wfHAhM6STsBolSvSYyZcJdOyeUM0TqnYEKv
	 7wsGasWc2i+roEjoQtB4alLjvAPILcCSFASsAZVHg98a3wUDmNuOMDdQGzs1BvcbqZ
	 ta6+mzdtRVz2QAC/hwCknZrUWTb4GvmQyWjN6iGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1008/1611] afs: Fix vllist leak
Date: Tue, 21 Jul 2026 17:18:44 +0200
Message-ID: <20260721152538.067364805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit fc10c0ecf06f2981af5d04357612b00051e03e9e ]

Fix a leak of the new vllist in afs_update_cell() in the event that it is an
empty list (nr_servers == 0), in which case the old list isn't displaced
unless the old list is also empty.

Fixes: d5c32c89b208 ("afs: Fix cell DNS lookup")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-18-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 497e876301076f..fdc036c8e6af94 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -547,6 +547,8 @@ static int afs_update_cell(struct afs_cell *cell)
 		rcu_assign_pointer(cell->vl_servers, vllist);
 		cell->dns_source = vllist->source;
 		old = p;
+	} else {
+		old = vllist;
 	}
 	write_unlock(&cell->vl_servers_lock);
 	afs_put_vlserverlist(cell->net, old);
-- 
2.53.0



