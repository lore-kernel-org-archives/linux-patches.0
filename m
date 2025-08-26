Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7399C350D5D;
	Tue, 26 Aug 2025 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217008; cv=none; b=iS9Jr3QKI0HS89meTOb26kYdS8JEnCffIl5ilylz9DRnWmRm08LSdH8pOASkemjDMAZ2+LIiiwlGxTCnSFN1pTq1NmWFIx7ap5yExw2435Usd+rI/x27G9j1sJQ7akzqEMnfTj3rwKGWAPqSLz2uPESMd/AD6U1KmOen7CieZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217008; c=relaxed/simple;
	bh=GmLehD7kMGtY0JSGqiqsvZLHu79BX6/18zL+6j428FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/ZPM/SNNe9v1ntUtihLbYXyKvrp1drYUdn4e5Zuv0o6RTv7bSfy7umfdhyJoWYIKEe+MV/CW+euWPOzdGTs5xFpXsp/KEVHf/hJth3dZOiQ7CjhxaAm/0OfMoNHJh7JHyi8kwfjg9KGS5RtFRne5z3srGG6vlllqwBSEm0Tu20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haXMqXFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haXMqXFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0C1C4CEF1;
	Tue, 26 Aug 2025 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217008;
	bh=GmLehD7kMGtY0JSGqiqsvZLHu79BX6/18zL+6j428FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haXMqXFD1mDg+pCnBnGGTGfPwSL8o4gggdGOKuxsvCIWPZCOtJnZsxRuMFK4MhWGQ
	 RF4F52xTPSZlYg97FvXTD/FxeU4LVOEhE0btC38q//qWzNyAepyy/a5dG3PFTaYI18
	 /s1r9wg9WDDLSGDWgcTB+VHEg4h9F+r3kKbT33f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 624/644] scsi: qla4xxx: Prevent a potential error pointer dereference
Date: Tue, 26 Aug 2025 13:11:55 +0200
Message-ID: <20250826111002.018856513@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 9dcf111dd3e7ed5fce82bb108e3a3fc001c07225 ]

The qla4xxx_get_ep_fwdb() function is supposed to return NULL on error,
but qla4xxx_ep_connect() returns error pointers.  Propagating the error
pointers will lead to an Oops in the caller, so change the error pointers
to NULL.

Fixes: 13483730a13b ("[SCSI] qla4xxx: fix flash/ddb support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aJwnVKS9tHsw1tEu@stanley.mountain
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ab89f3171a09..da2ed81673c4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6607,6 +6607,8 @@ static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
 
 	ep = qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
 	vfree(dst_addr);
+	if (IS_ERR(ep))
+		return NULL;
 	return ep;
 }
 
-- 
2.50.1



