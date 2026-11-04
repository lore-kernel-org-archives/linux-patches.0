Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827029;
	b=LUM3L2zYBWiEQwwieN0a7yMyXFIUWz0C8fGHvuZ3G0vL6alsW0NI5TiZGQVKfTFqDXjs
	 drUNVVzd49a/QGeznQ3p+kCqvK49GbSYkAKDYSVF8yAlPpIsnnRHsP1psLMPDKWTiQgcS
	 QC8LPcNu8HWVoXT0qfI6fyaD86KPsAFd+ydowe/zm3XQ9PKT3XXwjfkoA1yqVDN94i4m4
	 2hJgYSW+ryrAOf1KiTZWzL3Y74IWlxllFoQE41bSpgkSt8p3rfXzRnrsrdRrYmxN97VlG
	 EWQTMXAKUIuzWVaU3M5YT/Xdpq+bdbgWi3q1/pCELN91OxK82DOv/HfPN7OVKn+ZT0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K+YDz5urRqB16d4JeSfHFRDWRUom205MZyyRyk1CvGg=;
	b=wedoHzq7Jd730NlzR/NFw+dML1stIqF/ORRyut8F2aRFqNuji9cYNcHNrCZNenuoLnOT
	 F7fKg0RfkpzYkslX7TqkwtHz9BaPTEWfi4tvi2IGGzt13Ml/x3x6eESqKjNJA4D8OpBhW
	 DohDtGDmcC5Zg/BqqU4pqTKY+BvMaGHdgFZkko/oHzGN31w+bdSE7zU7cQpn5QtbCV/LW
	 bqTyE93DoCCWCNjDt2Mc5lEWlHmK7eqeAhod1eZnmSTJS4Uop6z7/mKLwwiONxT7BY6Bc
	 GOEx2d0cWu5gXq1VgzZo2QoEwnJ0CBXMkFS356RMOFQW2R5gUZvQQ9Ir5V46yOnMUAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JlOquzUi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8B260C015C;
	Wed,  4 Nov 2026 21:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JlOquzUi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4901F00919;
	Wed,  4 Nov 2026 21:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827029;
	bh=K+YDz5urRqB16d4JeSfHFRDWRUom205MZyyRyk1CvGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JlOquzUiRBOPMrJ4M2fQY02SPkcRqZXSFWLySyYwHcWtG8cwap9q3JcxEzlA+sw0K
	 sJ1MZzXmgz34EDvScmOqYUd91MDNGVJ5EJF9UcZe8Hfe2DONxALUpkgW5f6OEKyNgM
	 tyXHJ8owYQlcy9+E48eaG5UL2qBUgVQ7EnQ/fEmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.3 153/547] nvmet: fix use-after-free of the old registrant in nvmet_pr_preempt()
Date: Wed,  4 Nov 2026 16:05:37 -0500
Message-ID: <20261104211042.506969507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

commit f316aa7f018840523939183425394931b373e4d7 upstream.

nvmet_pr_preempt() handles a preempt sent by the reservation holder by
changing the reservation type with nvmet_pr_update_reg_attr(), unless
the reservation is of an All Registrants type.  For the holder that
helper does not modify the registrant in place: it puts a copy on the
registrant list, points pr->holder to the copy and passes the old
registrant to kfree_rcu().

If the reservation type changed, nvmet_pr_preempt() then hands
&reg->hostid of that old registrant to nvmet_pr_resv_released().  Unless
the reservation released notification is masked, that function takes
subsys->lock and compares the host id against every controller of the
subsystem.  The caller only holds pr->pr_sem and is not in an RCU
read-side critical section, so nothing keeps the old registrant alive
while it is read.

The result is a read of 16 freed bytes that decides which controllers
get the notification.  Found by code inspection.  kfree_rcu() defers
the free, so it usually happens after the read; when the pending free
is forced to run before the read, KASAN reports the host id as freed
memory.

Pass the host id of the controller that sent the command instead.  The
registrant was looked up by that host id, and the controller outlives
the request.

Fixes: 5a47c2080a73 ("nvmet: support reservation feature")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/pr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/pr.c
+++ b/drivers/nvme/target/pr.c
@@ -593,7 +593,7 @@ static u16 nvmet_pr_preempt(struct nvmet
 		status = nvmet_pr_update_reg_attr(pr, holder,
 				nvmet_pr_update_holder_rtype, &rtype);
 		if (!status && original_rtype != rtype)
-			nvmet_pr_resv_released(pr, &reg->hostid);
+			nvmet_pr_resv_released(pr, &ctrl->hostid);
 		return status;
 	}
 


