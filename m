Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C6A13B79B;
	Tue, 18 Jun 2024 12:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715325; cv=none; b=dSlP1brJBpwK1tB6kpycJ76FuFtLjxIL/RYOaOMxMGP+Jjw9bKvy5gUgYe9NQ0KvMXpAaMwEFk0wQh9FoN6j2gVSfGr/HZ16nqTDmbaWelprW6MwmSa2axYZXnjpdAypXOLppJGXI410mnAHH0TQfsx0XaXnImRZFGWT9sIvABs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715325; c=relaxed/simple;
	bh=Iz/hrYXaGeX1NqwKRpK1MCX/6Xhy+r2nfdK0R8pgbvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmJ6LnGeTxlbkLMdgS2qZz0oeGU2FkFqU+k5jTUEzYMKv1dAf3Q2t953KAXySJJi0yHeBaMFIq5cRmaT+eX4lWd3Ga7epalAmeXOUr+Xm4kSfm6kHd86Y2TOD+yzKPuWooZPpqoA2fHfOyInfUtoTw/H2OKNEpm92872z+rdbDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4P0Lrfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4P0Lrfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEDFC3277B;
	Tue, 18 Jun 2024 12:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715325;
	bh=Iz/hrYXaGeX1NqwKRpK1MCX/6Xhy+r2nfdK0R8pgbvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4P0Lrfcgsja79S4rUyY6N+V3C8+VSAZhilVpfbS9A2J7/DCQMMFH0HJ4E16uKL+V
	 mc8OSxwxIPvaSA87hYSN5TxC4jWF/FrDX6gb7tfYXDh/0r/Hwzw/Ul8dcCIYfgi/uX
	 EbArf3FzQuMFMJPDQ8ugpjpaWfwEjmmZwhtiiNuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	radchenkoy@gmail.com,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/770] nfsd: COPY with length 0 should copy to end of file
Date: Tue, 18 Jun 2024 14:31:36 +0200
Message-ID: <20240618123416.656648526@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 792a5112aa90e59c048b601c6382fe3498d75db7 ]

>From https://tools.ietf.org/html/rfc7862#page-65

	A count of 0 (zero) requests that all bytes from ca_src_offset
	through EOF be copied to the destination.

Reported-by: <radchenkoy@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 2fba0808d975c..949d9cedef5d1 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1380,6 +1380,9 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	u64 src_pos = copy->cp_src_pos;
 	u64 dst_pos = copy->cp_dst_pos;
 
+	/* See RFC 7862 p.67: */
+	if (bytes_total == 0)
+		bytes_total = ULLONG_MAX;
 	do {
 		if (kthread_should_stop())
 			break;
-- 
2.43.0



