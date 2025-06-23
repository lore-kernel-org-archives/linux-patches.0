Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AF82628C;
	Mon, 23 Jun 2025 21:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713480; cv=none; b=OkFUpsG0cZAteave1/z5KjVQEPOGFy6tfq2LZxbHxnFt6ZNWXVMz5pcc8gw7Cvu2vE1Dlp7dKE9E9hjmPSYK2zl3zflPa5+w3wWBD1096eek79X7eYzdRe5N5HDTJgeXQz/YqIuZpgVPs5rIIW8S3e9fW0Smbufz+1d2J5k9lPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713480; c=relaxed/simple;
	bh=pFOdZNlm9P28zR+tAXxAxwk7rqn1jk7ac4KfOMLTtKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVtwvauhnNE56QC2DmJNwZknrum9L/48x28IADNRr//93WpjseRNaQoamy5aqHxtm/od0TBY7oC5eLDMT79dNC848trPUtExQAyzwgjm4EKKSrObZ/lGuPGosLm+/QQsRg6cA42OWqiYdLdjsc6/bkN/rikvQXJT91k0j8uz99k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7ofWMTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7ofWMTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB2DC4CEEA;
	Mon, 23 Jun 2025 21:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713480;
	bh=pFOdZNlm9P28zR+tAXxAxwk7rqn1jk7ac4KfOMLTtKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7ofWMTEHUH3/C3II8+tAMHwYatYSoLD2jJRlAMwB5IGyh/n2OkO75mxxyLxA6+EW
	 9PtE+lrMc6et6zszpa1dkdPkyF5otE4VagI62dg/kbyK4ZbhDZE9p5Bz7k4j6smMOj
	 ezmGnMn8f8RJsvPAr4IW9L721F4T3OumwsVeriLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 168/355] nfsd: Initialize ssc before laundromat_work to prevent NULL dereference
Date: Mon, 23 Jun 2025 15:06:09 +0200
Message-ID: <20250623130631.757653201@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -427,13 +427,13 @@ static int nfsd_startup_net(struct net *
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
 


