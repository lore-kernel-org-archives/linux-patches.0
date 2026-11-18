Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039490;
	b=naCgsyrPVneEe1gaGFlXMpkx57l1pLYdG2NrgcgXf3HXQrPDe8Pqbd6s5p8B3qSzRbV4
	 vxT9vKQ7YNrQa3jsC60B+oVfdxCkB46HKy9So9NSofbvdmfUKedPIefrjy0Q16PCO2qov
	 +EjuyDCAZnjwqFFXESVVQ2xrsSNJXn6Qry1RgjfKuKXLCf6a/vdO6oSnvgOTLnEffWO1b
	 SVxcUXAVz9aOBufCBmaBoxgdHR7cMS4unq7/PmqCcDKO20XNQjZ/KxQVZFoMn9kdJRJjb
	 rbCA9bXizpUGIPEuD7q2ShouomHVn9OYHbMsxjdAiCPbbj5Srz4Z0ogbP0RHFVE7qmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Khasf11ViI6Zm9mhMqM+wMAJnn1Kw51q9vzfloolCuI=;
	b=pAZP9ymAX2gLFWuhLzhKexR+fJMfXZUbHzx3YyJSvpdwwWkaePFL1X5PBruPiRnOACAq
	 xQRkgFK6O0cpWkEfTG13lPR2XyXNrvBnPzHIJHQxkIC5h2ZCBZ/h1T1GUzVYX1mGvhB4I
	 FVtXRp4QBk7VgZfpoJ4ll1mT0OjLunMlnwYm/CUDM62JQg5OYEoIDnNyVaLv+qx3XZNA+
	 u0edvoMoHBZYlIKgq1oiV1BScIiiKjijRTekh6ixy/BEnT/VqrZKNJK2U4R1up1VJuoXk
	 SVyqdcVXNrBuoPEJd7QifO7tPOJ864CQqXKVicVoNx282V8GnEedTpj6uNKY/gEIJXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bVNUSSZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC73B606A330;
	Wed, 18 Nov 2026 22:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bVNUSSZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B6D1F000C4;
	Wed, 18 Nov 2026 22:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039490;
	bh=Khasf11ViI6Zm9mhMqM+wMAJnn1Kw51q9vzfloolCuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2bVNUSSZ/CY/Dr8AR3rdquhueedAnAUWfTXI2+8qrxfy0H73RQpEwzwWazm6a4BTL
	 beVbjFLKoSgKMBYPHD8iRFlVEUBz2m0MckwLtN5xpux3IQ+bndaXXk2BL8TuU8NfaU
	 LFKp+HsndOsb563n0iLOrAyzOcnYD/MdH+ejQD4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2119/3318] scsi: mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
Date: Wed, 18 Nov 2026 15:45:41 +0100
Message-ID: <20261118150425.634721714@linuxfoundation.org>
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
index 8667f943f94f5..0b318a2a9c93d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1099,6 +1099,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
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



