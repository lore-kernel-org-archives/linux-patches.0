Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CD13EAC6F;
	Tue, 17 Mar 2026 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766209; cv=none; b=Ma7jEWm0/ZJhHXF3N6Ayqu1o1NILUyyh4oxdyV92D5RLTwdLxHBF07Bze4uPxVLfnnzxOt7InkSP6R+dumy3Hl2dZWneN/CBcOfvnCB5AXk38e+Onp152guW9Do3kMa1mgCcDmkrKJxsyDY+g/mfNmw44sjVo16E0u7YXHKEUtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766209; c=relaxed/simple;
	bh=8wnMv+3Yd+Z0uT0qX7DbP5zS8DFdq4lAjq/6LNyblOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELXE4LAeni3h7g/vFOT+AFuORXOaaF7lSmiqsy6UcpDzAGspZKKveMyH+UDSRB0433S16b2FB2UinwpbqWE8NKcTzn6bT7csYoE7d7VaA9dpIcjWhf/nMIcJqidG6PLWYQq1c8cDXptIF0w5TcPyZNHvKdBfeam8OjN/ruVXRdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnQeNPAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnQeNPAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FF2C4CEF7;
	Tue, 17 Mar 2026 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766208;
	bh=8wnMv+3Yd+Z0uT0qX7DbP5zS8DFdq4lAjq/6LNyblOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnQeNPAkqNDO1a/4Qv5mYW8rBtNw6SeXTXizOdB4DgBpXrR7CbovSiBtUeAmqpMIY
	 TRbvWv8z7FigRC4hexzkDIIC6AlqQWdgLPU3ePPhHN1yo/kh1/qP44RJoLFKEoFnbg
	 vS03NDmQz82dJbwA12y4LTzAZXsp8DLWyUrUbcLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	Farhat Abbas <fabbas@cloudlinux.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 192/378] scsi: qla2xxx: Completely fix fcport double free
Date: Tue, 17 Mar 2026 17:32:29 +0100
Message-ID: <20260317163014.069892099@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3224044f17753..0de015de7eb59 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2751,7 +2751,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2776,7 +2775,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
-- 
2.51.0



