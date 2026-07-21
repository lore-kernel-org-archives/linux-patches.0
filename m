Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621844248DC;
	Tue, 21 Jul 2026 19:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663317; cv=none; b=OtRhE1dKHzmi93rrErFGpd3QTSz94zAmJymYB7Yrnioeti58hyW5BlEmriXXANg20p+sKR16uO6gZGClXE9+pFIopG4V7DITPR3rWlYSiUyYxMxJYebadMqzRTRvRLd4etGntRHIEK3gepQeZ2cMhc1TnNDDYn/GjZbCt4h+Erc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663317; c=relaxed/simple;
	bh=J9jA3p1ugjnvduiqw2ZvnNAdnt5Br1F+gbKHcOstcNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuEbN1UnQUTv1/ryEo6G+ve5ThY+P8yA2J1R3NhPIYNC855zDLjksxoo+97SGODNCE8AJ+/6J03TJhFYvD9pw25dz4IAXOrCveUZnq8oN9BfVrX5/ZBjOJdq+GzTifuffatozONtY4O9/DvbT/hDO7pXO8JsXEUHKu+QfJKSUDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zORIa4xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zORIa4xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FDF1F000E9;
	Tue, 21 Jul 2026 19:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663316;
	bh=VEeb4qYaDJvt7u9+rOVB29pUBmKLZT0RukaTj9MoxcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zORIa4xPWeGVWlijyekPWiSujHwRKC8yy5yDkDLVN6LmHYXS8iHry1RCX46Y/5Jy0
	 87bEnympnfxam2u6aQupQ87ZXc8+ThONAE7AzJ8613Kcagd8RcwEwRR9i+Y3er8Nb+
	 /whu25Xr/VuzNI9Zh0ei3I0rpE+Xgf42etvi5rd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0740/1276] afs: Fix vllist leak
Date: Tue, 21 Jul 2026 17:19:43 +0200
Message-ID: <20260721152502.640000883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 1fb1f97d720e0d..ce74438b9fb821 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -489,6 +489,8 @@ static int afs_update_cell(struct afs_cell *cell)
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



