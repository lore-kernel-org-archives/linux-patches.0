Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831380;
	b=St9QzC/Hnpsadm7WtHLwTfbjUmCG2Qo0srGkFYtVEiHLWZ9lIIVbDlq9jUHQazQgCA77
	 RYH7xmw+1z0i0mD9XvtAyVtnGVQwkFxgSRJB4htG/YP84vnPYPLyMUQsb/LiVzB4xkG5s
	 RnLA4WFc//hBg7D1bVQyNxxiuwNJ3gZIqhCcoErTZ7A11GjW6gb1/79qsB6Fc+2qOhege
	 dTKjs3Lps4zY2Jj2aB92QLxH1UhfMbNmDVbqnD8r73ahdyFPOCfKqCSWLD06ComxarO7M
	 OXf6zuMz2uADUJ8K5KOO5hfUQn0ogdv6Gtg7bsUzofA88hMp0w+MojtHafShPTBpQGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ib81gkkBweluSKsOpXBMysEacK9Gi2Fce1Q0Ks2Fvag=;
	b=K11WrqPr3P5XLM/2vPSAV+TG2HSea8QE4gucdXB6CG6gyyvTuhxVR+g9DBhJrCAmEWhW
	 1zhMCSYfxKtDjl9e6E4cQc9BtZElvgvGlQ+aq4/fjwc7BmC7Aurq9Q07nX9KJqwxWiL0H
	 PlsdnX71yjjgQl64tNFOV1nAX17mEYq9+gcayP3XmeCIpHavdoowZBkfKuOgSe3dG5+tx
	 wvifJVSI6BKVsTbrzouazSrJw4iSZ0NuvymljKZXVjK4U5AOeZqvevhNLm4UetiA1GTZR
	 t8qycToegx25gZhjuJ+BbdyuDsS4tjgNrUCsWUSIK14QH01Q1a0D7aE1FHDHFhWhqlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TS+FCblq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABC6606A337;
	Wed,  4 Nov 2026 22:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TS+FCblq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAD01F0093A;
	Wed,  4 Nov 2026 22:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831380;
	bh=Ib81gkkBweluSKsOpXBMysEacK9Gi2Fce1Q0Ks2Fvag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TS+FCblqrx7aWbt5zNRci+fFLJ22Acnj63L8z76HByFueVZmoGl7+1DvOQebcB9lL
	 FrQh3uzSOS2xubcetjW5bPKojNWR+4jj2trMvVuihFi1STa2RugsQd2/Snrl634Qoj
	 ZEDZ+epeGYlBu2/T/AJz8xNROKeJOZK0SyBZH1yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 0669/1005] nvmet: fix use-after-free of the old registrant in nvmet_pr_preempt()
Date: Wed,  4 Nov 2026 16:06:42 -0500
Message-ID: <20261104211102.393178287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


