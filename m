Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EF0481D1;
	Mon,  1 Apr 2024 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990533; cv=none; b=KSr3z8r8FJyK+8MNeEVpwFKw79U4DWmn6/g0gfZJ0Z0foQGKxDryPPMPWY8g3No/M7Glaz/GcuSYP+Xkni2uu2qUjD3Eax6NrIinrLPkpH4Yg2ROxis0K+XSdmHBBcQrI8AGuldAWF4gH7H7hxIWSbzEz+v2ZJbN3DtwMMQZyBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990533; c=relaxed/simple;
	bh=ie9IvmnSvCYd54UBesnNctHhlICAx3sEeSMX9UMZprY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbYS0oQEw07+6PdXM2z03wl9UWkNxxg2GbNmNV2rMNSwsl109bPne3EXTkoeR+bSpdZMRzMbAG83c0m0y2w4lXbeypi44qE+byzXyXSQZmYYHsA0QpxW0PE2jUC4gXRNJgW1kYstSUtb8VARQUSjRLP50905Wumd3DDjN03xVC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTeEf5tF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTeEf5tF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C99C433F1;
	Mon,  1 Apr 2024 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990533;
	bh=ie9IvmnSvCYd54UBesnNctHhlICAx3sEeSMX9UMZprY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTeEf5tF9s9JqsPN/9pGqmNAppXDGpCwDUcOD9wL+zpSkQqE1x3baeNYcFnsq3+OV
	 2gyxwZtlTUHHpO5HOtioa397bZ32+l5k+zdbly+kFM203Upx+fS8KnNp0hw4eMLuXe
	 MJ7kpsResi0iPHD8e5ab3W9lnxx2sX97sPzKS0vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 384/396] scsi: qla2xxx: Fix double free of the ha->vp_map pointer
Date: Mon,  1 Apr 2024 17:47:13 +0200
Message-ID: <20240401152559.364937128@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

commit e288285d47784fdcf7c81be56df7d65c6f10c58b upstream.

Coverity scan reported potential risk of double free of the pointer
ha->vp_map.  ha->vp_map was freed in qla2x00_mem_alloc(), and again freed
in function qla2x00_mem_free(ha).

Assign NULL to vp_map and kfree take care of NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-8-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4601,6 +4601,7 @@ fail_free_init_cb:
 	ha->init_cb_dma = 0;
 fail_free_vp_map:
 	kfree(ha->vp_map);
+	ha->vp_map = NULL;
 fail:
 	ql_log(ql_log_fatal, NULL, 0x0030,
 	    "Memory allocation failure.\n");


