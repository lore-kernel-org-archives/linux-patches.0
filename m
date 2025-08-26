Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2345F1C4609;
	Tue, 26 Aug 2025 13:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215370; cv=none; b=SjcPAMbQB66e+YgVeMxtkch2b4lB50VZysULxjyKxLutGgOUzympC34WgbI4YXqnOi5l8UF822h5EaZrwK2DcPoj+sBVzTAvEMOX9FDA7KN7NPHKC+s/BijgKhOPSaNxAGrVtWAvTwSxjwlG8gDDRbUzBR9KkYO0XHkNHviBptY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215370; c=relaxed/simple;
	bh=KPkyyqKggILxzPI/COj7g4ky+ALokofwin/7NPD3bmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlBayQta+OMqog0sAVB9r09OcZKguun8+Y6f0kLyQElXU6wnzx+ppyOOE3a70S56CBmuQWq0cGQzX2viP5PwxfWC+jhmfk6/vtk0w0pPAol7T94TfsFVlLWJK5WMO83JWXx992BsJ04I5aZ8R4AmjnTtMgV8x8sA/BEqQyHm1As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxIunmEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxIunmEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681D0C4CEF1;
	Tue, 26 Aug 2025 13:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215369;
	bh=KPkyyqKggILxzPI/COj7g4ky+ALokofwin/7NPD3bmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxIunmEbOn2NfPXByS6ka391RQCWTC+vo7lPzxnDgg0k1xJIsebNakDISTsFupVJ4
	 jrgiyG7dI78ZOteu2PjphYCFpSc9lR6PoyqyKmEyHxog2aMvVkAP9z8lnymGuMCk+O
	 0E5K0J5aHnw9+qkvorYXTeiY4FKktlaSrIp7efB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 458/482] scsi: qla4xxx: Prevent a potential error pointer dereference
Date: Tue, 26 Aug 2025 13:11:51 +0200
Message-ID: <20250826110942.140950683@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2925823a494a..837ea487cc82 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6606,6 +6606,8 @@ static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
 
 	ep = qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
 	vfree(dst_addr);
+	if (IS_ERR(ep))
+		return NULL;
 	return ep;
 }
 
-- 
2.50.1



