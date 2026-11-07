Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065309;
	b=YBBKL/vJdZKle4n1lYFd3vkBPj+FvHWmfZ76aonCnA3/5I9gSvpVCIhWSU0AAXkwutP9
	 9BqNKFUtxX+UGBt26yz3iqVP+g8emWYO3dlyvz4XjWYiC0p/kgeaPtz3xfunounbBNJud
	 GzZ3rThHMPkemPFdaf7fdM2A7eYdXNnrlQiQcgX1zdti6YczBuH4QMLEAjdBKTHmu/Mj0
	 GscGSV/PQZuDQwTdwfsNZ42EEw1lg7NzJk4n7JQmkoCzKZ73g33Cyb/Cl3g7Q0oDeLJsJ
	 otEX8FCX9/n9CCi5EYQNp6o6VnLK68HgSmUfJLQOCS0VMBEcW6Q1o7UCSzCyZu6l49A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AK7t2i2Y8PGEub++H1J59y0d6jybAww1OGJd1xiB9Po=;
	b=LJSyA21HK1+4c9RJHR+Epdazz/S3Veh8dZ9dBE0E9ow9nmKLoFKm1vATSthPKM0o4t0h
	 dM+HSGDY+WA9La0Egs4zQPnxBe34/41leXbXj68fYIQTLtCuKQcPu8u+PV5xMyhx5IPhe
	 XkP0X6akJpB3zxAXotWQy+Lj8oL3XVEhTbC7xIM0BeLWmfN7945V+nqrLD4es1WLNejwd
	 EVzL/vB8cKA3ruH7fWWmkhXA1aV2LW5icgmZbuJyvyB+kG1dIzk9VmuSvNNXi3ady0knC
	 oW0oe5qcsCDrvTaZUYLscfKsiJ6ClnfHX7LuWZlk0d7LvhLB3Ieck8lJUEYhDbYdouw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnojc1Lt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD95606A32C;
	Sat,  7 Nov 2026 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnojc1Lt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577761F0089F;
	Sat,  7 Nov 2026 15:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065308;
	bh=AK7t2i2Y8PGEub++H1J59y0d6jybAww1OGJd1xiB9Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnojc1Ltl5LurqmS/nLD92A/D4TpRTheJXNWUoVay0JSLLC2RVwfodS/M/7TqjcFk
	 jh/pcnFHJyOVmwIeWJ2q6dRCAdSG1EEaE+ZMLqW8caBbK6se8FHKMLz+LW9JkyICIo
	 /fh4lQ5Jryai2V2XuCh+6YckZPNCoqVA0h6qwwS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Stanley Jhu <stanleyjhu@google.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1059/1257] scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
Date: Sat,  7 Nov 2026 08:55:55 -0500
Message-ID: <20261107135008.534143463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 6b9c1f49971e4dfe8b8916f0527d30e97c15f234 ]

In SDB mode, ufshcd_clear_lu_cmds() clears the request slot in the
controller and completes the request, but leaves its bit set in
hba->outstanding_reqs. ufshcd_poll() treats a request whose bit is set in
hba->outstanding_reqs and clear in the doorbell register as finished, so
the next ufshcd_poll() completes the same request again and unmaps its DMA
buffers twice.

Clear the bit with ufshcd_clear_outstanding_reqs() before completing the
request, and complete it only if the bit was still set. If ufshcd_poll()
has already completed the request, the bit is already clear and
ufshcd_clear_lu_cmds() skips it.

Fixes: f18fac1e2b72 ("scsi: ufs: core: Rework ufshcd_eh_device_reset_handler()")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Link: https://patch.msgid.link/20261022034443.3034432-4-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 25aeab7a73aa3..d6c082b096796 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7936,7 +7936,8 @@ static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
 		return true;
 	}
 
-	ufshcd_compl_one_cqe(hba, tag, NULL);
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
+		ufshcd_compl_one_cqe(hba, tag, NULL);
 	return true;
 }
 
-- 
2.53.0



