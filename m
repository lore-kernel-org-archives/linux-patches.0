Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4A83AE71F;
	Tue, 16 Jun 2026 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629900; cv=none; b=rvYsAbSF5w/zFuXZMInPR9U6IzLNpmMjJKDPu4Ushc474dErZfXv4/haAGkf7cBNbA2t5tHSoALv+SvLaAJXJNHVnibROpF77DbKixU39ybOK34iDsVCyaqG0Cctw/LGqqqAqDQrs+bXSH6h4aOo8PddkJpCFBiVmWgWJ5to8LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629900; c=relaxed/simple;
	bh=KvAsx9+DGPbH5EByVMH4231ChWV2ERHsliFPYHX6TV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/w3iyDCSJXPElQDEnyaRqAe5pmNYf2nItfytv2XIx4x5eoee8y/2c+rgoCZgGAotKHPAqfvJqDQx2mkrrgp10o8jwtSDfw/9r7Y3cM1RN2zNXme7bab5T8y//MWUSnTeibNAVMR4MqPEEjauCxi4yLfsWpSSUvpT87xFo9bk4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sa7Vy4l9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sa7Vy4l9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64261F000E9;
	Tue, 16 Jun 2026 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629899;
	bh=/qviQX9LPI/873NeCuOVi+vdkqOR3ni6z4peQBlhrBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sa7Vy4l9jsg4Vy/5DuwBEn723iEizYpBk9gIz2Amd651TUr2aSVxI10z+cam3+t15
	 KBZDjDCzVq5BbeqpmtzNhFD0WwKwkSocwrYkZgdHNkETHzNB/2FMzlaFzsZagOb6+t
	 KC66P+80vN4RYcgxokvZN1JwfqnAu5CuYDUlmzNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyq21@lenovo.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 340/452] net: rds: clear i_sends on setup unwind
Date: Tue, 16 Jun 2026 20:29:27 +0530
Message-ID: <20260616145135.159253184@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyq21@lenovo.com>

commit 20cf0fb715c41111469577e85e35d15f099473e0 upstream.

The RDS IB connection teardown path is written so it can run during
partial startup and on repeated shutdown attempts. It uses NULL
pointers to distinguish resources that are still owned from resources
that have already been released.

When rds_ib_setup_qp() fails after allocating i_sends but before
allocating i_recvs, the sends_out path frees i_sends without clearing
the pointer. A later shutdown pass can still treat that stale pointer
as a live send ring allocation.

Clear i_sends after vfree() in the error unwind path so the existing
shutdown logic continues to use the correct ownership state.

Fixes: 3b12f73a5c29 ("rds: ib: add error handle")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuqi Xu <xuyq21@lenovo.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/5a0f7624bb9845a7b67d26166a150b59e7f394ce.1779632468.git.xuyq21@lenovo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib_cm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -656,6 +656,7 @@ static int rds_ib_setup_qp(struct rds_co
 
 sends_out:
 	vfree(ic->i_sends);
+	ic->i_sends = NULL;
 
 ack_dma_out:
 	rds_dma_hdr_free(rds_ibdev->dev, ic->i_ack, ic->i_ack_dma,


