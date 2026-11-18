Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029300;
	b=CR9ZHE9v5WBY1PJauRJC27xc1qc4GQH9XwOnCXPGsYF0BKcWpVX6gcnDtdbYuk0wyre0
	 NKISBA+M/LwiucagexLwL/Q8+hX7SqKPWFD4R6dq92/r0zvLJ79vrnRo52J+V+b3i7A7h
	 sqxpUY9U/GW2G5G59pkUnSbY/I4WFi/kO7aeEuFYOyKOnVLvtn1muVwVhlmbybg2CrWMd
	 khqY1FLx7+uZhHOj6Cm4i7GHODS0BypgQmUQr+cZ6xQi4OsCWkmkB/hUTkWBxQeN7PuYn
	 FuqKPu2UjhP5gxvoI+0RVKmeYjLB/RhQghzgMnl90Qqqv/HLxASlzJoh8KpyWHBIzKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0R0eTGOGE1m2xFc5BxQBBwGQ0OJzfQUe9niTWXU1VMU=;
	b=YwIWKwT4n/4YeLBolHeSCIsQ/wWP4uO4BLkNrh44hQWJoy4cYFQx8970AqFD1MvNGecm
	 TdOkAl8SGjiRLOhsYqSso0/voyy0zO8jQr7Ul8JypGPVUc9zkZkw0174y/wdo2Bz5NL8g
	 yJwRw6MdFntYIQedumH/qeYlAUkNl+AVtsE/J5GePVlAOn+x6DZEJjSRRu+Mo5CRLq4hf
	 YMYjqHH2k7Z8bTPNrwa+dvPHL6MrVaos/x7rrrT7AF0I6FHojfqDuxMYBhhm04Qa9+uXi
	 0B1yzt03OEThculWkjd8PqbAbiWIuIH4FW30fP0ELhcSZBGe7eiZQvLH3jFSkJPpYnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irMLLDc+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7AA606A31C;
	Wed, 18 Nov 2026 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irMLLDc+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875BF1F000C4;
	Wed, 18 Nov 2026 19:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029300;
	bh=0R0eTGOGE1m2xFc5BxQBBwGQ0OJzfQUe9niTWXU1VMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irMLLDc+7dsSxy/ZPD1DtU4RRBpZh20fQob9SIgYOkKxONSbT2cSjZuqi6En0KrvM
	 pqsjgRrPOR8vIigEpFmjrllhkQAN2KT1LdiIE0+QZ1dLVymuJsEyql+rHrouIrLMRD
	 Oc9rahKeLzPB0brp2/AdYrA3RUX5L0ivXRIewcAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0300/1756] scsi: mpi3mr: Fix I/O block counter leak on admin request post failure
Date: Wed, 18 Nov 2026 15:40:27 +0100
Message-ID: <20261118150020.296645000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 74e003e540535..f08f5f7cf5753 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2697,6 +2697,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
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



