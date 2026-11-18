Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048029;
	b=znyYjyvW5JgS3EPzgmX79jedgs6ynYtLzt8mUfeSBVg0VllUY4tQAkrZe+ydIdV37RcN
	 4QFokJLlMeHwrHHfZy0KcQNayg8ZVRdZPsuS7UvpUIdumfsSPmLvKfUrZP0vH2S/liphF
	 /UJE4Gu4CXMxZRbQiTZLiwPutjhHfwl/j5UWPjkI+4jwzNgcLamOoM7XvigLINb7WiXBI
	 CL6kFFQeDrvyg8ARCs/+uvcrOGYWR6XaslyaIa+ksfJEDJFPWVoWABdcO7tWVF4O7kYjg
	 4gyWN0KBJVipL0CzL8ceggl78Zb+ONVcLVIx+tv0PKnVYyCxQMnRth+TEi0X/h2XZNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=syWEjrI4zRmq10AzX9+TWX9eAk/ivoyNxji6JRVLDEA=;
	b=yIxcZM3faosSHAwufWLehArp3vDNytHrMvPc16u4eLSGZTZQzRA+/FLPFQskL8dEJ/PE
	 zUHPoUKG9aBX7MCvQe43kGrGSYPXWoddAI05kgHc2nqMNxImQ51b83DMyHLCH2ejk5bW1
	 pM1nnpS/NxsBxCxRu7kiU8037ry+MfR3vKOBbmBZ+iiH/oX3hdz7hIlrSVf9ckVqWEEQS
	 vkyEt8Xx66zlKlNz/bUqiW7aR1wry/ZvGoKqRIq5LEaE9oU4Mb3BoBYePki0axd9saijC
	 H/HcUAin35uawqXDzI6kPJw7SVxuMoAgBCjHrGMAZfuZRazYt0gvPmJQybqoMPnB5Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AegR/4UR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E165D606A320;
	Thu, 19 Nov 2026 00:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AegR/4UR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405581F000C4;
	Thu, 19 Nov 2026 00:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048028;
	bh=syWEjrI4zRmq10AzX9+TWX9eAk/ivoyNxji6JRVLDEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AegR/4URAFIlxA4GV3BQ5IdR4qQJn9RiQCpnH/wgZvNUjcI7gnlln0OYcWuy+HPr2
	 zOHL1u7ylmif2OOX+5QimNujYa2K2+dnRe7OaTfj7qa865VobZTaQewOBeH08fnDfW
	 xzomuZ6Pzp2j2K+M352SGjpRsCqurnsWqFjzyvlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1848/2857] scsi: mpi3mr: Fix I/O block counter leak on admin request post failure
Date: Wed, 18 Nov 2026 15:48:02 +0100
Message-ID: <20261118150307.781791560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 595ddaf83cbc4..10f37058403ec 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1294,6 +1294,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
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



