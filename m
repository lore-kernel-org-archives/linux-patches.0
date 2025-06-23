Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1AF221F34;
	Mon, 23 Jun 2025 21:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713209; cv=none; b=juh6fgYmfDzKrdS2MG2AA34ZzNTmAQH6oC6CeCV+keMqs9pvzplurSOVjoL5DPJUxgP2EyhI+fbNEecZWnfcMK1zzF8E+83YAgEy3HaWLuhGEnwLIwHuDh31LI5fim8I80uVQR569BZgi8FPZHUGw3ls8Tk4JWmjV3XJCJyrDLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713209; c=relaxed/simple;
	bh=pCSuUchl7TkKHEy25ai5t6KZ+wpmSks7wF8YXm/v8r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InJRHnGni8sSwkw8x7nndXlscUcmuZc5DwTBkhkCkeMdne1YESjOBRebgA9Y55szoeZg5bbp+LU9Uf8bwnGMh3T6LnMrZyoAvFczwXKcYy9YLe8DRGeN0gSxMeUBtkHlBWRsP5RiIkj4nxGNMj9Zuk9LFycNlTuaDj/HsCJrfdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6QhyzYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6QhyzYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CD4C4CEEA;
	Mon, 23 Jun 2025 21:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713209;
	bh=pCSuUchl7TkKHEy25ai5t6KZ+wpmSks7wF8YXm/v8r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6QhyzYppftl3R2gSGJFmw8siSoH+l0tohNxVxQju1ABhqDoMf1qJGk+DiHZ9FouS
	 W6NG46F2dNO41EdvqFhuWtkIxoxP2N/pa2iMcu0FhQPwWLB8a7HobLzrqNz6jNQGH4
	 lpYzzmt5Rm+L5MxGqJBZe1vU+pNQ1mtZNBiIZneI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 032/414] nfsd: Initialize ssc before laundromat_work to prevent NULL dereference
Date: Mon, 23 Jun 2025 15:02:49 +0200
Message-ID: <20250623130642.829629561@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Li Lingfeng <lilingfeng3@huawei.com>

commit b31da62889e6d610114d81dc7a6edbcaa503fcf8 upstream.

In nfs4_state_start_net(), laundromat_work may access nfsd_ssc through
nfs4_laundromat -> nfsd4_ssc_expire_umount. If nfsd_ssc isn't initialized,
this can cause NULL pointer dereference.

Normally the delayed start of laundromat_work allows sufficient time for
nfsd_ssc initialization to complete. However, when the kernel waits too
long for userspace responses (e.g. in nfs4_state_start_net ->
nfsd4_end_grace -> nfsd4_record_grace_done -> nfsd4_cld_grace_done ->
cld_pipe_upcall -> __cld_pipe_upcall -> wait_for_completion path), the
delayed work may start before nfsd_ssc initialization finishes.

Fix this by moving nfsd_ssc initialization before starting laundromat_work.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -406,13 +406,13 @@ static int nfsd_startup_net(struct net *
 	if (ret)
 		goto out_filecache;
 
+#ifdef CONFIG_NFSD_V4_2_INTER_SSC
+	nfsd4_ssc_init_umount_work(nn);
+#endif
 	ret = nfs4_state_start_net(net);
 	if (ret)
 		goto out_reply_cache;
 
-#ifdef CONFIG_NFSD_V4_2_INTER_SSC
-	nfsd4_ssc_init_umount_work(nn);
-#endif
 	nn->nfsd_net_up = true;
 	return 0;
 


