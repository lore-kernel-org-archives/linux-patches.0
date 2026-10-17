Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB143A7F41;
	Sat, 17 Oct 2026 16:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255742; cv=none; b=t1bIhhuO7xK2i0ihFPH5UgHR11OnRbP+mdz1X5d9zMhgZEMrNcnc7ldCmGrlfw7if7Z3zksbbsiEhT3OHqeOZtrDmiJDu114j/jnB4UPqRMAkQ4cUjR9ZY8TCpmiII0StN0ngNlbcsjIw5XucctjD8e32MvO8mmDzlPjBc0uLCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255742; c=relaxed/simple;
	bh=nUugFOwlYFMOtuWEPg6Xpl18rX216FZa3eNW3Cmr/pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgiycPLJGTZzHkMQqZY4kA8JqtuO5vWFajy8hLsP3/6H/SHu/ZMOVi75gUQy7ka/kSMSINBQ33cN4tW11Iva/H4yyIckyNT2f0MKYxLptLK4tGvZoX+a+H2VmL7MkLxoZIWWY+i4F7ACL07ndlLewVMiqz7rSZXMHGA8BlzRl7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHhMClQe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHhMClQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB4E1F000C4;
	Sat, 17 Oct 2026 16:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255740;
	bh=MlPUZ35hTcV++rBe1PHqRl77Ak7FpewK0YokX2RjYGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHhMClQeUQSRLPB4TK57Iw1jqauTg9mD/SosfiNGahauFV/o2szsv0RKmocjiL+7B
	 T1ifqKBZOzTncN/aDcGeNQwGz9/9C5N78aUnEmj0i1UPiJlTbuTVd3ZeWwdvZXFRdB
	 sHQZPzMT5BVvXHa1jwF2ZvA8A1S2tnW4YQrmICME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 846/869] netfs: Fix folio state after ENOMEM whilst under writeback iteration
Date: Sat, 17 Oct 2026 18:01:27 +0200
Message-ID: <20261017160058.556176896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit b6a713fd34b9498ee2164d5d3e8460732a392efc ]

Fix the state of the current folio when ENOMEM occurs during writeback
iteration.  The folio needs to be redirtied and unlocked before the
terminal writeback_iter() is invoked.

Fixes: 06fa229ceb36 ("netfs: Abstract out a rolling folio buffer implementation")
Link: https://sashiko.dev/#/patchset/20260619140646.2633762-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-15-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 4242cfc683d7c..b115f5285f434 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -582,6 +582,10 @@ int netfs_writepages(struct address_space *mapping,
 		}
 
 		error = netfs_write_folio(wreq, wbc, folio);
+		if (error == -ENOMEM) {
+			folio_redirty_for_writepage(wbc, folio);
+			folio_unlock(folio);
+		}
 	} while ((folio = writeback_iter(mapping, wbc, folio, &error)));
 
 	netfs_end_issue_write(wreq);
-- 
2.53.0



