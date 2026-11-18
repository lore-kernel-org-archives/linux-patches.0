Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039488;
	b=2yr1OKVpQ4/a+jfUt9HWN7E0Ky4kqBF+Gtb/v0VmMbVpA1h1g60PAIs8uxTdG0AoMlls
	 GoamTQEJadprUU8T039ZyLurhTuDt/v4iTx/LODCfeKNBNj+y7MIGgOi6j8TUMFb5Kw9z
	 +/bBjKx2c0dnMrih/XSTrifFhsXFkNVP/Lc5eDzxGV7ARbNxWR2B/0m7tyFj7rPHj1ESF
	 /6f+/qcBMiJhGCzwggmW0zTpF88SuXmuxh1X3arSikL49MHCrG1Pu8RH4m1+UOkoddkQ9
	 9plSl8H51z2809TabXv2n1bKOFc9+WF90USlhZjuiaHC8kK0n3DdfFe2kMyFfchD5kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tZdITqcdAyRUuuzO4AKoWl4k2jTdpBvne7XNvfGqK8w=;
	b=tqy7RnVWNP5zsKfIiORBWM6WA1G3bJqdHLdXsN801ihR+6ZYP8Hbr2Ipd0nYS1N5f7ra
	 nFfjFb8lQvoo9F0ECwcDa81GNwoBrO8CmzCCG74EnX4winPgFHhXbMVD50vP12+ulqFbc
	 eHnGDJ07Qzf5VMm4Y4cC8Jt0E7laMU6C4mfVlMHZxFqSwJlFRWldbL02K+KdlyKydtPml
	 5eMkXBXDtgCOX/SIv1S8T7QAk+u4kS0N16JJ+a2WXd1OKJbL3Jnimqbk+aM4TXEuTkwpa
	 YrJA6SgqkjYE6mvsdXGxlWsexlJgfACtaoK9j639L5f8Hw2beSqMZSi5FeKdRRtPlkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6I4rnBH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC77606A31C;
	Wed, 18 Nov 2026 22:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6I4rnBH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8941F000C4;
	Wed, 18 Nov 2026 22:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039487;
	bh=tZdITqcdAyRUuuzO4AKoWl4k2jTdpBvne7XNvfGqK8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6I4rnBHusYMJJOinY6Zs1nL+UnRft7xDpE5a5VVb7xyI3ZiIQ5/xvmsvMeKOLLl3
	 zb6ig2DAJG3OYWaGEcmOxCjXnmuHIvVLW55xexgfEC0g2qb/qPSrGtE1j/x7FdKed+
	 8ykSkEmCBqHRcrBuk0kH0VgDFJDubUSNhX28DbmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2118/3318] scsi: mpi3mr: Fix buffer overflow in BSG passthrough request copy
Date: Wed, 18 Nov 2026 15:45:40 +0100
Message-ID: <20261118150425.605285978@linuxfoundation.org>
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
index fdec01d4bcee3..8667f943f94f5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -960,7 +960,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 
 	struct mpi3mr_ioc *mrioc = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
-	u8 mpi_msg_size = 0;
+	u32 mpi_msg_size = 0;
 	struct mpi3mr_bsg_packet *bsg_req = NULL;
 	struct mpi3mr_bsg_mptcmd *karg;
 	struct mpi3mr_buf_entry *buf_entries = NULL;
@@ -1099,7 +1099,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
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



