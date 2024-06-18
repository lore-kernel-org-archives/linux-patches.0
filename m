Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C907158A30;
	Tue, 18 Jun 2024 13:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716180; cv=none; b=tvJgwwRyngmCysMITKP7K4GHtADOhYTxkj9uAgwZ14pUEk5v6RH+vu6QxS6iLUW7IlvWOYWndL8mdhPcDSlmcLIwvDMX7NfRUoWblWqaaWLzP9NiUQknNnBnt2x1UoN9izUMsMd8mrNITr/8K0TNkKIpWC8lY/KBahr2fzvaf0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716180; c=relaxed/simple;
	bh=+hRkq+10G0ZWo7u9tjstZrQa6fqwgeCuc0fYgd8N+VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWFFvh4dLxAeuzgebbjToHCP8Nnm5qVwOS79rfmSnc/dWdidaiHnCuIIkpqNEyjVPj9nTQZ/qxKl/MKyB5izC2MpjTlsvSyajHo2GKnMsnoLrTFNScyWgzMzQRHAlSID4RheJAWIgUmFwYAn+eETRrCaTzLCkqBBMJk3H9kfFW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCktLvc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCktLvc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED090C3277B;
	Tue, 18 Jun 2024 13:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716180;
	bh=+hRkq+10G0ZWo7u9tjstZrQa6fqwgeCuc0fYgd8N+VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCktLvc9iyXZ6e4V8Fg6y6OfWOYBFV/+CqdisC9c36Xl0uFF7UDtLLOnsYUbzMSIP
	 UP+jff9VvHRGVzYgn6YEcITMOy++rNpgvlaGkAaAuUdtbvwPN6scoIkJ5Y9hDPjrYb
	 XgVv825Bkj59dHtxj7KJgaf4YnornHeam919usQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 560/770] NFSD: Refactor nfsd_file_gc()
Date: Tue, 18 Jun 2024 14:36:53 +0200
Message-ID: <20240618123428.916787346@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3bc6d3470fe412f818f9bff6b71d1be3a76af8f3 ]

Refactor nfsd_file_gc() to use the new list_lru helper.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index ffe46f3f33495..656c94c779417 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -491,7 +491,11 @@ nfsd_file_lru_walk_list(struct shrink_control *sc)
 static void
 nfsd_file_gc(void)
 {
-	nfsd_file_lru_walk_list(NULL);
+	LIST_HEAD(dispose);
+
+	list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
+		      &dispose, LONG_MAX);
+	nfsd_file_gc_dispose_list(&dispose);
 }
 
 static void
-- 
2.43.0



