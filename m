Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023322;
	b=AnzFDgSMEBtXj4cwFFRoAXJN01brjhmoyVCLAERyP/yal8pwnT2iRDFE1JHj0x6g2Mch
	 UZ6bnMTZDZTY4Eq5OAfs68bfQuf9lLNqCa7n5e1mJkvVNt9Z1rIGuLeUC69CTVKtU7o8z
	 rcWjDecDnwZfGGYevIPoHjkJTtJ1bjkzP6qTmd7xVZ64gtXkYIl+VrIRFn1d2kIQ+iRti
	 2BYYxBz1zCqBvnhd/NJL8jdMlbK/B+zW30jYc/iHv4TL9i5DDldhd6+MUb3Dpdx/qIpXU
	 LmqZVLfcgvkvuyFJpm+uXrU4esaT1VYmlb9QyrMpiFBmRkhHogIxkuEZ+dU94QxLdeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bJCALfLQHTtX+YVlUYUtD2e5HMrSgmiRKBQ9SMZHExQ=;
	b=bvTWjcYO27uhD7iRskRvXaVozThSKWt9IUfnbmWyeoycX8uSsyrMZWj9KiCpKAmUTwyo
	 xhPyWStPkdsxkrtee9a0WcwdHYGgW0pIBbG5he8anh7XY6cOwHk8rOxr4YVVt4obxg65w
	 293ypO6OEzKlCtJ8e+vymz//F05/8fF4FoUH/yCweog5wta0h9Nd8szWXPhl1ikJmgsi9
	 21Ief7HgwjTXL5k4SgGJsKdd3kW013K0tVhZxxQDghzoJ9uM4FvBtLLD29JUkM8Gh7VGa
	 XnhFMaXri0feW1sEO3/VSE0d+o/Hqg+f4uH7AV3iROQqXd/QRQuvgsWO9D2sgm/iBWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrE9PupD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA09606A332;
	Wed, 18 Nov 2026 17:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrE9PupD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA701F000C4;
	Wed, 18 Nov 2026 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023322;
	bh=bJCALfLQHTtX+YVlUYUtD2e5HMrSgmiRKBQ9SMZHExQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrE9PupDhP2IGMjOzAnh04X3Eh8HsxngwwNiQIzVbuH5DXuQY/gL8zc8x5AHoojng
	 gwp0sH9zp10SPdHFW0TR5HnFAtUN0imbOw9+w7D2ftHnUn78vfQSWwPF+x/9HiqZLB
	 3bgHV+G3x/vPwDSav0qkHKZm1UD9LAAXf1mrPjuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0327/2151] scsi: mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
Date: Wed, 18 Nov 2026 15:34:22 +0100
Message-ID: <20261118150133.901898756@linuxfoundation.org>
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
index ce02d88f5e160..adc70d0e7ec67 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2538,6 +2538,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
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



