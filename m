Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015884;
	b=nFNrpHWMI/4csgzywo7HgQRlyyrJ0vB5I9ws+Im7C0sey954Q4Im5aYKiKft4QynilJ/
	 kcovSMpx0Ylsx2cQOdw46cZn9Yuwbn9aSHoFSLw782wz5xWUcHfk26Lsy4vNjueAdSPBF
	 f4a/xHke4mxeL1KVxvoR/crYsx1eMW+LGV8bm7i3on4L9B295Pc4golKAcVG91vdKKley
	 iiF+VwmWZVQdsqeZTBhjndxyltTkVqKN1xLIf/VrKtxuOfdKcOqTT/eqe+ypMhCwOSAv5
	 6++6e0ciAX2fE5UfwIKvVfEggcIlBSvR7iShAgqAlnyZWrHWR40KZ5I4G9H4bFfoTsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9YL0KGZgflvZ6VB4VuZGpkH+QLcuB/haghd0T02LAoQ=;
	b=oNveGIOEEavK9sml4eZXna91NAlG7zATjn3AedR3Krr3S5qLwvEEMT5SFdPUahsubz3m
	 8hOubyMzlERT5lOwhjN7vYFQi2ye3dGNM4mQD0Kzp/CXAfLj06aru7PQAciNwBeF1/4qr
	 BQGZ1O9+4uoqWxHtGlqRWbOI6wNlWLcsbOX46Vf64tDg/7GQyXKbPdA5XEvYyIKjpqMDN
	 27ryUKTapj81LZ+xJJkSq4UWpHdYN9sRgRtILBPO90Y0ofjzdJoFTe55q8LtnwfFF9sg/
	 rBftKIcJgjyb9tplr9pYwjk99rFXTkdYfaGqxeKV/1FhiaWLJITMOveCp9XT/bKPpWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pwu8fIOo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265C1606A31C;
	Wed, 18 Nov 2026 15:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pwu8fIOo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0F21F000C4;
	Wed, 18 Nov 2026 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015883;
	bh=9YL0KGZgflvZ6VB4VuZGpkH+QLcuB/haghd0T02LAoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pwu8fIOov8PXr09+jOHZbOnRrgfb7yoU11Q0OxkPi9z/nOVCI6CPWtqtfbDQNqKAn
	 7vZA9T9m0K9QRM1Ghlb5ylwjl2k9vtjMZfcPwCSdt8DxUJPA1fSDDj4lZHJpMcJeTX
	 M02YrUeGWJJHfhrM+metkVlOyARrEE/R+YRXdxBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0331/2651] scsi: mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
Date: Wed, 18 Nov 2026 15:26:11 +0100
Message-ID: <20261118150259.775396319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 42f32d1a4bdbb..a5299738d6048 100644
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



