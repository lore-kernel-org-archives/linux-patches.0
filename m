Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D200D208D1;
	Mon,  1 Apr 2024 15:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987050; cv=none; b=URaMv7ohA9oUHULP5r/UszSu4TdGv4KwmXFYocVD/dro0Pt2zUjdg/rOEsCmzD3ocVBie+RoaGz2FqLOKb27bpWCrHcZmlK8W+3aZs6gbci1ysN0JZf+gOnrkGFUmuPjPbvonMgv6MeQ87miYiZEhivqmxv63y+GFV0pCG2WQac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987050; c=relaxed/simple;
	bh=0Gp5RUMY23vzRw+WxYu1Xl5hZngJ4KyiNQLdyPpQBxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbUFSXUIoBxgzueQdetRogutxWJOq3EqYRi12inHLKTPU7UAJI7IW4ikRzwZirtt8nR6cMayi/iQ6QPWxkdpCJXtnpbaQOyTrlNkUcM5hl1q6ZNJNd+ySmruWPJ7QlpjXEP1opek/DQC/cRZ5X3DxuFFb7aAhGOJyqpEGcgw3jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLwDCCye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLwDCCye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED76C433F1;
	Mon,  1 Apr 2024 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987050;
	bh=0Gp5RUMY23vzRw+WxYu1Xl5hZngJ4KyiNQLdyPpQBxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLwDCCyemU54QxIBmNkMuSe/1KT8xbYT3iu6I0rnbSfqWvQSf2XX0EYFqYBP9UQga
	 GvpJy76De9WFYObhxAyex2SVepBJt8QqKzthZC3RxyUaXrY+nq1IRRhrg4TJYJNbfH
	 lcL7D54xVkKHnjkkk7XFisMVYbfeoyhtBYG74qBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Dave Wysochanski <dwysocha@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 138/399] NFS: Read unlock folio on nfs_page_create_from_folio() error
Date: Mon,  1 Apr 2024 17:41:44 +0200
Message-ID: <20240401152553.309896528@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 11974eec839c167362af685aae5f5e1baaf979eb ]

The netfs conversion lost a folio_unlock() for the case where
nfs_page_create_from_folio() returns an error (usually -ENOMEM).  Restore
it.

Reported-by: David Jeffery <djeffery@redhat.com>
Cc: <stable@vger.kernel.org> # 6.4+
Fixes: 000dbe0bec05 ("NFS: Convert buffered read paths to use netfs when fscache is enabled")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Acked-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 7dc21a48e3e7b..a142287d86f68 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -305,6 +305,8 @@ int nfs_read_add_folio(struct nfs_pageio_descriptor *pgio,
 	new = nfs_page_create_from_folio(ctx, folio, 0, aligned_len);
 	if (IS_ERR(new)) {
 		error = PTR_ERR(new);
+		if (nfs_netfs_folio_unlock(folio))
+			folio_unlock(folio);
 		goto out;
 	}
 
-- 
2.43.0



