Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025407;
	b=0+mBnPsOBKQaSt1iwssYzSBtey+gitLaUiKH/GnbSFnPGp1ZvykCIpWJxnn7arzJhfN+
	 /piDw8t2d2wqrik14djvgijmetez95ZoJsl4feip+gQDEh2C7FYeAFM7lLEH0/cLZrnO7
	 vRD3R1RsIvfxKm7ervirssVXjnpu1J5FjUnyvJl5TuiR7HRhfRrLBtghERVzWJoQ/2OVJ
	 NcQ8QYJQ7hQLT5H0SYnCIrrASU9ioWCUfORJ7Oo2Y2chMjbLPN2xljA2JyvjXeTQAT3kX
	 BWDGP/AGO7ds11c/KVAmquzAlLy7bjXAVJNR/qLXVVlCgSU+eEOhGqo2NFE6W+FT5HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3wV29IIkLUrT3Yuvc2dd9u1/SEyIDsdylBqL7GEnjDE=;
	b=pNH5/9hMw2jSC/GqpVr0589Sqv3bHeWTS/OZ4B+i4rMxPqL7LaDwDZelh2hzf2uMxAL6
	 oI6RLDCmLqxF7kWiNDRiJRvOp/+IaLAUmnPKvGip5taW2wPXUEWnufD/8FA+GfyPVyJaE
	 y+aR8JnF9gZ8Sr52HGPwzT9cCTz7Bc50QUa373GHlcEcjnrd85Y5MaB6dBPZJcHI6NJn2
	 zelEx2kyS330nctqysgzlSfdpY5y4I3IIXDLpmJ1zHPAK31B0oPLHXgFywA0HFiQtopTO
	 LVuM8CoTa2sAOVLGyR1KOogvqlTknX5BM+uMboMdKzyBnUdtNTcyB4G2t0ogJRH51jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmrsTVzX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ADB606A31C;
	Wed, 18 Nov 2026 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmrsTVzX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8071D1F000C4;
	Wed, 18 Nov 2026 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025407;
	bh=3wV29IIkLUrT3Yuvc2dd9u1/SEyIDsdylBqL7GEnjDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmrsTVzXVF/5MythtlwWYKvWojfiyCuuZjGQiaQQOI+4t6usf81QYbo62mJiGdtKA
	 HYPxzx6Qs7RcN1bYDvbZH0N5j+ir02wmjZ83+QPfO43zVpLWCC9Qb7YG6gjqfPOkGe
	 VnrEtMjxFu0Jn2fD7nZUo5jyRSsAvjv3h6fJfcOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1017/2151] scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets
Date: Wed, 18 Nov 2026 15:45:52 +0100
Message-ID: <20261118150159.455512522@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 92feb036a2d33c7b78b8daa2384f5c70d6679a91 ]

resp_write_scat() computes the length of an LBA range in bytes as a 32-bit
product, num_by = num * lb_size, and adds it to sg_off, the 32-bit offset
of the next range in the data-out buffer. The product wraps for a range of
4 GiB or more, which check_device_access_params() allows once the store is
that large, and sg_off wraps once the ranges add up to 4 GiB, which neither
their number nor their overlap prevents.  The ranges that follow are then
written from the wrong offset in the buffer.

Make num_by and sg_off 64-bit, and pass do_device_access() sg_off capped at
the length of the buffer. An offset at the end of the buffer copies
nothing, and sg_copy_buffer(), which takes it as an off_t, is never given
one larger than the buffer that it copies.

Assisted-by: LLM
Fixes: 481b5e5c7949 ("scsi: scsi_debug: add resp_write_scat function")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-21-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7d462ede0e11a..aaa530f9f6c6a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5076,7 +5076,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 wrprotect;
 	u16 lbdof, num_lrd, k;
-	u32 num, num_by, bt_len, lbdof_blen, sg_off, cum_lb;
+	u32 num, bt_len, lbdof_blen, cum_lb;
+	u64 num_by, sg_off;
 	u32 lb_size = sdebug_sector_size;
 	u32 ei_lba;
 	u64 lba;
@@ -5152,14 +5153,14 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		num = get_unaligned_be32(up + 8);
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, scp->device,
-				"%s: k=%d  LBA=0x%llx num=%u  sg_off=%u\n",
+				"%s: k=%d  LBA=0x%llx num=%u  sg_off=%llu\n",
 				my_name, k, lba, num, sg_off);
 		if (num == 0)
 			continue;
 		ret = check_device_access_params(scp, lba, num, true);
 		if (ret)
 			goto err_out_unlock;
-		num_by = num * lb_size;
+		num_by = (u64)num * lb_size;
 		ei_lba = is_16 ? 0 : get_unaligned_be32(up + 12);
 
 		if ((cum_lb + num) > bt_len) {
@@ -5190,7 +5191,9 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		 * Write ranges atomically to keep as close to pre-atomic
 		 * writes behaviour as possible.
 		 */
-		ret = do_device_access(sip, scp, sg_off, lba, num, group, true, true);
+		ret = do_device_access(sip, scp,
+				       min_t(u64, sg_off, scsi_bufflen(scp)),
+				       lba, num, group, true, true);
 		/* If ZBC zone then bump its write pointer */
 		if (sdebug_dev_is_zoned(devip))
 			zbc_inc_wp(devip, lba, num);
@@ -5201,7 +5204,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			goto err_out_unlock;
 		} else if (unlikely(sdebug_verbose && (ret < num_by)))
 			sdev_printk(KERN_INFO, scp->device,
-			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
+			    "%s: write: cdb indicated=%llu, IO sent=%d bytes\n",
 			    my_name, num_by, ret);
 
 		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
-- 
2.53.0



