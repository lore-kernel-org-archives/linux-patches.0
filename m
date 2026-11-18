Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018508;
	b=IPkhSzWkql/+lgJYSOhMKVlLKovXIgm+MfdwkVDrUV8Ukdr/7V7BqYxyOWaPWQRApa3q
	 PnQmxidK213H95kpiiaQI3Fve1ATULwhkbew+MZl4j4vzSc5U9f/QOPR/g6mAz8i0thEc
	 +Q2q80I5OZDvn+TmDjCr5MJ0s2qXle/fTwynje5EPIv5yiN7xESbXT4n7U37aREMsGJJ/
	 wVZ57KAQdGeALc6zNkgYEOv/BHxtOAlW0VXhpHhAhy2AoEO/OaWvVykWh5kXxGyZjw8+T
	 XW8CRQ75JMwnsAfUAdXzw6/Kk7Blbd3dOdNlrA5sxL5aFJpPfdybDdF0QZ5k5sbY8Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yx+QIE+5JQ1LbgbF9H94diVQ0M1BNSCUj64IJSCAX2w=;
	b=LjX3fUcvjP5hQAB9vuBb2hhWPV/g4rUYOtxuEP+G+rEM1nDdyHcm0fqjL2i0LKRZRUwZ
	 gRwNaBINMO8UTexZJ6Y5x4xrlAfMMiBixLsz9+3vWv1o6epB/OkL2800VTweS0TdassWI
	 XMXStRvbhHi9YVFPeEn1WURyMrCLAsM7AugoGLFIK7xgu+BvIRrwoYeocdcN2n5bLruJL
	 PokZ5tTaYXUuvlIrhRTa6boHkvkYZwd/pJow6d89SnZ84vJJ86vVq3oYcIoXJea+LkeiU
	 Q0rYRWZrFjv5EErBVtx/zaOc4CER27CM1Bn73Jk+MbP5pGtvj2W+RrKg0jcBUuK/d6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RGYZdGmv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8547606A320;
	Wed, 18 Nov 2026 16:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RGYZdGmv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F291F000C4;
	Wed, 18 Nov 2026 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018508;
	bh=yx+QIE+5JQ1LbgbF9H94diVQ0M1BNSCUj64IJSCAX2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGYZdGmviL1pVEO44p04PJrhtXSSEkWH01OMyN19DbO3V82ezvHmPSC59sCqtT+yR
	 qQUvi7UYy8huVHOJEq89mX6s3MrGkc6ZlnNo9oeeISSCjsV/6CVdw15SLGkEISMFTO
	 tjiaIy12aCslo4O9Co/FZwYZCiOTdv1ynPwUUGPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1225/2651] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Wed, 18 Nov 2026 15:41:05 +0100
Message-ID: <20261118150332.109387674@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 63cb3900be261fccc05cadcf3402058418a5fada ]

ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2, requires a write to a sequential
write required zone to be terminated with ILLEGAL REQUEST / UNALIGNED WRITE
COMMAND both when it does not start at the write pointer and when it does
not end on a physical block boundary. That is why sd_zbc_read_zones() sets
the zone_write_granularity queue limit to the physical block size of a
host-managed device.

check_zbc_access_params() implements the first condition but not the
second. So with zbc=managed sector_size=512 physblk_exp=3, a write of a
single logical block at the write pointer is accepted and advances the
write pointer by one logical block, leaving it off the granularity that was
advertised: nothing can write at it any more, and the zone can only be used
again after being reset.

Check the ending LBA as well, with the same sense data, as the standard
gives both conditions the same. An entire medium write same command, which
the standard excludes, needs no special case: the preceding check already
terminates it with WRITE BOUNDARY VIOLATION. Sequential write preferred
zones are left alone, as writes to them need not be sequential, and with
the default physblk_exp=0 the check is a no-op.

Assisted-by: LLM
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-23-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ab2a0ee6ba290..46b3b6e1f330e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3890,6 +3890,16 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 					UNALIGNED_WRITE_COMMAND);
 			return check_condition_result;
 		}
+		/*
+		 * Writes must end on a physical block boundary, that is, the
+		 * transfer length must be a multiple of the physical block
+		 * size.
+		 */
+		if (!IS_ALIGNED(lba + num, 1U << sdebug_physblk_exp)) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					UNALIGNED_WRITE_COMMAND);
+			return check_condition_result;
+		}
 	}
 
 	/* Handle implicit open of closed and empty zones */
-- 
2.53.0



