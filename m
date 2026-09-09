Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F0856E043;
	Wed,  9 Sep 2026 14:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962813; cv=none; b=AkbiN6vEtFtWIzlTdKtPMYxGbxZeDtqAt7mDHbXblF8qjyFK0AA7Brn2CY2dCgd1o+hwuS6yKVnpd3E60XIhQeqmw7wfNU2R/0vfbekoU58xbUzeqwfTdQUrrJsmz7E7mM6GDyLwhUKGdtVX/sVrLSyq41C17chTJovEh4jvRQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962813; c=relaxed/simple;
	bh=GCaFk8NQFVkKWQg1zahckNk3zZaur13QesFCxA83KgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlqbbggcFP+FqhmcN5nRJWHcljhP0VfihB4K/tAmNDBgm2H9vr3xPJpzbRMifiNl1qcGdIQdG8PjQMeZsnDc5t0pHECUmuhAOvqucX78j4k6+YUooTVDKvEmNbKuE26IWmlMYkdVArb4VqxHBk+XiZYrazhyhA+ujX7brZmVbf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+zqv2LF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+zqv2LF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469DA1F00A3E;
	Wed,  9 Sep 2026 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962811;
	bh=RMRO2aNXeVqX1K/U0b52XGTEZ/xlMKIPRspFHkUSYJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+zqv2LFs46zfdo4e7YzHsFO+qzqbDz4ruH3e3fobIgXQwBSO2JGl4qsrbCGVNzPs
	 9KsthVTpPO2oSNqOW8GEpMxFJPxrly+fdtdoRuZWNrEvPwExd9NdMaLE4e3yqS+ldT
	 /y8uw/Ajz3GIaLkjYAYeA5TVBb5/qw5Jjuxh+B1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 419/556] scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters
Date: Wed,  9 Sep 2026 15:41:39 +0200
Message-ID: <20260909134245.339931116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit eb137255fd7aa834c4d639ae7b5e9e8ecf3a4fb2 upstream.

In the CS_PORT_LOGGED_OUT case of qla2x00_chk_ms_status(), the
FWI2-capable branch compared ms_pkt->loop_id.extended against NPH_SNS to
decide whether the Name Server had logged out. On FWI2 and later
adapters the response is a ct_entry_24xx / ct_entry_24xx_ext, where
loop_id.extended (via the legacy ms_iocb_entry_t view) aliases offset 8,
which is comp_status, not nport_handle (offset 10). As this code runs
under CS_PORT_LOGGED_OUT, the field read back 0x29 (CS_PORT_LOGGED_OUT)
and the comparison against NPH_SNS (0x7fc) was always false.

As a result the driver never recognized a Name Server logout on FWI2/
29xx adapters: it returned the generic QLA_FUNCTION_FAILED instead of
QLA_NOT_LOGGED_IN and skipped setting LOOP_RESYNC_NEEDED /
LOCAL_LOOP_UPDATE, so the fabric rediscovery triggered by an SNS logout
did not happen.

Read nport_handle from the ct_entry_24xx layout (offset 10) instead.
nport_handle is at the same offset in ct_entry_24xx and
ct_entry_24xx_ext, so a single cast covers 24xx-class and 29xx. The
non-FWI2 branch keeps using loop_id.extended, which is correct for the
ms_iocb_entry_t response on those adapters.

Fixes: b98ae0d748db ("scsi: qla2xxx: Fix name server relogin")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-48-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -157,8 +157,8 @@ qla2x00_chk_ms_status(scsi_qla_host_t *v
 			break;
 		case CS_PORT_LOGGED_OUT:
 			if (IS_FWI2_CAPABLE(ha)) {
-				if (le16_to_cpu(ms_pkt->loop_id.extended) ==
-				    NPH_SNS)
+				if (le16_to_cpu(((struct ct_entry_24xx *)
+				    ms_pkt)->nport_handle) == NPH_SNS)
 					lid_is_sns = true;
 			} else {
 				if (le16_to_cpu(ms_pkt->loop_id.extended) ==


