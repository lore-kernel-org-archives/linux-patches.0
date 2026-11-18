Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039493;
	b=SbRjg/XE9F3JsP1feYnXpwx6m7fqNbiLSzA12RsoB5l841QTEOLfh5f69C8DTBIqzMac
	 p5rQX/rxY9zPLyfqR9xzSP5Vmr3GcPmtiCbNu30anqOmUwAR56iyElE1M9MHiHXn3q+zC
	 /Xuy5AbkQ18BMKjOghN121c0QHqC/nsTD2Xb7cTKnQc7BolSrJKT5hPmYAdv1PPkbkMXC
	 tSriy2MZvJMvHQgzRKDKMz3FwUEZuDw95TLRZ0cEpYVK+qnCuCRuF2/d7PEgr5+E5KoaG
	 3ggHiCnljgeGlP30WP6oU1PYPu4tZpaRVS7IvSPFVb30pJUq+gZ7wr5MZ/cus8IuHTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A0XFXodlQrGYJS3IWmPp+jr+eVWTeXMnDK6pMxiANI8=;
	b=sWYHaImk4xLsZGSriPGz3Y1BhLVJa7u11bGZQaa4+N5KiRmcBibIxY7ZmVOjEozVgkQO
	 wK42lXHIvboDcHRzS36lg6Ob/xGjVz0O7Vizkf4CfL6sk7enmdZM2binouF6wObdD8jGr
	 vcFPEdW7fRUmFjB0Jrtf1s1qs/AdM4GDifE6aOckmYxICICmgzNz7ERMzwnxWkpnPR7fw
	 m6E2Z7v0N+cLXe/dqLZOFG5enfSdImwxtV+Gv/HsNJaATgDAM/AxUq7w0MTnVf6IeGuGW
	 sJaj0OGzbN+sqi807EZBDZWaoHZssR59TTh7r+2mUFG1X7ovoM4OVs0ubZF7FUbspPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Whrq+qOV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0CF606A32F;
	Wed, 18 Nov 2026 22:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Whrq+qOV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D369A1F000C4;
	Wed, 18 Nov 2026 22:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039493;
	bh=A0XFXodlQrGYJS3IWmPp+jr+eVWTeXMnDK6pMxiANI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Whrq+qOVuFGN9Hu0ZQatJ0H2JwA72+yxK9W153YKvH0qy4KFNrIx1cCELXHHccwQb
	 axxDDtqAaKZJQmbyNvJ9Eie0ZaC4G0yAsTmwna+xui02xhaUqap4oY2CEpuNDRsWyz
	 RN3bW3nZD6iE729YVovCsEtqC+CRfhczTCZdt50A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2120/3318] scsi: mpi3mr: Fix I/O block counter leak on admin request post failure
Date: Wed, 18 Nov 2026 15:45:42 +0100
Message-ID: <20261118150425.662773829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0b318a2a9c93d..b1f4e11d66089 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1295,6 +1295,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
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



