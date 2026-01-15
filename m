Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BE43C00AE;
	Thu, 15 Jan 2026 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499741; cv=none; b=jrPqslPPsBFBm4kqxVFY1Fodb+9AaczD03D/zfLV17/uGGqvDNyUwv96YFxDy6IjHQHZ7WzkO+Y2ZC8DRQ5KYFZLC9b77h1xySWGmukkWnYdUaUOSvB+Vrsz8I3aaDMB4kuxx112pYnjUD7GyNTckYjkzNBHtxEOtmPd9o9iKpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499741; c=relaxed/simple;
	bh=HUO6EHoS38Abp19yozkwumOQLi0jNF15EYKzZD7ULK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETklMx2sJ221jB85zO+8+bIUQSGCoa1a8HVKH1GcCs8d/nKgajQfu3Px5XmRK7iAeN3WGpYl2QU1l28nyMQ5AQTQiZTjNJCVUGzHCXPX8/C/P38fC72hEzz9IzVAHj2UERl1FluanGxsoBClDyaBj/lZ0hKqpOvM02NkQacKtmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOaoFs4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOaoFs4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31948C116D0;
	Thu, 15 Jan 2026 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499740;
	bh=HUO6EHoS38Abp19yozkwumOQLi0jNF15EYKzZD7ULK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOaoFs4mtqLEEQZQBSxMMG4UAXXUfszmlygg8VP8/9ukPOwzfzwexCW9+Jr+Rc0a/
	 tRSg+fIdodrqCLHl95btzppXLV4O3QJhd7myYWEouw7iTuiJMagiYk/XCW7hCIlM6s
	 yZYRXtlTL+r1CMn4GCrenSP2Z3esgO7olZsHB6fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 332/451] nfsd: Drop the client reference in client_states_open()
Date: Thu, 15 Jan 2026 17:48:53 +0100
Message-ID: <20260115164242.906088721@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 1f941b2c23fd34c6f3b76d36f9d0a2528fa92b8f upstream.

In error path, call drop_client() to drop the reference
obtained by get_nfsdfs_clp().

Fixes: 78599c42ae3c ("nfsd4: add file to display list of client's opens")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2802,8 +2802,10 @@ static int client_states_open(struct ino
 		return -ENXIO;
 
 	ret = seq_open(file, &states_seq_ops);
-	if (ret)
+	if (ret) {
+		drop_client(clp);
 		return ret;
+	}
 	s = file->private_data;
 	s->private = clp;
 	return 0;


