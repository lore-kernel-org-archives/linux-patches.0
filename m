Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BCB1CA8F;
	Mon,  1 Apr 2024 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987760; cv=none; b=q1ZH6p6RU3+I48VQ8Kbf8i08ZDh/TENvkArFmTNbvjm6AawstnZf5mDmgkPcVforkkQQGRDUkMnP8JNj4gLRDV/Jves81dg4zeBeImvnx4HgRkOsOszVHGSgX7H1Cj38as7g62ROjZLUcALG+Cgcqm8ajiezKzgT+2AcLJiDpVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987760; c=relaxed/simple;
	bh=4S5lObOdxQzBEpwcl/YuS29x/IrLhSjc6m7CsefGgZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5IZoNbXjsfPXHU3mc4YWgRbN1I8jGtNJLxyGlDAlIetPoKSzU4LKpgxmI5YG0JZyoAsi776qPOQYbgfYh5GfQb7UZFjl/I01xG9NDUamA0gW84+epfuRTaxn8iOz/z0BZY3Y4Iduckn1m8elwjhRTl+u+usSm0yzfrVTZu2jcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDvSq01f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDvSq01f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902C7C433C7;
	Mon,  1 Apr 2024 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987760;
	bh=4S5lObOdxQzBEpwcl/YuS29x/IrLhSjc6m7CsefGgZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDvSq01fvrnpyBMEcYRhT87+wAvTo4juw8sAwJk/70AAzd9d3laUS4x5UtujFBlq4
	 BEx+Pq8UzY5m2SJ49UsbzZizEQVgkE2x9TaI5m6B5DudNhgIIYkqRglb2EoPgGTP0G
	 6LLIRznM+xnHPnD3d5Gk5JeV/VCmpakVfMT+SpMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 383/399] scsi: qla2xxx: Fix double free of the ha->vp_map pointer
Date: Mon,  1 Apr 2024 17:45:49 +0200
Message-ID: <20240401152600.607706851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


