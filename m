Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015889;
	b=Tjja3kP0O443CPIwLMALeAaALfa7y4Id9QTSdwetFNBRAJvILhBGIJD8jAr0ZoLOsk8S
	 n5dazgQPVZwNGPADTKaro6U7zT4gGK4sltrNwgbyyqH/QHXa0fCS/KZkVBSiQ0D/dnjXG
	 sykWJUQwGQVENmL6Wdm+AEBUqW8bL2qhYeCKjywcciFpVLQXcmBiwqJ8RBk7bALM06UCm
	 L5W3UXseFA+axBrmZLI+eJcGvH83gk6wMBQ8ib1b9TRFcj+zocOgxNDfZBI9DTuQ5NCOB
	 yEerBf66jNDu1j5Yz03nHVAjDlXkIhp9E2NELwe91dxViNesV6jao6+qDfEbGW8fSkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X/iJGOjoXeLU/V5pTEzt+uWjuIXziqo5Ih1C4emu560=;
	b=wFOBhjfCpm5kaDLiyEPeFDpWzM3xAS4Hikq8IfIOy7+FOMQGQ+lWDzha03OeMVf9FlYH
	 T30Is5HWDG48YphwIOJj6R1ID+dj3uVhSZ8KDbNjBoerAv0E+N4p5fAM2taDZ3C8LAq6n
	 fhjDYUngalU+9GYkIJdTC7/M3VdwpmNLg5rwKolDmlE4CBA56SylCmAhmQ6J8OCkAJNTL
	 Cwf1DHySQqfdQiSaPqlRkjoVjycFr9nu8XJ04UybjqFvcBKHfrEtxOpomG+gFgAJ9Vthr
	 ly3a7pVn1dhECKPMCoKCNP+wQ+MSlO4bOCQ/xiDIuhlFHrQZFLwH1a4+yuSXoRafOdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEX5EDIN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958CE606A33E;
	Wed, 18 Nov 2026 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEX5EDIN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42D21F000C5;
	Wed, 18 Nov 2026 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015889;
	bh=X/iJGOjoXeLU/V5pTEzt+uWjuIXziqo5Ih1C4emu560=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEX5EDINRXHO5UEqzNgYGpDtv30UxwpLy5PzGLFWTT0FjeWoUKj2biyHcq1CC3X8J
	 9eBUpjY1S+3Qc2mRHeDRajshI4OMFGjpiEYq+4Fkc0xlABYI8CT07z4RrYQWGGK4ch
	 uELs1kU4DksT3fBTrg6Sz3JE5TPQTgI9fAif0KCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0332/2651] scsi: mpi3mr: Fix I/O block counter leak on admin request post failure
Date: Wed, 18 Nov 2026 15:26:12 +0100
Message-ID: <20261118150259.811623488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 37e7d274272bc5e545e2d5f9261afa7f33f1cf49 ]

The per device I/O block counter is raised before a task management request
is posted and only lowered once the request completes. If the post itself
fails the counter stays raised and I/O to that device remains blocked.

Lower it on the failure path as well.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-4-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index a5299738d6048..461c488c8029c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2782,6 +2782,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		dprint_bsg_err(mrioc,
 		    "%s: posting bsg request is failed\n", __func__);
 		rval = -EAGAIN;
+		if (block_io && stgt_priv)
+			atomic_dec(&stgt_priv->block_io);
 		goto out_unlock;
 	}
 	wait_for_completion_timeout(&mrioc->bsg_cmds.done,
-- 
2.53.0



