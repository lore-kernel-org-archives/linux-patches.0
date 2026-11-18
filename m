Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029294;
	b=Kv+Xc2TdPEJt21xPOq+PARq6PfH2moAISuRswyMqjxRSvcMhdgut5hqxHkXkveN6YvDj
	 sL5KJjLRqVG0J923/XZk75He3ekfE4i0YnI5KgldQByq0zYOvlPuJlb6Yvzjx/Ij91Rd8
	 VpicCrr4YlMIwwo20JxHtu3Z5qNn4/XmLEjqQ1RkkEYEDIwHtuEQojIlvxz6qI5fik8En
	 ij9Vu/DRjZBuP48Gn9pmVoDfi3iXYkVma+1XVKOVyuJMj1ITGIJQa1dhr+SlIiFRD194c
	 u1vgEh0/rC5TrB7IX5Oa0pNDWbrpAhPNIkl0V2cCHZJnAC07gsYpOfXwrVVZGMjZwqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/e082W1335j9GEkyEatIBncbH4lO0yigXFAnJ1wIrqM=;
	b=Gsn7nETxr5+mA+8WJ7IS/M/4P8YvXshaZj5mERwCNbulpKzldA/IUukN86gdGYW0QTwZ
	 izjLAx2PThnJa5+azxva7YaV5jyognG/tBh404Py7K7VFfrWjqEphT9DPDmqSUeOmiQEt
	 WXp/BTA4so2zekKU2KIhoJYqGfdHqaow4Q0fmN+wCVEMilK2FY/RjctSOdndpbG3Xc3G9
	 xjgajLTNbM8ALfoGYQv9X0ERs9z40B+oKQO/PCqxb4VM1sLS8g/bZr9Jpjfb60PsMC1e3
	 VxlGhlYFRfjCkAeDRp8BSf0C30HAuDGAXzWXh9Ebj1t+6YBfMuAHHtWTcEuIpnVeFpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qT+homsR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89506606A31C;
	Wed, 18 Nov 2026 19:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qT+homsR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74601F000C4;
	Wed, 18 Nov 2026 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029294;
	bh=/e082W1335j9GEkyEatIBncbH4lO0yigXFAnJ1wIrqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qT+homsRDhu1Xl6UCWystoRzLLW40N/ZkvkjZK/5bV/PHDscNhIqkS2NdwX5E57fY
	 RTOueI2GvLAjZxnHqvKpgvW158ckY21/dgw7Js5MWrNx+dMjMeWMt57GNAE8PYxpYC
	 n3IiwF1VYOCo37jRseD/ulIR0tLdfWZDa0wdBR7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0298/1756] scsi: mpi3mr: Fix buffer overflow in BSG passthrough request copy
Date: Wed, 18 Nov 2026 15:40:25 +0100
Message-ID: <20261118150020.220048007@linuxfoundation.org>
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

[ Upstream commit 896abdd4d81f40575b05d593f7fe004935a6cf97 ]

The size of an incoming BSG request is checked using a variable that is
narrower than the field it is read from, so large values wrap and pass the
check. The copy that follows then uses the full value and writes past the
request buffer.

Widen the variable and copy only the amount that was checked.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-2-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 047a906aaf0bc..c05b8d0d1a5d0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2300,7 +2300,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	long rval = -EINVAL;
 	struct mpi3mr_ioc *mrioc = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
-	u8 mpi_msg_size = 0;
+	u32 mpi_msg_size = 0;
 	struct mpi3mr_bsg_packet *bsg_req = NULL;
 	struct mpi3mr_bsg_mptcmd *karg;
 	struct mpi3mr_buf_entry *buf_entries = NULL;
@@ -2453,7 +2453,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				rval = -EINVAL;
 				goto out;
 			}
-			memcpy(mpi_req, sgl_iter, buf_entries->buf_len);
+			memcpy(mpi_req, sgl_iter, mpi_msg_size);
 			break;
 		default:
 			invalid_be = 1;
-- 
2.53.0



