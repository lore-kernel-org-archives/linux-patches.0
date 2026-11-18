Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023325;
	b=1wScbTl5yaxEpMqDkNnVhkfIcFJZ6CupWW8XCXL2JNs8YfJ0LLH06k4d5EliQxNddrRL
	 f9qQIiWi70+auj6wjdmxUAnEdsiWPOHfS/j3mhWbjZASMwkLLr7S7cursMGiA/mZoR6Fx
	 Zg3lvrS/XMMISA2q+FPaqCefItRHlKxvVLob5H+O2D0iIYng03hRCV1P2EHyEuh3bK8wf
	 oHdZYUIbX3UtPNlzDFV/xGjmJ9npMBOpv6G2YYSfXgP7Veyf5MWCKaA3Z2RjkbhRE1fSF
	 IIn/qcEyZ7Qnbt0RHeExZDERZ6QhOzTZh1HIoji8d1IFdPrCxFOiupjztef18fP+WKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2eaVU0TKBRIavfTvAgjAR38z/GCpWglkmqGPUF6ZdzI=;
	b=P41H5mdfPB3kxlyC5nb1naKz2yo0kojju+891p6Bq7Fh5cMfJtCZfzvo5kwW2BYkyG9f
	 Tg66WrWdAdsWhzDENRpPFpP5USchkY1yqn1+O3GaoOkXMSdaCeh6Zg6PhNDI2T7jFqLpV
	 85SOA4V4qTIF4xau1qgcIFYaWHczK52T6qna08/EVG2U4bnyzDNK3YLX+IcCqemPpYLGZ
	 yEmZtIUV+2NcZYBliI79eBCPgOFE4Kok7Nlk95k4Ul+Sre9cKazgGE5fl/b56lAwuUv3/
	 wuYTPe3KkTuDc6z+zmknf83TyW40+JOd9Xjr5nNehP0O8WlLgni6GraKSlkdD8u7jLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJXfQgGH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C138606A333;
	Wed, 18 Nov 2026 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJXfQgGH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF621F000C4;
	Wed, 18 Nov 2026 17:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023325;
	bh=2eaVU0TKBRIavfTvAgjAR38z/GCpWglkmqGPUF6ZdzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJXfQgGH3f5q22ePZGeGeRiE8AKSduoYSqIJLn4wuTOzWTrmdxqWhYdd9XCOY4Cvh
	 TwViDDXeo/0iAOKydOtJgzqsPEyodqkY29Sd1gZAPxmNivWuhF3F+lFFd23ryocISa
	 CVO2F7qDpzUrDkMd2l7kRcLMKv0O/PcUa6ZINCrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0328/2151] scsi: mpi3mr: Fix I/O block counter leak on admin request post failure
Date: Wed, 18 Nov 2026 15:34:23 +0100
Message-ID: <20261118150133.939441260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index adc70d0e7ec67..b0b12b5b423a7 100644
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



