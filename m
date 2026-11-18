Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018485;
	b=4CVBIWoK3ZCTE+l7/bUeg4Ti+tzGb7d/N+1Z4FWEFKkX9SKf5bax5rs7E9WJtJ0dPza2
	 HyuSTkcWkYjGeszpsR0ATKJPGa3uQcGmeXOfgdhXT3Zs4cykLfIR7fl2BdrxitQ0RZ7gN
	 6AzP8XkpUc6jQSXwD3vIFZEvMSfwy0WQ7Zu4CyQOFhNtdaOo29nPnm7ogC2UK+k+882il
	 A7Bd962D3fZXaAuCa42d0nzhd0hDB9PE5bapBoDH2C7FNLfC9vpTkOm7nmbr/0TI/gIQ5
	 VcZ8SbnrUvbFjv8kwNW2tDySDMzLXp1JgM3EEx9HT/Uz9CjOUzUifeGLC0bwtftbd6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OAFDWXgRYZCXomrFsd7zntGCaKUcCzTIkuOuFWFDiYY=;
	b=krqFmC9d8fO/6MucMqeN+mUTmnDljWNaPcWhCfr+fywGB0TI+B7jOhcwwtZTBR62Xg5e
	 Oip2mlvh/C+W3UeZWoRJOzBb+o9JbwOM/BsJBZGhJcA0lxcv/myhrFPMJDZvZT0kZWRKJ
	 FY+M5zgxHC+v+RmvR13nP18BhIstDlRk7TJnMUxRcAwaDoyAGmi+ccxI1791W6O0Ea3+6
	 IqtYSLd0NkQFUEYH515t02ut1PDJr+4HXnhz5Kgx34X+kFAyVwAtVv/eiIkIkL9dudcqL
	 JigTxH17yCQ8MHximlhe+0jqQQHCPheRixXcmkpZxuhruVabUKMBvKdcVIyhy4KGszw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSJnXTap;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485F0606A325;
	Wed, 18 Nov 2026 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSJnXTap
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970CA1F000C4;
	Wed, 18 Nov 2026 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018485;
	bh=OAFDWXgRYZCXomrFsd7zntGCaKUcCzTIkuOuFWFDiYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSJnXTapP3FOLE6OR+mZ3NPBHgWBfNwHy3t21vOAAsQsIaL7IsZMOFWJZSKYgRx0j
	 g2yf1gYiiekI1yvEqcAtUMjfCNKPXN/jujZ3zGCgSH7n+UwSsB4ENRz45wS4JfefkC
	 6U/lBNK3FytrqNv0MHmhHm9lwIfdD37rYiWcWo24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1220/2651] scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets
Date: Wed, 18 Nov 2026 15:41:00 +0100
Message-ID: <20261118150331.924123946@linuxfoundation.org>
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
index 4bdc45d19b14c..c5f8cef337f82 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5032,7 +5032,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 wrprotect;
 	u16 lbdof, num_lrd, k;
-	u32 num, num_by, bt_len, lbdof_blen, sg_off, cum_lb;
+	u32 num, bt_len, lbdof_blen, cum_lb;
+	u64 num_by, sg_off;
 	u32 lb_size = sdebug_sector_size;
 	u32 ei_lba;
 	u64 lba;
@@ -5108,14 +5109,14 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
@@ -5146,7 +5147,9 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
@@ -5157,7 +5160,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			goto err_out_unlock;
 		} else if (unlikely(sdebug_verbose && (ret < num_by)))
 			sdev_printk(KERN_INFO, scp->device,
-			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
+			    "%s: write: cdb indicated=%llu, IO sent=%d bytes\n",
 			    my_name, num_by, ret);
 
 		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
-- 
2.53.0



