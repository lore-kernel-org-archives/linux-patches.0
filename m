Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCA544AB91;
	Tue, 21 Jul 2026 22:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674029; cv=none; b=mqYhfvw8u00Z0ri1l+Y4OuAS0t+VjwNPvyuj7pswlvNkaBMmPurLQZ/M8P9ez3yOPW2qS0Ga9micIsYEa4l/biQFAy4+B4WK8RDvxv8B+j7x68xVl1Sp8oui284Z+G5tfmRcghdNGs6Mk4lKWtCB2aIyDPwoJXLA7VrEuygXtP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674029; c=relaxed/simple;
	bh=hhVAQxWDkSRUTNTtwGwXwvdII9J1fZAuPPrpSFm5yVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/8hC1OkNNkCeZCAifYHYyjFdL46bs8Aa51HWeKxlNJ7beAVOsvTeaCsT9thtmu2wQBc98vIoFf9+MASB4qbxGzCJ/lHuVJh75E1JaiVKT7SghG2oU/IUeug5gFboXsCV5Am9ssdVscjs1ZwYMUJQK2cDYRcwPqGnFsz7kbwPOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6UBR3TJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6UBR3TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316081F000E9;
	Tue, 21 Jul 2026 22:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674027;
	bh=ZpZd2TkubbS2VLzYCh4oCsyVG6K/yQia3Xq49jxPhNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6UBR3TJZ6/VTLrQ5PY1D44WuimM5gR6cq/V6MO3ogtIZK7Lv3wA0xrnCk49BxhpN
	 t0hLQXLvLZYU9097HKfa5zHcBO8cdJaWWVTn824JOnlvxkVOn1p/lSvd9dB6Jt/sdU
	 mt2/9Z4GTOY3PqOImToDKz1/ghj1fEZw3VScORI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 386/699] afs: Fix vllist leak
Date: Tue, 21 Jul 2026 17:22:25 +0200
Message-ID: <20260721152404.400692527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cfd3c4dabdb2c0..7f8a13d6967b17 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -471,6 +471,8 @@ static int afs_update_cell(struct afs_cell *cell)
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



