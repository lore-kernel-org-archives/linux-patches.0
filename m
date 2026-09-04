Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13569415F06;
	Fri,  4 Sep 2026 05:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498791; cv=none; b=Kb98z0yBuFl2/KuPOgCHb7/KYsGBwaXpBQVDWYfN+lO4Sbsw+L+TcVAttS0MgLZhJt0Y3qJkE3Ru4j2KiGuoDts3xd/9owm1saAGs+oyjvGhSj/2Ei5sjMEptRs084miZX2HfhdTtQHYvykZq8AlTn3/BQB+QOBHSvyZfl23kow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498791; c=relaxed/simple;
	bh=tlv1r2SYEt9JJMD6agcv0rFDfdwwcBlhCi/6k+4jgGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAIGT+97GHJY8D1r0AsuMQRJiSzi66v/MMcQqGMhGzqD9IN+1jM+LfapN4oeUQvWxMdXLpLBmIzkjRILF6ldj/o68QxklLn/3gt6EU4UBtsRCsxHitzBTr2jmjY5TQmE6hZtyORFkyma9TvkJdQApz7MnXSyOvNJZj0H8v687gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtE3/Qri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtE3/Qri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606AE1F00A3D;
	Fri,  4 Sep 2026 05:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498789;
	bh=ZQCIQPxD2x3a1BWMGKDgOLX3/EgRbVFQEY9EMifpCMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtE3/Qri5pI1BoW98LQl3qcik4KaXQC+4KlQ4uJ08H9HeA914lQpaSistr4IlDHHS
	 DhnK4p7AS21AUFYnwPfdY4utQ2ioZ99dATAem8180lR+xWIBUrD+ZRi1Sr+V6b1HQu
	 Nj/Dcx/5DHtHBOxD1wwkKZlm8O+QnlOdpDG5AzVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 171/713] nfsd: defer setting NFSD4_CALLBACK_RUNNING in deleg_reaper
Date: Fri,  4 Sep 2026 06:52:19 +0200
Message-ID: <20260904045807.654035436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 108969960dc54de673869814c5f37c22f6cf404a upstream.

deleg_reaper() sets NFSD4_CALLBACK_RUNNING before checking the
5-second rate limit and cl_cb_state gates.  When either gate fires
the loop continues without queuing callback work, so the bit's only
clear site in nfsd41_destroy_cb() is never reached and RECALL_ANY
dispatch is permanently disabled for the affected client.

Move the test_and_set_bit() below both non-queueing gates so the
bit is taken only when nfsd4_run_cb() will be called.

Fixes: 424dd3df1f99 ("nfsd: eliminate cl_ra_cblist and NFSD4_CLIENT_CB_RECALL_ANY")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-cb_recall_any_callback_running_stuck-v1-1-310011a028f3@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7223,12 +7223,12 @@ deleg_reaper(struct nfsd_net *nn)
 			continue;
 		if (atomic_read(&clp->cl_delegs_in_recall))
 			continue;
-		if (test_and_set_bit(NFSD4_CALLBACK_RUNNING, &clp->cl_ra->ra_cb.cb_flags))
-			continue;
 		if (ktime_get_boottime_seconds() - clp->cl_ra_time < 5)
 			continue;
 		if (clp->cl_cb_state != NFSD4_CB_UP)
 			continue;
+		if (test_and_set_bit(NFSD4_CALLBACK_RUNNING, &clp->cl_ra->ra_cb.cb_flags))
+			continue;
 
 		/* release in nfsd4_cb_recall_any_release */
 		kref_get(&clp->cl_nfsdfs.cl_ref);


