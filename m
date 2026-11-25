Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625241;
	b=mHkPXpk9tBnqZCPfqKSAh7HJ1Zaj2hCcWZkIDriVqAaG8NenUUFi6QW+WWarKTlaTzTp
	 t8Sw2/P682AW7yFxzvJ2RpkgC4qTMugAt7/lzXVJ/BcWpCaZCqIXxDoU8jwFR+y7Xy1Ai
	 73BbXyCiFbtc2K1dI8+46hng36IzRl6Gq+EsfkJBmXC7rgmtHiOwETEcu6SBb/c3ISvn4
	 zypG2FrLkMgdR0wmWHQpb/QLcGM7oFzGBmTEPlyPm8TBU60iR8jgZ8fj8sYQ99ri5xYtZ
	 0x4kIZFzOkIswdXcAIOWxpV29irsGGT08icuyqOp8vKcLCBgqRFthRfz2cSocg63X1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sbGJK49q8E7L2Cmc8x65IEVAcfjRH6nmL4PTlTeFv70=;
	b=YnoOBI8VescDYyfrkOuGtanAJC5Xq42HAjiqs1DusUxhzpTUySbj4CcgcDxDuF/ol320
	 jSyoZ6Mbvg8DETBsHLc188i58QEEEJHX97k/lcv31cOY+p7KavUwmzCMfCGP3whJcM/yZ
	 e3l//rQ7//fGscmsCh/PB2XP7gYdhoK6S9dtdG+GpgrKEe8TOnFZ+77zdA7bvgaGsrBJ/
	 qukBj9ztdOLs8bVXgHOvWOOHTAwSEEc4rTW2qxDhhTFVgSUx6LHZZry6oVlxFPw1mlvz0
	 /9Vrhhw/QkCPo5mXgSkXaXssenVOnomG8Qw1aVtFmnBGfV2BI8upXIMaFWimCkCoXpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03n+mTt7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4804606A31E;
	Wed, 25 Nov 2026 16:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03n+mTt7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409381F000C0;
	Wed, 25 Nov 2026 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625240;
	bh=sbGJK49q8E7L2Cmc8x65IEVAcfjRH6nmL4PTlTeFv70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03n+mTt7lWgvwD71O/GASzjpOwteuyn5m89IE9vGB2hCqxzLBerva+8wsbQcffCLP
	 5FpcjYce866irBi7I1toQjgh0R8AfWZud2VFN2DPcd7mxu64GboYelkZD3qzFEBJoa
	 onPkYiHJljwdbCb1fP6zKTiTP07LkGphLaDctjeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 451/816] scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets
Date: Wed, 25 Nov 2026 15:33:19 +0100
Message-ID: <20261125143859.629971036@linuxfoundation.org>
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
[ sashal: Kept the older branch's __func__ in the verbose printk format string and applied only the %u to %llu change for sg_off. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7a1ad88669eeb..5529dcbd9eeba 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4613,7 +4613,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 wrprotect;
 	u16 lbdof, num_lrd, k;
-	u32 num, num_by, bt_len, lbdof_blen, sg_off, cum_lb;
+	u32 num, bt_len, lbdof_blen, cum_lb;
+	u64 num_by, sg_off;
 	u32 lb_size = sdebug_sector_size;
 	u32 ei_lba;
 	u64 lba;
@@ -4691,14 +4692,14 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		num = get_unaligned_be32(up + 8);
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, scp->device,
-				"%s: %s: k=%d  LBA=0x%llx num=%u  sg_off=%u\n",
+				"%s: %s: k=%d  LBA=0x%llx num=%u  sg_off=%llu\n",
 				my_name, __func__, k, lba, num, sg_off);
 		if (num == 0)
 			continue;
 		ret = check_device_access_params(scp, lba, num, true);
 		if (ret)
 			goto err_out_unlock;
-		num_by = num * lb_size;
+		num_by = (u64)num * lb_size;
 		ei_lba = is_16 ? 0 : get_unaligned_be32(up + 12);
 
 		if ((cum_lb + num) > bt_len) {
@@ -4729,7 +4730,9 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
@@ -4740,7 +4743,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			goto err_out_unlock;
 		} else if (unlikely(sdebug_verbose && (ret < num_by)))
 			sdev_printk(KERN_INFO, scp->device,
-			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
+			    "%s: write: cdb indicated=%llu, IO sent=%d bytes\n",
 			    my_name, num_by, ret);
 
 		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
-- 
2.53.0



