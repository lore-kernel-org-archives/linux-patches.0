Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D54DF6B;
	Mon,  1 Apr 2024 16:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989289; cv=none; b=mcDVw6s7GLg59yJjEBUeVjmGU42WvrEl1V/EpRYB3OUYaBa5XdUKY1y2i2DjgcxHlvz+TKC0U8JIr042gxzfuuxu/NYcy+Uyla925HlgkmZSIuVX29pNkMl53/qZz+8/bvLpP/Nff9iWRv0mN406OF7bbLaHsPUGt6ZQuix/+8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989289; c=relaxed/simple;
	bh=lwlg5WwYN9zeIOM8lW78qAakPjP9S29C5faUumREsKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0N65DlD8MlOgcyxHe8WX5bADBgRiO+H2qTcmbKtlWV8N4aQlN7b/c5ZOfa60JS+C7SoSkuXuYpWbrzGdnwinImCCkFGnzhBcj9LUNKJyOiNa7QTYlKav/ID1lpDEj8eyKJPpN9+0NKiGnB+nQTYUfAaz0QPSIzd18Ujn21J6l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dovbPUCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dovbPUCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDE0C433C7;
	Mon,  1 Apr 2024 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989288;
	bh=lwlg5WwYN9zeIOM8lW78qAakPjP9S29C5faUumREsKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dovbPUChSWEa6+hKRnu0IaanWzsaVxyJeMEj0DGSW1+JALk2U7zEMXAn1DQcyUrQg
	 NcKLv4q8ZG/hdnRFlWf4tyM3TZMPGm+t8Gd4M6SH5V2r0Z7HEJHc5SfPUsrioarUPw
	 O/Jjj0+y9wAtOZOEiar4nYn9HZgJz+vl82TdNgvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 418/432] scsi: qla2xxx: Fix double free of the ha->vp_map pointer
Date: Mon,  1 Apr 2024 17:46:45 +0200
Message-ID: <20240401152605.876253552@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4602,6 +4602,7 @@ fail_free_init_cb:
 	ha->init_cb_dma = 0;
 fail_free_vp_map:
 	kfree(ha->vp_map);
+	ha->vp_map = NULL;
 fail:
 	ql_log(ql_log_fatal, NULL, 0x0030,
 	    "Memory allocation failure.\n");


