Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029297;
	b=FApfx5fXlZM4ysjq+0g/Il9RbXnhZPvcORFPmbN490m1bv5jr5P2hcq1qI+Wa0/Ckx8H
	 6Lhc0/z1Aq8f7C6RQpPbA1WNrcAp6rQUxOrNpfZA6gUNT/4odJMjXNPNsrhU01XGVWoJe
	 dlw3ZxUQeLzm9c4HpE4X1JRBVKqchpzrqfrK1Khga7QaE9vXI76BvoCyNQy6PtPlKusR1
	 EPorY+dVjfK3DyYrJte4pVPcWxFVy9mrjz+qxuNSzulOn/jvUWgwByhy7bfESu4vZPTxR
	 JTJGFPI9yYvQpTAaResG3nWRetFm2AxftX0jRj21N5DyX8jQNKU/i2186eyN/wZzTCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ky8nJAyZnztc7Vhhl/n5Puw4Zz9yfoYkugAohcMjy+M=;
	b=gDZpvHrD+UBFMB17krDnyPZl2XtnlXypUxHCcQ5fLaQILnG3SsbbYSsaOBQeCP7C9kuu
	 N4fwfRp/LBtKHg4rWLatGu/bCTR2m+Wger5+g4WKo9Mo6j/nOfkHYp/jAsz4gmVC8nzGr
	 R4sTKTD3MIrb3e9amNSIXUTXSpljjC7401GqfcZnA/zGoOGOYWps31dc0qATLErNxJjY/
	 W6G7LsrvX/xoYddrY8JUmOeFwjL3TbG3JP2Y/lmR9Y/OjGrDX2F6bJ3snpyUE+NiFiQZw
	 ord62MZjkwQhfhiza2knLbbUaSI0ozqn2Ei6UdBPA8lRywRyIpbygWzt9c25ljtHRhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZNb3JIo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5077F606A31C;
	Wed, 18 Nov 2026 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZNb3JIo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A562A1F000C4;
	Wed, 18 Nov 2026 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029297;
	bh=Ky8nJAyZnztc7Vhhl/n5Puw4Zz9yfoYkugAohcMjy+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZNb3JIo9c5Wxkt06d27F3Uk2syj1SZI2uG+0NRHMZgbUo5LSAA2l1W5nRiH0EF9A
	 eBe++NffRusDLN6YvrxkiV+S+Qcp6SIK3W+smqZ6+CNdHVLMovRlmO+x/hV/OcbOJq
	 QogLoy2I+ECu94520y4ttYh7xPihL8JcArp2ic74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0299/1756] scsi: mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
Date: Wed, 18 Nov 2026 15:40:26 +0100
Message-ID: <20261118150020.258122833@linuxfoundation.org>
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
index c05b8d0d1a5d0..74e003e540535 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2453,6 +2453,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
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



