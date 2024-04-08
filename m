Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC856A352;
	Mon,  8 Apr 2024 13:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584285; cv=none; b=DUuZT8HjYzQ7FzEm8n8lAamROunmrFaWRJIRcl/dkSKQ8LM01Fi+gzOf7HBCvwQHHBLQKpJ7CUq+3bevg7CDuSUykUUIaplLcvPKjULb4UNxBJPgBZBFKJu0z/6QAJI+XaGTJCqQjN7LjqcRSEVLSjcmbqkGR8PU6nCLX6g4NFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584285; c=relaxed/simple;
	bh=B7SLUVq/Sx1SRHEWeaPAa1FtZ4MO6M/2wqweH/Y7qrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S37ZDjkiWqqtcpIsYb78ykM3Pnmh+kLSY2G5Z4ZuJPhKXNdZAsb2RyEAfFU4w3wDr1J22W/OWHTu8PTtSeOk9ANhe5KfmDU6bebYMx81m1zsBm/5ETl0Ye02NgCDXJvGBWSFaBmmN3pbDmVQCEoPiEOO9nSR+P1Qbg+LU/5nKtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGAG7z5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGAG7z5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B53C433C7;
	Mon,  8 Apr 2024 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584285;
	bh=B7SLUVq/Sx1SRHEWeaPAa1FtZ4MO6M/2wqweH/Y7qrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGAG7z5RTAsNKyPk/nQePITYEzbii4hi8gSViwtK7Wyup3XeubUAfu+P+8S0KdgQN
	 c7SlPEYVHH+73OYzGumTFSrw2MdP3FmP0Cf2olB8MkQFz39r8UQTCg3O7c4XRbM/BT
	 30e6RT+fm86Br6a5bZplgzdhUaehUr+5bNhHIKXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 351/690] NFSD: Refactor nfsd_file_gc()
Date: Mon,  8 Apr 2024 14:53:37 +0200
Message-ID: <20240408125412.324949308@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3bc6d3470fe412f818f9bff6b71d1be3a76af8f3 ]

Refactor nfsd_file_gc() to use the new list_lru helper.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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



