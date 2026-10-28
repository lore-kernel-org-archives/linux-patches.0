Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217335;
	b=Vl15/Z8doG9C5G1N+/M3ISmOnffztXsZtlCdq1+hE0Yh1hZL+iI5fIZ387UtME5mp1vU
	 Z1pt/nHrqSVh4yg8xEhj7xcH8WouROD/MjZtLwnZT1Y8efrOnopsKQHod4AofiPkS7NqH
	 553pzR/AbVLPcEOIK9veDY4teT1bvXGjvAnC+ABj1MbmoWUk3akCvVtzdnYDUbK+EWskI
	 4YwpwOSrZQJH8Z2MfueW4HNqHBzjmXj300/HONGYgRnRcHgVV7l8+8uBCRVEMzgd+OowS
	 TOSUMJoUMztWen/g1ZCOmxJr2JPTXIfHdzIWheXvFmllxQzBMzrz+PFQNGvBhxqJ4lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M3ME0L1ApH3nRL0mpFbN68VshaFa+0I3+nJLn0aBg30=;
	b=rvIx61AhflsM9MCFRFrzelZByfrOntu2bPqSaLytaOPHmfnKm6vz2nJTdtp+42bevkta
	 myBynm/HlKMrglIyuS4+lderpM4rZ07ur7uYWlg401t2ORg9V2MyXggAUda3wmys9IfbL
	 PBwVx2Y9QNio95WTtjwO7/X9cFGKEXSseYsno2TrlXCSvwiD0w641T4xa6Z4ZQv3niych
	 /xrMChnG1UNiSp/wxp7VJ4871uXoIBWV6hdpUq+WhLjPL5JIUw8hhemBadTELdYEYZBMv
	 pmTvAUlO5OOByHViGDwtQVd/NiCboCKUrxRx4DSbuvbOtpWaSEJjap2zY4cKk4IYqnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJKmnpSN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0715606A31D;
	Wed, 28 Oct 2026 19:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJKmnpSN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA6E1F01825;
	Wed, 28 Oct 2026 19:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217334;
	bh=M3ME0L1ApH3nRL0mpFbN68VshaFa+0I3+nJLn0aBg30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJKmnpSNbhvxpiPkUa5VJWxTq5HviOq2hDFemN4El0d9tw4kYdlOOEEYwsInE9Ubb
	 2BMth1FDZ0+fdMbUT/y5cEBD52f79xzUMKdj5Oo+kCgh1RDgVKo/ytLg7OZfAdUkn+
	 XYF2527g+nMRgj5o4MRijiwil5JrcmP+iFuKhJbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Igor Pylypiv <ipylypiv@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1867/1887] ata: libata-core: fix cancellation of a port deferred qc work
Date: Wed, 28 Oct 2026 18:06:03 +0100
Message-ID: <20261028170541.939270698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 55db009926634b20955bd8abbee921adbc8d2cb4 ]

cancel_work_sync() is a sleeping function so it cannot be called with
the spin lock of a port being held. Move the call to this function in
ata_port_detach() after EH completes, with the port lock released,
together with other work cancellation calls.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d171b5815b60f..675eafc8a023f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6115,10 +6115,6 @@ static void ata_port_detach(struct ata_port *ap)
 		}
 	}
 
-	/* Make sure the deferred qc work finished. */
-	cancel_work_sync(&ap->deferred_qc_work);
-	WARN_ON(ap->deferred_qc);
-
 	/* Tell EH to disable all devices */
 	ap->pflags |= ATA_PFLAG_UNLOADING;
 	ata_port_schedule_eh(ap);
@@ -6129,9 +6125,11 @@ static void ata_port_detach(struct ata_port *ap)
 	/* wait till EH commits suicide */
 	ata_port_wait_eh(ap);
 
-	/* it better be dead now */
+	/* It better be dead now and not have any remaining deferred qc. */
 	WARN_ON(!(ap->pflags & ATA_PFLAG_UNLOADED));
+	WARN_ON(ap->deferred_qc);
 
+	cancel_work_sync(&ap->deferred_qc_work);
 	cancel_delayed_work_sync(&ap->hotplug_task);
 	cancel_delayed_work_sync(&ap->scsi_rescan_task);
 
-- 
2.53.0



