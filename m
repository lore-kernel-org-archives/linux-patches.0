Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214881;
	b=xvw5HE0fF7PfFE7Q0iRA7UmaTKpsp/ca910xmamLYmbz1QG6v+kp0QEvIhueBmSX4zIL
	 pamFXsFN1HU9Qwct5+9AK48RM4pvFIOaYlX4hFTYUcr91RngPJGQGUr0D6lNmjmeuAwX1
	 Z0oa3mWANX57ScZidxteS32vGTN0D7MHKkE1tOzb7dYyDANnj/zINnW3GQVvrbbQAgMAf
	 E4chi3/bKRaw17MSjg4hsQ5Rlntdwk0MB44BR7kUgZX3+/RhJh+cClrWRR1m5qbECd+g2
	 c+YYF/U5usbBTgiYV6DmypSXSnjdOwOAfqU6pd0Wqiknm6Gs9VHPkQnZaJa0f5Bf5gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQLXVKWHuOqyxowyQcJuVSojUe3WOGocwJi8U/XBJT8=;
	b=LZYKANAts9K9Rhut0x8uPPcxWwiJWWb0c/jEyVdKd7O88MsiZ9iW4R4S2DrEaQpPypKy
	 /30i1JsLaZhJj+6kgAWx2texRUAsBE1DfbcJ1Pd8ZTmflMLy16gFjSRqBqS4e4KMoVfp9
	 Ub+vJSEjHYjdDB4JGtFMM6P/EeBui8O7V6wRqafGM9TKsgtE98wBwaGlWnk6s6pai3vY8
	 kqiTb4/qQQvuRii3XEuXqciZS7JvTDjzjas7cgMPSSj3TF+ACOqjocsa+GkrgFIK+upUd
	 E26nQSGctu0v38eMdDYjCZnXYuGjW9Fqeh+rwTI7Y7TkN6UgLFI8nKviisJXBz6t2zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p7sUz/hc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A14606AB3B;
	Wed, 28 Oct 2026 19:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7sUz/hc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5A41F01828;
	Wed, 28 Oct 2026 19:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214881;
	bh=hQLXVKWHuOqyxowyQcJuVSojUe3WOGocwJi8U/XBJT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7sUz/hcR59rfrYa1qCdQmcF13yHSNbYg5gm+Wi5nmhP5sZRLQO2UXBKWtfZ/K3Yl
	 K25zO5i+Vzl8RE6/+By8LicdUh6i29Lwb/DWFkDsfgvn2USb5qg7GhjV7ZE8CvawGK
	 KscR+MELLOW3c26lt1Zuvj4DHaIBmGRnJaRWXdmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	Farhat Abbas <fabbas@cloudlinux.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1015/1887] scsi: qla2xxx: Completely fix fcport double free
Date: Wed, 28 Oct 2026 17:51:51 +0100
Message-ID: <20261028170522.514714427@linuxfoundation.org>
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

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit c0b7da13a04bd70ef6070bfb9ea85f582294560a ]

In qla24xx_els_dcmd_iocb() sp->free is set to qla2x00_els_dcmd_sp_free().
When an error happens, this function is called by qla2x00_sp_release(),
when kref_put() releases the first and the last reference.

qla2x00_els_dcmd_sp_free() frees fcport by calling qla2x00_free_fcport().
Doing it one more time after kref_put() is a bad idea.

Fixes: 82f522ae0d97 ("scsi: qla2xxx: Fix double free of fcport")
Fixes: 4895009c4bb7 ("scsi: qla2xxx: Prevent command send on chip reset")
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Farhat Abbas <fabbas@cloudlinux.com>
Link: https://patch.msgid.link/aYsDln9NFQQsPDgg@vova-pc
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index f080e19529272..3984b42fe0dd4 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2754,7 +2754,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2779,7 +2778,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
-- 
2.53.0



