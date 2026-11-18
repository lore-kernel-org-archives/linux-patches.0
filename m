Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023320;
	b=pmr0v41ctGlkFPrUWvEjtJAzpv9Zk5YyMqJe3my6gRqy75vGlLp8FxDtq1NAU1o14+M5
	 osZxqD6OaoEZ9BlHb/CiKxhqJTQj49UMM3r3RJdmCeda2A7q+qArxDYKoE+3Aq2havgow
	 R3FEss55nyfq5mtFZ8RC9JzFgTLn5/H8+jQLaCe19uLBWG2VO0qvBVg0DILRdtN6lRtMp
	 5fp9a+9FD7SZDCUAOzBwdpvtjwS+qkAZYJ6+R84a6EmIrrLXm0DgGn2t3gYVXr1UVlzsl
	 sKQSnt2xKMbJa/sk7k923AiAta+oneCaeq/wAX34V2uOXOVrcu11fUI5lO/X/Ilds5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SxF+Qttpw5tZ1pSfhGEeewxm2HufNF55irrCgX6eox0=;
	b=JWcI2wFeKn3YXQfjPF6bXkQTm226s08oQV7pn07n9c9wZ02htzL0lqjLU+kQMkYg+BMv
	 vAMAmf1My0pKqmvbVYs+XUh2Mkpcbz5OOKfKphvoFxzhHNvC/rYF4rjByWqoxN/9P3jIj
	 RGzODSchcyCS0wLnZ/LW/mf5BFsuLwsZlp/EDqCwJ0aOSB0+5RLRWTEkEctuYPHaPmVO+
	 q47bJSHN/8NsREWCS7bff4gkdrG62xb3GUM3q1TeW+OAoQAAP+zzfndLwcv4+d0xd4xOO
	 qQQ1XJxcRFtZE+gkqui6iHhasAWpCuh9SAZcEIZnoOVPHa/Me9Hyo90eEhVgBEbkiaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boOF8YA3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA757606A320;
	Wed, 18 Nov 2026 17:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boOF8YA3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464EB1F000C4;
	Wed, 18 Nov 2026 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023319;
	bh=SxF+Qttpw5tZ1pSfhGEeewxm2HufNF55irrCgX6eox0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boOF8YA3bODULUKrzMdGYMHr77jihWy+naP8/ZW4WW4j34yc/1pIVigY8tcBfKymq
	 WN2SUo3GqJaLquVXE6w8EX/kTbocRyoU+Bb0Vi03UTVPAcSFhrwi8fiRdrzXHAFsoK
	 ly5cdmdxwKWjgpJ3cVfAaEZ6/H5MNIKY8zVW+6Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0326/2151] scsi: mpi3mr: Fix buffer overflow in BSG passthrough request copy
Date: Wed, 18 Nov 2026 15:34:21 +0100
Message-ID: <20261118150133.865273236@linuxfoundation.org>
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
index f4174d549fe6d..ce02d88f5e160 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2384,7 +2384,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	long rval = -EINVAL;
 	struct mpi3mr_ioc *mrioc = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
-	u8 mpi_msg_size = 0;
+	u32 mpi_msg_size = 0;
 	struct mpi3mr_bsg_packet *bsg_req = NULL;
 	struct mpi3mr_bsg_mptcmd *karg;
 	struct mpi3mr_buf_entry *buf_entries = NULL;
@@ -2538,7 +2538,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
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



