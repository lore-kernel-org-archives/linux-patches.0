Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D8F5328D1;
	Wed, 30 Sep 2026 17:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790009; cv=none; b=FQ51rHv0KftYtkeCFX9bEAVRETR+lIfglwfaeirM/Z10NBFS1RKLnAt02sHflGAu7Vdns6jrtpxg4Hbfn6Pu3xHwMIAWXy9ZZcSPY3SZ4YGl86Q9eplhnhA8xq2HTP/V8yKKuHBDiixQG/wam402WmXX2DxH9V6Udspph2RGgng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790009; c=relaxed/simple;
	bh=upRiNWSOkTSAIK24KQcm+XrTZAZmptqxuQjjUXxVwy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRoyZUUm8K3vlw5T5iYwMIc/KIeB2ygg2p2XlN0PKE5BIqjTwDap20ldhjjHC5blvheQcYST1jCi3n1lY51qozkJg39Q40Hjq5vdhLcgypBS5kkRVRG47vqUWLSnzHpvczASkWMVUQiL9vY81u/SE03yDFW2HXIZtxXK5zKUvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rz0FWNGr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rz0FWNGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8AB1F000FF;
	Wed, 30 Sep 2026 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790007;
	bh=T7qIDphhF0+qxmVAeXgDKfln5l4nwY+MW2iLx0aWnOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rz0FWNGrMFcZ+20y6UF+X0CWZ3p+oDYfX+afxMsdnPAkMO/8Wd457Yff4C07FF/QO
	 dXJf3SGfGxIYkc7/BbFj+jUeGwYiEv8YSfMYPkhSPXE05200A048MeaonE2J29tqaC
	 g2azVnXVZix1dzsTbtdj2TNpzY38uTGjMd+1/438=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 641/877] nvme: add missing SRCU grace period in error path
Date: Wed, 30 Sep 2026 17:25:52 +0200
Message-ID: <20260930152428.487646575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit ef248d5de4469fb6bbaf8dbe0c4c47800080d648 ]

nvme_alloc_ns() error path at out_unlink_ns removes ns from the
namespace head siblings list with list_del_rcu(&ns->siblings) but
does not wait for SRCU readers before freeing the namespace struct.
Multipath code iterates the head->list under srcu_read_lock() in
nvme_find_path() and nvme_mpath_revalidate_paths(), so a concurrent
reader can still hold a reference to ns when kfree(ns) runs.

The normal removal path in nvme_ns_remove() correctly calls
synchronize_srcu(&ns->head->srcu) after list_del_rcu() to wait for
in-progress readers. Add the same grace period in the error path.

Fixes: ed754e5deeb1 ("nvme: track shared namespaces")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ Adjusted patch context to account for missing last_path reference-counting code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3974,6 +3974,9 @@ static void nvme_alloc_ns(struct nvme_ct
 	if (list_empty(&ns->head->list))
 		list_del_init(&ns->head->entry);
 	mutex_unlock(&ctrl->subsys->lock);
+
+	/* guarantee not available in head->list */
+	synchronize_srcu(&ns->head->srcu);
 	nvme_put_ns_head(ns->head);
  out_cleanup_disk:
 	put_disk(disk);


