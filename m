Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A72C3268;
	Thu, 15 Jan 2026 17:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498363; cv=none; b=uugmklFRI+fOlZ8PKH3OQUW9AG29oKKR4oDpDCPYyVCmLwCVMgqrfcKEb+y4nYOqseF4o3e4J+7c4Fctd6/xC14vgGNGjJkx03wVEF225erg0Qg2kwejPt7bqCCZth1SurB+9MtNZElJbKifBAP+EgkufonxbIMwDfl2NfUNXLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498363; c=relaxed/simple;
	bh=tMeT0RJPnpVNv/OHJsgNjST555yg0fzDwOpLkTWHxuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J506qqkYkJNk0c4YUedpXxDXlhlozkBOsgvdbatAUjRFEcpJKFOdbJsSOT4qFSpGD8Bu9Mc6GQfPjEagaxa1V8GjbW5m1++iZoNC2fjN3z2JmW3jkz2KPm3UH+H9vSioY+ioWnebnqN3HO54mj6nC7c+O3w6osJ4Qs9IttyR3zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBvAxB5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBvAxB5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2274C116D0;
	Thu, 15 Jan 2026 17:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498363;
	bh=tMeT0RJPnpVNv/OHJsgNjST555yg0fzDwOpLkTWHxuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBvAxB5FOrcSwSct5kirFXL3olKzAQMhs5lBtdxymuTrpZD2lviV7xjZtJZV/SmhK
	 Yav2cHgn9yrKvQzJOFil3fYKQhqMQojUdNmXuvGwySeBlBb/fpbBywpZ0zrvrgkGzy
	 wl64aRZO+ymRQnps8WJcbMi/PUTNxJIfQJAfMMAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 405/554] nfsd: Drop the client reference in client_states_open()
Date: Thu, 15 Jan 2026 17:47:51 +0100
Message-ID: <20260115164300.893538828@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


