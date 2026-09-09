Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E59A55C329;
	Wed,  9 Sep 2026 14:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962830; cv=none; b=H+bb1K1+dZcQGwTEkA0JB0XrIowytGnf/k5Vare7YyxpaDf3wNMGD2dx2DgcySYAJdJ3spu7LROGoCSdEMg7Z9XEmqxQhyVBLm7hhSiHksh6HJEYE6SE1mcXZqGWed2XSaVKgUEnVIO1Gfunqbvom5MiQVwPI9jKfu4zWVC3rE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962830; c=relaxed/simple;
	bh=4KjCCWcn5niKYHD73KPy/2y37KoOoSgZGlCi0nzpmec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCWkxPtmjIvJqw6MhEGqix9wSJ1eI+gFbwcv/hpKQNjIso1DAQPk5evMX9UJCHFD0sTewG57MbFeiQ9fkf5IntJn7twO7X+2CUlSy/CITTBkCnHaVdnV1mYnuZ30/zYJyaqPxHlyxv7pbjfBcj9rJVSt+dz3pYBVJXkqzBXJny4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RziGvkiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RziGvkiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3171F00A3E;
	Wed,  9 Sep 2026 14:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962829;
	bh=hIWORxArqMtjOPi+sn5Ovc4IyKyDoNB0V4SQ/a09XFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RziGvkiAKLWlhLnpOwYvekb+LCjoSW8bNA7dTuRIMU5nGydyylQzPMQoTRQck6YlM
	 S47ML/DqHmCMjmqzUv8D/TXiIOhmBf0SMuNiwGSp1zxXPmC4CDJZgoRIydpIJxh+5V
	 97XnfbpTzqhrgnfKJKABRogU0A56klNtN/P/dkSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 424/556] scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
Date: Wed,  9 Sep 2026 15:41:44 +0200
Message-ID: <20260909134245.514432432@linuxfoundation.org>
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

commit a152edab3854f01dd2daf3eaf8f32cbabdb3834e upstream.

qla2x00_do_dport_diagnostics() allocates the qla_dport_diag response
buffer with kmalloc_obj() (non-zeroing) and, on success, copies the full
sizeof(*dd) back to user space via sg_copy_from_buffer(). The inbound
sg_copy_to_buffer() only fills as many bytes as the user request payload
provides, and qla26xx_dport_diagnostics() zeroes only dd->buf. The
options and unused[] fields are therefore copied out uninitialized,
leaking kernel heap contents to user space.

Allocate with kzalloc_obj(), matching qla2x00_do_dport_diagnostics_v2().

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-54-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2407,7 +2407,7 @@ qla2x00_do_dport_diagnostics(struct bsg_
 	    !IS_QLA28XX(vha->hw))
 		return -EPERM;
 
-	dd = kmalloc_obj(*dd);
+	dd = kzalloc_obj(*dd);
 	if (!dd) {
 		ql_log(ql_log_warn, vha, 0x70db,
 		    "Failed to allocate memory for dport.\n");


