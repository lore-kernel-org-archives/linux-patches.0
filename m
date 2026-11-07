Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063609;
	b=XgM9UOPkWc2njtLnU6zmUtszT4lHCLC9Aa+Ou5I1tzMoP3aX+rN2QEbVRsCtT332SXNy
	 6gE0KwDrvKDQUu3Vl+hGVT+G6xVT0xg+sfgEBsV9YdIslJh7un2PMJP0vuYdl28T60v9n
	 SN8S1VC51Zbi++EyksYC7/JdHrVUZddHGyhOUKuF33mjPsSVUJ2QkQJrE4xeZrI4uiDrL
	 RiYy+XCnS4ZjHN0IPK87xrSOQpXXRZ39+P9sps6Pr7HtnSZSkq6/sVJ8hxAG2wrzR+75I
	 DFBPObcC751xZc2lJ02o8J2rItUxlyrb0L+34jtRjhAi4po4ASzMQCLe5OAU7p22iaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+HtzmWSFe4pmaVlMt8ivNnthyJlXPGQ0KyMKSkQZC3M=;
	b=HG8yCsXdjylsaF7N6jZ2bYO9voy7zWK2CmcnhJWQoBQNlAlw1fq4WK9Je2+kvX940SSw
	 lGuJz5vW3rxckaULag783LyIIwydbpinuf+MVfMMGhvu2+wtTq5eOcEK0IC1XEsK0s8Du
	 9JFEY9ise6nYax4Btcj643lxn39uwvRDsfjnG+oLNT280Bf2a2hfRsvt2e9xpDsNLv6QQ
	 ENIJVj8VkGPnhBT7QUCAjsPlsXsOmjXHjUXBZHBABQkfT8arGIEiehwuv/UXwVlWbE4Cd
	 8/elmPa20haNMq2Cw/G9U8KW2AkSN1FMxWd1E5JNMVbGaNWnrMeFMCX0CTW6oRApTkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkKeII0v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B76606EE81;
	Sat,  7 Nov 2026 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkKeII0v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFA11F008A1;
	Sat,  7 Nov 2026 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063608;
	bh=+HtzmWSFe4pmaVlMt8ivNnthyJlXPGQ0KyMKSkQZC3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkKeII0vqlID8KOru6WY3zi8CBZe00JlBjiGF+iWbDTZ73/pVZQq9z8REdeafmHBd
	 FFMxHuU4ZLQOSnKGkUHgp24JWeRLOkFdWZrJj5jYWBup8MzAdCtVF/d5s5YaHW+xHL
	 +2B94NAWftW38NUOXMdCE+9wuJEeBFH+wUIhjbno=
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
Subject: [PATCH 6.18 731/869] scsi: ufs: bsg: Complete the job on error
Date: Sat,  7 Nov 2026 08:56:53 -0500
Message-ID: <20261107134917.560855926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index bb6ff8ca5c7a8..237ade1f0cd83 100644
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



