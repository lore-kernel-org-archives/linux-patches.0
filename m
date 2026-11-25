Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622524;
	b=2Kpd85mzpsjA//297jH2gVwSOVowNKfcba+EQBp2Rqj+A56T/MebBHsqXFWy1LwiySOi
	 bkagW6DyPrtfHppJ4txqcD7k7EOgvYbWFQ1+tz3WuVFyjiFNJOutpqhkTZQ3HT4XdTXvO
	 dbsaEffpULKJCA/IKztJV2cvOf+uuJR4xmCsVmkiUyv6vzu/h/smOZA0Vo365BojOIn47
	 T1TgeMo+66FxFEGl2n+GqGW9JP84L5IwKeZLPfIqFmx89gDdkcJzuVLULHgA+tQKN3rf3
	 +CZd8ur9ABPsaE3f7arRpMdT3ul6ThpmmIfflCJSrWVyGW3miyIDWJ/B52lx6pTiv1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xb3A5MTlXi2ejTDfbjfFRa5KMeYyuUtm/EC0nhWosVo=;
	b=sVN3ZAsyr+oAVAzquy1I2nkem2zBVL6xpJepaxQecQ2fIUSw+B+ozXHVrWCFdMDOPJ84
	 +6Iw90Brpklwurpie2Nr6Hpowv+rmsOiaM6vAZ9vWHZeXGbbWt/RnTq30Ttt+Wuwx5iRF
	 1BJzB5LSjUr1vjhIGI+see8yYPq68BgEh0D5GwLo569Z+G2kSKu5rkMv4T4o+d8pR3IOL
	 3bszrkX3KWthmylnKoFGvLPd63gz7K2uvIp/fxz+bpy5fbW9db6g4RDITsE1/CwaKl7BM
	 k1IsHtdXQLabV9hSRynCCLrizDH4eSkzXDADzIdza8qnVSbA5Xxl+27uqAhjijwS6iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="stP/dalf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C49606A326;
	Wed, 25 Nov 2026 16:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stP/dalf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41831F000C4;
	Wed, 25 Nov 2026 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622524;
	bh=Xb3A5MTlXi2ejTDfbjfFRa5KMeYyuUtm/EC0nhWosVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stP/dalfNpvRVdid7wDlWF5T2h5UeT2SMc6MbLEM2n1GIfmtlEKqG4pW0Dcyz6jG6
	 C6jXIaCmcQtUkVwsZJ4dmw3fCSU5If0w5unBfoPo0SN3mzpE7Ny5x4cZ3ZBy9YYUlp
	 depy2Ozx71hZUdB4UA0MgrF6c7y6Nr5DuZQin/t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 565/990] scsi: scsi_debug: Enforce physical block alignment of zoned writes
Date: Wed, 25 Nov 2026 15:32:12 +0100
Message-ID: <20261125143835.331558958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: changed the mk_sense_buffer() call to the older four-argument form (LBA_OUT_OF_RANGE, UNALIGNED_WRITE_ASCQ) used by neighbouring code, since the combined UNALIGNED_WRITE_COMMAND form is not used here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 524e0fa457a83..60baa3a3ccbd0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3904,6 +3904,17 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
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



