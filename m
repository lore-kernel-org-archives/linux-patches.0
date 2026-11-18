Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048026;
	b=Qi45ej8j11gc22bzw3ASYf88wRqVf7IuN0FFUxWU/lRwt8MPRgVic0l/aKgeyMEP+UYw
	 kr8EaMKckAY5bS7Z3jTsJe+zyxZqg+aVIJkAYVVxRoHkcn1JQvjsmQCZE1xTuYQ8qghl5
	 w110xJTug7r6XJOKV6B9tlBpUSDhKuYE/PGGsT78jTdluPvRJ20QgClZdVUb4b/vsvLrC
	 s35F59d/2lT8vyPdEYZr7Ynf7CstLYEF1m7MspIyPz36wBlNpi9+4TfXaAwdsIKmAt/db
	 40LYam2JvwavQFqwtLBnNwQdtNNKAmrPIT5csOilEoQcCDTfC3WIy6mv0kH0LMXl+pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oVXfKYxKXK95P41K/XjY88jugcz7Hczdgd+LN3svLZ8=;
	b=alO/2wdIIScYAUPBb3xNcV1TnKlf7THGFqcQDQhY7zIOL3/E6YncHIYNF3jxUOi+EXhr
	 usiBlUCat9QLYQ5kiYdt2URpDnIWrHBdXGBsfI6yRllGO5033KxOIoxVuaEmhqdbP6s7/
	 bkdnXYBW4+VUFcUGsA7QTYC7Vyjqt2mDSEOKZkFGT8n+ZokrN0xHQFJdxEb39WkMQEc+2
	 bUaePV5oTcuxR0o9wlzaG7N3mPMRPAQD7Szxv2Qv30qHAiN3xhww3mq9kJoAf7DZiW4m7
	 cWu9Uu750qsIqvo3xW7j0ZemSqBUHWzoFwkRSCei/swm5xGApsJN7hD+naVjabf92VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEswx45+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6FB606A31C;
	Thu, 19 Nov 2026 00:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEswx45+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE961F000C4;
	Thu, 19 Nov 2026 00:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048026;
	bh=oVXfKYxKXK95P41K/XjY88jugcz7Hczdgd+LN3svLZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEswx45++iFe+eo0s/Zp6MlOPV7+JhNFK86vfV6sFtEyK8xZn52UukOccTdpF47bb
	 YB3jk9jzlPUVHWDNpPAE0oey+P0wFv/v1gTNQjRYlB/y6fcVY7QjZHFquP+P+1MhGF
	 b+RsQ6V5fYImDsVOTMEb973IjG/vyQopJlW3Ys6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1847/2857] scsi: mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
Date: Wed, 18 Nov 2026 15:48:01 +0100
Message-ID: <20261118150307.747107743@linuxfoundation.org>
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

[ Upstream commit 9fac4cbd66d852958e8a8d0952eb57f8554ce83b ]

The MPI request is copied out of the caller supplied payload without first
checking that the requested amount is actually present, so the copy can
read past the end of the payload buffer.

Check the range before copying.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-3-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index c5ac6d3fe72dd..595ddaf83cbc4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1098,6 +1098,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 				rval = -EINVAL;
 				goto out;
 			}
+			if (sgl_iter + mpi_msg_size >
+			    dout_buf + job->request_payload.payload_len) {
+				dprint_bsg_err(mrioc, "%s: MPI request buf exceeds dout_buf\n",
+					       __func__);
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
+				rval = -EINVAL;
+				goto out;
+			}
 			memcpy(mpi_req, sgl_iter, mpi_msg_size);
 			break;
 		default:
-- 
2.53.0



