Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BFA248BB2;
	Wed, 15 Jan 2025 10:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938000; cv=none; b=ZCHm6PPFVLuE9ssPCu5U54MamrT8dVNWTqZRfiisbHiBmEfkmWda6kTpl+tJ8iQ8Hk1iaCxit4VVMYMnesIOHMeXoF1h9dkbrOY08f1Ic5Taoz2VKNAWkeK2yvr5kdQlprmAC92m+vJZPxGoCzrXrif/5r5KFRdlYmN+P9lvWRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938000; c=relaxed/simple;
	bh=XzfPAWk9jc9igyh1tNWlNCXhzqqZHIyf5kkfqRwLDSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKD5B9Fve+scJLAGk0QbCZdF3E3Nq+oX+V1WeBtHwJnqvuX3FYydidjyVrqxX+ojmt1vB3PEHLdbzzuBHVzbhmp+VLlSucRqJC2+klkCSgMUozZDgVUE/ii70tPvUYM1RDGNzDpLbofVoe41Co+zWvwyyOFi1FxbhCLCm1uCW9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSBK1es1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSBK1es1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF93C4CEDF;
	Wed, 15 Jan 2025 10:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937999;
	bh=XzfPAWk9jc9igyh1tNWlNCXhzqqZHIyf5kkfqRwLDSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSBK1es1JiER+Ax0IlVV8r7rXLhJyrFTMufA6n8Nyrps9IuPFvC+Gw250gzqVyhUS
	 5Hnx5o8nohcyJ6zZdYKn80k3WxId5TBoyhsfFfG7DbvUDYTblT88V2zMSZwYQWche/
	 WbWKWwKE3vqY0q1Q85YET00j44l0oB0X1RRPLJqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yang <Leo-Yang@quantatw.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/189] mctp i3c: fix MCTP I3C driver multi-thread issue
Date: Wed, 15 Jan 2025 11:35:49 +0100
Message-ID: <20250115103608.466932990@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yang <leo.yang.sy0@gmail.com>

[ Upstream commit 2d2d4f60ed266a8f340a721102d035252606980b ]

We found a timeout problem with the pldm command on our system.  The
reason is that the MCTP-I3C driver has a race condition when receiving
multiple-packet messages in multi-thread, resulting in a wrong packet
order problem.

We identified this problem by adding a debug message to the
mctp_i3c_read function.

According to the MCTP spec, a multiple-packet message must be composed
in sequence, and if there is a wrong sequence, the whole message will be
discarded and wait for the next SOM.
For example, SOM → Pkt Seq #2 → Pkt Seq #1 → Pkt Seq #3 → EOM.

Therefore, we try to solve this problem by adding a mutex to the
mctp_i3c_read function.  Before the modification, when a command
requesting a multiple-packet message response is sent consecutively, an
error usually occurs within 100 loops.  After the mutex, it can go
through 40000 loops without any error, and it seems to run well.

Fixes: c8755b29b58e ("mctp i3c: MCTP I3C driver")
Signed-off-by: Leo Yang <Leo-Yang@quantatw.com>
Link: https://patch.msgid.link/20250107031529.3296094-1-Leo-Yang@quantatw.com
[pabeni@redhat.com: dropped already answered question from changelog]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i3c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/mctp/mctp-i3c.c b/drivers/net/mctp/mctp-i3c.c
index 1bc87a062686..ee9d562f0817 100644
--- a/drivers/net/mctp/mctp-i3c.c
+++ b/drivers/net/mctp/mctp-i3c.c
@@ -125,6 +125,8 @@ static int mctp_i3c_read(struct mctp_i3c_device *mi)
 
 	xfer.data.in = skb_put(skb, mi->mrl);
 
+	/* Make sure netif_rx() is read in the same order as i3c. */
+	mutex_lock(&mi->lock);
 	rc = i3c_device_do_priv_xfers(mi->i3c, &xfer, 1);
 	if (rc < 0)
 		goto err;
@@ -166,8 +168,10 @@ static int mctp_i3c_read(struct mctp_i3c_device *mi)
 		stats->rx_dropped++;
 	}
 
+	mutex_unlock(&mi->lock);
 	return 0;
 err:
+	mutex_unlock(&mi->lock);
 	kfree_skb(skb);
 	return rc;
 }
-- 
2.39.5



