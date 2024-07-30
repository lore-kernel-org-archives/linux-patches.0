Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDF41E86F;
	Tue, 30 Jul 2024 17:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359118; cv=none; b=bMOVnHUVGXP4mAgmsUvb7AohgQpXGk38/N7OH3szkVHyTpRHKGhpp6EikXw0aZVpITdQp75P+qKqH05e4RgT1RbUMcUT/II1qLCY14+unPWxUBuDqhyl6SmPAL0ILnxeMbjVKIKhq4DDKrJBnILxex+mxhsyoY/hBacLSc+E950=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359118; c=relaxed/simple;
	bh=t0jVXGLUxiynwLhfytpnKS6s47dyoC7ketMZZgyio9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArYmQO/2dtpU7Sy8yUJsO2ufxP4/ZMS60iZwf/DVkNvrAeaYMN6vPsByWs8nyHU2KuciYFk8n0Eb6gO9PZMoTX8lPqpj5YVlyTbVm5iJHgDFToRlgRNwwhIJ8iUej+l+LdRGeyBKDXVN/+Mq4QGAlRoGIEBFJN9VSangIiCe7cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vyurk4DA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vyurk4DA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28043C32782;
	Tue, 30 Jul 2024 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359118;
	bh=t0jVXGLUxiynwLhfytpnKS6s47dyoC7ketMZZgyio9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vyurk4DAvr/5ydDIyHyLPlG/caMJx5v2a3Pm+4uJWDXQY7YpNlqcrasyjZUYKlW22
	 h8yQTxKfsPUKaSDI000zX78MlIn14eEEYev34LKG4PdovMA0OcpMNEzTvDw4VkdaCH
	 J4gVhhu0i2L61U78N5BoZ7a+hvs0iVP8yaGtwEgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 434/568] scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds
Date: Tue, 30 Jul 2024 17:49:01 +0200
Message-ID: <20240730151656.833039963@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Kashyap <skashyap@marvell.com>

commit ce2065c4cc4f05635413f63f6dc038d7d4842e31 upstream.

Firmware only supports single DSDs in ELS Pass-through IOCB (0x53h), sg cnt
is decided by the SCSI ML. User is not aware of the cause of an acutal
error.

Return the appropriate return code that will be decoded by API and
application and proper error message will be displayed to user.

Fixes: 6e98016ca077 ("[SCSI] qla2xxx: Re-organized BSG interface specific code.")
Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -324,7 +324,7 @@ qla2x00_process_els(struct bsg_job *bsg_
 		    "request_sg_cnt=%x reply_sg_cnt=%x.\n",
 		    bsg_job->request_payload.sg_cnt,
 		    bsg_job->reply_payload.sg_cnt);
-		rval = -EPERM;
+		rval = -ENOBUFS;
 		goto done;
 	}
 


