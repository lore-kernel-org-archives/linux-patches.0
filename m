Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6434654F;
	Mon,  1 Apr 2024 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989730; cv=none; b=jhP805nc69Yb4VroVxrPJR0Le45+yR56Eu99qKwJKgHSYEWAwVfrtBwXpwziEYm1LaOvmsGHR0sXSvKDsvHXMQcRYaxuOHQQ3qD1vVlUHZ6OdpGY/1uk8HKn49iDpz5Kk1NZ22BxBt7px7V/sg6Un8LgJm7g0cm6NVpBaduYbkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989730; c=relaxed/simple;
	bh=79nKVjqieIpUIclvKGLwyT/z1xpqajHgk7TEB6OSxrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqZSactPbm3sAiderGd4ISfA0dakJcJIKQCxzN4m4iQ9/EBhoNrVmvfjGDQg4R88OhLbmaRwIcnIAtNMGxsDPzcFvBZkWBJEqo//s3aRqeV7V5hUaV97cPgUOmw4CKrJjq56Bj8VsnD06BmbEtkLIvsJqhuJcRYK9/aUuTbMBwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4pVahBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4pVahBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D539C433C7;
	Mon,  1 Apr 2024 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989729;
	bh=79nKVjqieIpUIclvKGLwyT/z1xpqajHgk7TEB6OSxrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4pVahBGD7Q45esFpS4VZI0dZI8x4Cq7cEylkgkhCoaflI1p0iTIGweADW9ZFCy2N
	 J49bdrVPqgxdh5Tw3wheMbCIIT7n5/nkqH3P5doPyIgMU4w7Re57uNgLE/sgxTdsD3
	 spGIGRivBqN+JzTfAjm/4euEZyyMiYkkQl7bqCqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Dave Wysochanski <dwysocha@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/396] NFS: Read unlock folio on nfs_page_create_from_folio() error
Date: Mon,  1 Apr 2024 17:42:47 +0200
Message-ID: <20240401152551.436202821@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



