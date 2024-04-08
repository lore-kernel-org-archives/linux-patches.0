Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA527524AF;
	Mon,  8 Apr 2024 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584386; cv=none; b=cBUsl2pTVroTb7Ei4II8CcDPK9e0nnkbses6PHl2uCPOYba5sbJyn4y5eeJWl4A9AtBBAdzBywme5HJL4pKqRRbdHMHoVMtZ0v02tJ/3xctVL7J7kT0Gul8NSpXTwtP3vGewUN1XyQ0GXTOzEhCOxhIzeZNyOv7IxnZUxUa0/Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584386; c=relaxed/simple;
	bh=MYgzvrU4PVUdmUFvZAR0KoSGap/UpC6ZsVnyXJcdeH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UT8x51vGWIp96boCKzjuMfsWl33MufyQUZoSSn27dDOXjWFO4LbCqh8aTlbnOkSy0VMNItjsvqslVJZ9DuOXpwbEgiDJRz4Sn87DNb415XFPxWztY78nCsMG1m5ir80/Ld1ZrvcBGjHU66IPP5ZKjsaxUm00neAvxOcmWurmEg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUsRmqn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUsRmqn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5034CC433C7;
	Mon,  8 Apr 2024 13:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584386;
	bh=MYgzvrU4PVUdmUFvZAR0KoSGap/UpC6ZsVnyXJcdeH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUsRmqn4on8m5jPXbpuyAcBj+HryiBrrIbQGEe4/ryVs5HDfWy526M1ggFmMvVDlc
	 AGJZOg6ub1LKc9OE5aKkAZZcweJaw1jTGd67PJ1QNiYCjkKXYzOGSh84Je4Ds1q4Jj
	 HrcRdApK+AlOYvjHzL6YmYvCrgrrQi8G/zT083Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 389/690] NFSD: nfserrno(-ENOMEM) is nfserr_jukebox
Date: Mon,  8 Apr 2024 14:54:15 +0200
Message-ID: <20240408125413.629607640@linuxfoundation.org>
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

[ Upstream commit bb4d842722b84a2731257054b6405f2d866fc5f3 ]

Suggested-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index a5ab6ea475423..fb891249694c3 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1810,7 +1810,7 @@ nfsd4_decode_test_stateid(struct nfsd4_compoundargs *argp, struct nfsd4_test_sta
 	for (i = 0; i < test_stateid->ts_num_ids; i++) {
 		stateid = svcxdr_tmpalloc(argp, sizeof(*stateid));
 		if (!stateid)
-			return nfserrno(-ENOMEM);	/* XXX: not jukebox? */
+			return nfserr_jukebox;
 		INIT_LIST_HEAD(&stateid->ts_id_list);
 		list_add_tail(&stateid->ts_id_list, &test_stateid->ts_stateid_list);
 		status = nfsd4_decode_stateid4(argp, &stateid->ts_id_stateid);
@@ -1933,7 +1933,7 @@ nfsd4_decode_copy(struct nfsd4_compoundargs *argp, struct nfsd4_copy *copy)
 
 	ns_dummy = kmalloc(sizeof(struct nl4_server), GFP_KERNEL);
 	if (ns_dummy == NULL)
-		return nfserrno(-ENOMEM);	/* XXX: jukebox? */
+		return nfserr_jukebox;
 	for (i = 0; i < count - 1; i++) {
 		status = nfsd4_decode_nl4_server(argp, ns_dummy);
 		if (status) {
-- 
2.43.0



