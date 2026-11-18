Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048051;
	b=tdSIE4WvWXf8Zi8NPTlX181oL17BNMpPvMfO0HkOmbPKUk6lkqMChS7KSWJ2IMOizuIO
	 +j3ZzEaoTfFe25N8WLe3kv3tbB4JWX6+sP7Ce03m/ULY2wJYr/GbfMgnwFKnhkonqb2Op
	 0R4Kyw2QyJbbpd6jt/iOJKBmXruxxzpKcJuHDq5Pt+PHHbT/+1A7mJlJgipzlLZ0Y5F8U
	 0CFb+pDB7cxkoETfixB6wQX9aNyhLlXi3Kg5yZIaBdQboA6wFjIv5K2AyvoyrtP18kv0W
	 4DJm3CtXUU0WLe+kI4lqstRaKk6gwvS+z66UReUl6nFrt+FpzpPu1s13VmHI7ktuvUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gaWJuLQvPmlluz2jiYSU+/NQBgrLPJ6iVufbdDMpgSM=;
	b=XXJk2tMRpy9Ovwv5ryBDcqmSp9hh2ex/DSCIYyHE1KysAlrCGERG7ji5pFWdHG4LhPF3
	 A40ShJwl1+J+qurWqijUYgc9bL3c9EKpcw+dwkXXKX3tNTcamcrGiCnrqmOpSjRUubBmp
	 gKmp9M81wB2tT3j08szsqMltDrW+TDTLVgz3xbDJnayTmur4ridHTUSeefRZyzP2UQqwu
	 juUJqMaSDG5bPN3UJywP7zBhX17RIDFXbu2LvOcVxrRVB+JsIR+qyEePmts/kCaRwI8o6
	 7XrHbtc2x4/eLtGcUsAlwiZPbzQkvJhxvQIFUfqznFyXRy1g32pL5MWQdiyJwjDHUEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvs7LJMP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D59D606A320;
	Thu, 19 Nov 2026 00:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvs7LJMP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28E41F000C4;
	Thu, 19 Nov 2026 00:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048051;
	bh=gaWJuLQvPmlluz2jiYSU+/NQBgrLPJ6iVufbdDMpgSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvs7LJMPfz64oOPt8GP6HbOcBPE2lEAJwh6t30Xea5xahDaVu8xl0TRLTyq17ImKU
	 ar42EH/ENwy1c9RROS1GAsZ9GYp37UDVWU3b7ijmWlkvjcARpOrNLdgGTwS0HW4jLD
	 s7Oc0oMDt4B9d1G8Z6KDvCaxfYH+jHunF52ox8yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1855/2857] scsi: mpi3mr: Fix target device reference leak in device removal handshake
Date: Wed, 18 Nov 2026 15:48:09 +0100
Message-ID: <20261118150308.031757560@linuxfoundation.org>
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

[ Upstream commit a04b0f3a17e32aa449fd896163a7b40efc29c4f5 ]

The device removal handshake looks up the target device to update its state
but never drops the reference that the lookup takes.

Drop it once the state has been updated.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-10-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6efedf26ade18..6a19af5e66495 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2268,6 +2268,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 		tgtdev->state = MPI3MR_DEV_REMOVE_HS_STARTED;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
 	if (drv_cmd)
 		goto issue_cmd;
 	do {
-- 
2.53.0



