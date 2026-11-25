Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625243;
	b=YoW+ExSWMCkmlqqYo2jbFwebwGjvhjmFSWyC9cvPGn3U01A/7R5Pl0Frmk3lNhxfWuGU
	 8dLqOvZ6cof8psT/R5dLWi6TLP6oFMdu+zOQT16E+YJ8pHwwO07iEIwsp+wWh6Wks51KX
	 IRjA2ggEspEyKAFRjkaClbvT953B/5PdEc7rOksBeizHa3u+oEUS5WmcNBqyNsFs2WYmH
	 ukHR0uODs870TG0v+5BoWlJxPYipBSFDt95qVKxtNmiQEOPgG5zE6YLsqXCfk1F/EY/VT
	 5PFF1On3kLOpLvh/Ke2WwGQQkX98qr+gFtGMPVnell1AZbiIspGyKNH8J4AQDe0qQ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WT2NH8JSDERMODKFUO1K59xcIzdaLJr2+JjuPAxP/1s=;
	b=FNyYr5hPL4a3X/M/qjCBkv4GXWMarfAS0KJUmuQfZWJriBBs3euFNrBfDRSRvJ55ksQj
	 yVDVBXbHifOh6BXOq/UqoFg4/Trd5C2xvRgs/FK8MPW+Tn2ZvR32N/Ddci3Bmsqa6I33C
	 T5a6fj822uJGKgzLgAt/oiRCeiu1rSu1jQxdzthi5c3Cs0V5HJQfPK0SsGpg+okS5eyFM
	 OwmfFojnviqIQn97pQGxERwVxvzG92vXftmJ7mpte+cqjskxcCvbHwREeKxQJ3dJV3Jh1
	 7LGM9Ihm2Q8RSbqi0pZOcyNrAuN4PaIfsRrcQ/zedLvgMAT3P75Bb1CNoCHxeE4WHZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIXioytV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B88606A31E;
	Wed, 25 Nov 2026 16:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIXioytV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117D51F000C4;
	Wed, 25 Nov 2026 16:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625243;
	bh=WT2NH8JSDERMODKFUO1K59xcIzdaLJr2+JjuPAxP/1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIXioytVpSZv2gKKvryWY3XWhy80I8F93xYveRA8YQ4bL3WH53gGf7j4G9Y7xHknU
	 8S50UajRuqzsUm3fBge+My5cgaYiNJXNXONbFb9R5qqUykWq3cHmNPPBK9x87ekQBQ
	 X4yKzhdleIRo9ioLIxaHCYAxgidTdv0lPuwjDIBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 452/816] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Wed, 25 Nov 2026 15:33:20 +0100
Message-ID: <20261125143859.652611116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Replaced the two-argument mk_sense_buffer(scp, key, UNALIGNED_WRITE_COMMAND) call with the four-argument form LBA_OUT_OF_RANGE, UNALIGNED_WRITE_ASCQ, since this tree lacks the combined constant. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5529dcbd9eeba..ac8f313172e06 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3571,6 +3571,17 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 					UNALIGNED_WRITE_ASCQ);
 			return check_condition_result;
 		}
+		/*
+		 * Writes must end on a physical block boundary, that is, the
+		 * transfer length must be a multiple of the physical block
+		 * size.
+		 */
+		if (!IS_ALIGNED(lba + num, 1U << sdebug_physblk_exp)) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LBA_OUT_OF_RANGE,
+					UNALIGNED_WRITE_ASCQ);
+			return check_condition_result;
+		}
 	}
 
 	/* Handle implicit open of closed and empty zones */
-- 
2.53.0



