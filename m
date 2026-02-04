Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B9D3D3CEB;
	Wed,  4 Feb 2026 14:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217197; cv=none; b=o8wqKCLQoyjQM70DSOCe03Fw0S768syRoYgZQnrf0OJEM+HTZWqh70e2XSFrssHr7uyzZRKPJLhdG58bOZaHJdJj+zs5vTC5COebYPYNiYmuGn94kdjG03bmlVrgCjJShkzCAv9P3XZctxwRVtP2/AUPcd4VteXAhN2hApTlH3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217197; c=relaxed/simple;
	bh=l/O2jpFVYUYOfYNW5LVNO2DEbzrHB+bTgb/TC6WS4wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0nVStf1A275uY68RIXJ5W8MMrlvOojluyIZAVz3cd6ZloFHImAfSPh4SUeEdC8wSTR248Hj+5WrtQke93TOyTtLlkqY7TgRfu3qm09hl6IoN6gZtgGJHryfVDuVx6oontZV+8ZiJLb11XYjOxA5BNB1ALOsLT35EUNRRBN5sVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEoFQ4bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEoFQ4bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45077C4CEF7;
	Wed,  4 Feb 2026 14:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217196;
	bh=l/O2jpFVYUYOfYNW5LVNO2DEbzrHB+bTgb/TC6WS4wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEoFQ4bomlm2LXFdh9IzsGmVzHfbOyyzGmXL0yU5P+lWZh/0VMwm17LO7oT7uK1ZR
	 r0WmJpLbnvb+cHiFtOYbjzQ7TDpehZGjPZme30OV1eQFCtBJeziQa9ltSENBL2JP+F
	 bLiO6O2rwEzA5wJC0v1cQGBN0Jlk2/P9a/wZs89U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 152/206] scsi: be2iscsi: Fix a memory leak in beiscsi_boot_get_sinfo()
Date: Wed,  4 Feb 2026 15:39:43 +0100
Message-ID: <20260204143903.677770387@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 4747bafaa50115d9667ece446b1d2d4aba83dc7f upstream.

If nonemb_cmd->va fails to be allocated, free the allocation previously
made by alloc_mcc_wrb().

Fixes: 50a4b824be9e ("scsi: be2iscsi: Fix to make boot discovery non-blocking")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1025,6 +1025,7 @@ unsigned int beiscsi_boot_get_sinfo(stru
 					      &nonemb_cmd->dma,
 					      GFP_KERNEL);
 	if (!nonemb_cmd->va) {
+		free_mcc_wrb(ctrl, tag);
 		mutex_unlock(&ctrl->mbox_lock);
 		return 0;
 	}


