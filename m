Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039513;
	b=0qNvDU4GU6BD5vRRu1zQvX86fg0GVINgQBKp4oJFICQsC6ALel2giXXx8xwwEUr/97Y+
	 rrinY0NadeZaavm8uk/fjXw8i39N8Q56ej7l+CvzszL+re7rWGztHKe+27zbPRSWZl9o9
	 TZgPi0vIiahkAmNYRCVH1muD24silv6rHSM0DXfqw4V+GcQ+s/9f1AVvEVb8HAeatBKTU
	 R0WYt/vHpDx2cZSayJMtfMN6nzg+Uocj7tO6BmR5p5cH4wujXkdWGaJoA/v4ftZi9S8yH
	 H7rQJe1ZLSzAMBwZRUV1cXO5JcAJ6BDFuKj+DXsvC2nTgdkcavJaGF7em7GY1lsh1Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8/JcNiu59oV1dsdL9yrdfkwsSeajXROePeUPX0b64OE=;
	b=SGDdx9ZR5nfiHtdZyoh3VM4Gm2bVwOF1a+hEZXFiY1AFMVs608WHvcIBv51rhLsRS8IP
	 Ke7MSHKwxmJePclgq3RA8TieDOUOkAomlNU3Bjm71YeG7YpmgMxsIPSX7Mk4J1XIoz+EM
	 RZES16uKfiy+yvkeMbrgZyqDYXee9J5RjTS08h8g/5s47YMID28Ckj0EO53pSJHsFbA/F
	 0IVZs0jjy5RgIgXIae94aAmjkUyYbLrubDYfJvosg6eBWlqC9tvKf9sjywHta8wx4ewJ5
	 Bq0c22LMeqOaIOAl0j3K9e4vOpT8Y8I5hGJDDP9aNuaRg54Vm2DlWpYSOIGf5y6T2zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTAvG5PP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAC8606A32C;
	Wed, 18 Nov 2026 22:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTAvG5PP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B972C1F000C5;
	Wed, 18 Nov 2026 22:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039513;
	bh=8/JcNiu59oV1dsdL9yrdfkwsSeajXROePeUPX0b64OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTAvG5PPrP5uhMU1HjXPw7DQjYsrmIXhuqHZe7SRfYfiwxO/IKha5uxWXk3eMF/76
	 ksVkpXQI8q6kM5WdhiBfE+oojGBF/n0c9fUXbi0x/FeqQpEKQCfS23WFw8bmWq9UMz
	 /xnzO25EvkPkT3JQkEpNDd6PsEcYI2sGRjJnGtGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2126/3318] scsi: mpi3mr: Fix target device reference leak in device removal handshake
Date: Wed, 18 Nov 2026 15:45:48 +0100
Message-ID: <20261118150425.842966198@linuxfoundation.org>
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
index c6d59c3d09595..19b6fb752c236 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2307,6 +2307,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
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



