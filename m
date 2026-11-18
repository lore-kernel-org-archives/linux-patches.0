Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036865;
	b=ExSKYebMfdCVr10laMw1gGQN9cmnDVsm9c9Mw0rdIAGR+4Jm3jFqDKwIPfvz2xtYjzFV
	 avDLszDXOKAcD1J4VSc79An2ooxCONl3xcH6hoeAO0ibQbFH5At1uzyjBb3X161jrawfO
	 7PYBy6rtP4GcBCMsK5TYzCq2aJwX1eA7Ro9O011LEujiidxgu+7ena7GhUtXsUaSiSXrG
	 9lLnCSKR+U7STnmsBr7geWx3NLwe60zaBId63cnTgrD8a3rBpUnT+adMjsToAnD5g2p/M
	 wHPqLRC2nGMSaRiN2Bbci6cYt/6EcvvtDLrhJBrZR7589XF7uts3R2EH1NiAEldKp1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MVOkUe52d3+02uS9OeXGMMUC6nbJxK1CU9hCptI2lYs=;
	b=iUby1fEEoW0NYC2K6sMuJCGgihuSqhu9KfB2YcfwvkDoTP4CFzU8O69xZz+wcv9zvr/0
	 mmCY4ep3eZdHzBfYBWcsWYyTNYvpCxQpQVVStCU5opkKX19hCB7v7KVTAL6ht2lm8lh9I
	 ojvy7mycQU9vsH0jRMUevjXeABQCzoC4RMUe/X+oVlOH7KHVeSg0P7EUA658GflqSpSir
	 apzQhcrmOF+QyN44ZIcDtr7uGtxdJ5mmLChoLsxPgGkS0f1Bh58m8YicTlttbAPTMLme/
	 tGgEeMG5vPHvj/DOkJCUpq/l1zcA+rt8lVXy73WTUnX0hqSSeobab8Yw0fE348L2xVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yAtQEpFs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D0D606A331;
	Wed, 18 Nov 2026 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yAtQEpFs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218451F000C4;
	Wed, 18 Nov 2026 21:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036865;
	bh=MVOkUe52d3+02uS9OeXGMMUC6nbJxK1CU9hCptI2lYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAtQEpFsf61i1UbbXvDzk3k+1WUO2y8+30t2nhcNMjbTXfWBWuafs30vtkzpf96x5
	 bv+m+Rsx+3WcI1CJZ4kFsWDfBgyIoapo+9O1ywsx/Gj6gxtkaEljdba3PEslNbjrdt
	 C9XY0pVYr1JdRp5ZJEy0iA/n0yPoJILyy7HLFlm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1212/3318] scsi: ufs: bsg: Complete the job on error
Date: Wed, 18 Nov 2026 15:30:34 +0100
Message-ID: <20261118150356.529719058@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit cc0ce3fe8fac073ecded4f32c8ee5b89da1397e8 ]

When ufs_bsg_request() fails, it returns a non-zero status without calling
bsg_job_done(). bsg_queue_rq() then ends the request with BLK_STS_IOERR
without running bsg_complete(), leaking the job's device reference and
mapped scatterlists.

Always complete the job via bsg_job_done() and return 0, matching other BSG
transports. Requests failing with a negative errno now return it from SG_IO
with the 4-byte result in the reply, while positive status codes still
return 0 from SG_IO with the reply header.

Fixes: b13a3539eb2a ("scsi: ufs-bsg: complete ufs-bsg job only if no error")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-2-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index df31f89b9666f..e2f03243643e0 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -194,14 +194,12 @@ static int ufs_bsg_request(struct bsg_job *job)
 	ufshcd_rpm_put_sync(hba);
 	kfree(buff);
 	bsg_reply->result = ret;
-	/* complete the job here only if no error */
-	if (ret == 0) {
+	if (ret == 0)
 		job->reply_len = rpmb ? sizeof(struct ufs_rpmb_reply) :
 					sizeof(struct ufs_bsg_reply);
-		bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
-	}
+	bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.53.0



