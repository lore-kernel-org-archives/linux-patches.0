Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433A8325485;
	Thu, 28 May 2026 20:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999946; cv=none; b=ruId1NsDolnpdxFviNmBdyen+x43ijQP49Fv024/J2oAMPkPV+1DhpxkX49gwFVc4kr2XWm7lEtWgvYmsAhT/jYtVa9r5XZB8LvwFny6dqXtzKhoiw3BxS+1Fl/pGaASRRnoIxhGpMvzx2kkx4Ac+vEUKI/g1/evBUHHaSGCxoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999946; c=relaxed/simple;
	bh=keZR4lXsKQh15f5qetncjToT63x0lIfoynGRfo4T+fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyHJg0yLP6M53pGXaNxdK3NUpZBmvDBybTPLPv0S7oKBQUgHqDF/5FL5Oim7At19KWDnGyHnhifV2pqSWq2SBkCARb+dxQ2FeembPY+NeQWC+SVgiSrqeBgM12JBXKS15i+/U1TBMFHb2vHWhKZMqR1gfGFO0e/Jgy6OevDwBMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhQYhPf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhQYhPf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BEA1F000E9;
	Thu, 28 May 2026 20:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999945;
	bh=JzYYJ1KkqC2Xr6zXZu2TcxZct6YOA40ZCoLyVWNIoCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhQYhPf7H1kPBVQkCtC5frPSSttNOwRLAJMRZE8slrGc3McPpY9vzkUET5rKCdNdM
	 cVPbbqSR2ae8Dik9dRhiiDauz9TZ0B8ObYOmVPrNMw+KcbzDSvblSrpXry54F7Jx5M
	 m3wy8lBirr8ERQxGAOVOABhFG7Bxpvk7ta9nSB50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 248/377] netfs: Fix netfs_read_folio() to wait on writeback
Date: Thu, 28 May 2026 21:48:06 +0200
Message-ID: <20260528194645.559604065@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

[ Upstream commit ded0c6f1606061148c202825f7e53d711f9f84cf ]

Fix netfs_read_folio() to wait for an ongoing writeback to complete so that
it can trust the dirty flag and whatever is attached to folio->private
(folio->private may get cleaned up by the collector before it clears the
writeback flag).

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-23-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index ebaabec376326..fab3181c7f869 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -502,6 +502,8 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	int ret;
 
+	folio_wait_writeback(folio);
+
 	if (folio_test_dirty(folio))
 		return netfs_read_gaps(file, folio);
 
-- 
2.53.0



