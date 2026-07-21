Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ED03DDB19;
	Tue, 21 Jul 2026 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653577; cv=none; b=o5wciE5WaOw9vKKbSRFiMJzFsLrMZtHrU6JAF8Up5gTZA/6vjb6rP2vMRfPKrRJFmL3wlQLJ9hCXq5aBv0cpLJkmWflKlfTSAFOsex3wUSSgAzhcQEWIPVlsau0S7QzechPautp/+cD2t6clpKHVfY9ApYEVs9kHUGaPr4QoQlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653577; c=relaxed/simple;
	bh=8afvkG3HzUhlIs96Jdl7c+/cTj/5wTfSPw29ibcatvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfPdj9BYDPGgSxBdiR01rIFV0ZVoHyONJfvwApvEOFIAH7n0Daq16T2BdEr4qIjZpLCv1d6Ut32iHE+JJM8gpy7k+IeO+22k8o6POT1v5S3l7l6keYs2SQS402aqZkZUOR9Fdtp+o/1Xxqv+i957a7rIjGYz/wjuwvO2BmSqzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WualbsaR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WualbsaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A721F000E9;
	Tue, 21 Jul 2026 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653575;
	bh=ackawq4vyhksTxAaLdvBS7PCRI9MnUSeFPYkxQ5SsEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WualbsaRn/z+Pq5KAiBgMgkej31ULh0Dt0Iwq7zBYz9wgivYB52kMn7hub/GnLN+7
	 VFIm7jR6nK6Y1VUspJjYiry8M5dGqdzHsVRWKGp2i7TlDkuRN00orb5l9XWX8RSQ3n
	 8wjIMXhOfh/iNHW/gr3LqtkpGlOf0b3lkNqJM1jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hillf Danton <hdanton@sina.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1377/2077] afs: Fix misplaced inc of net->cells_outstanding
Date: Tue, 21 Jul 2026 17:17:30 +0200
Message-ID: <20260721152625.295046493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit c9c3b615a462a4023bd148f02c564e175ed10502 ]

Fix net->cells_outstanding being incremented before the check for failure
of idr_alloc_cyclic(), leaving the count incremented on error.

Fixes: 88c853c3f5c0 ("afs: Fix cell refcounting by splitting the usage counter")
Reported-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-12-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 9738684dbdd268..e0fab1609f2787 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -205,11 +205,11 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
 	cell->dns_source = vllist->source;
 	cell->dns_status = vllist->status;
 	smp_store_release(&cell->dns_lookup_count, 1); /* vs source/status */
-	atomic_inc(&net->cells_outstanding);
 	ret = idr_alloc_cyclic(&net->cells_dyn_ino, cell,
 			       2, INT_MAX / 2, GFP_KERNEL);
 	if (ret < 0)
 		goto error;
+	atomic_inc(&net->cells_outstanding);
 	cell->dynroot_ino = ret;
 	cell->debug_id = atomic_inc_return(&cell_debug_id);
 
-- 
2.53.0



