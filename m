Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E80B34DCD2;
	Tue, 26 Aug 2025 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219471; cv=none; b=dYxxz30lS6KzE5gfTQNqeYvl3fjLAYHjsFNGrN77ENhtbgs1z1tCpqn+sDDO+0zjIsT6ORfo3bWFNr5mODUTamckjYcDXMSyyQNOFGlWR0Cjz11eDWvFmosU7Uo9uweBclDaaeSc70lvqeR2HwgNfnKDKun5Rc9xn72PAe+bLHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219471; c=relaxed/simple;
	bh=iID3Ay/Y8qw5OW793618reBEdxJO1UDzL8ov4WAsRZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cF+S3nYQnbi+yxSdtHEIqt1t/tc9NFO/SrKd+3y1CUmMnmGZllbw3jEnHOvHGmK6UqHriQi0OFtspVwiaB6iN7k8pvMIHOOFd5VDnKN1+98VQnHwz9hHShe13QoB5VAUgBGkUyBNFDh0Use8FVmP9MXVXG5SWxy2vcEMWkQDwHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4YPBDLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4YPBDLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FC6C4CEF1;
	Tue, 26 Aug 2025 14:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219471;
	bh=iID3Ay/Y8qw5OW793618reBEdxJO1UDzL8ov4WAsRZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4YPBDLT3ywvg8EtMkSkSJq0r2qcGseaVRZvqHMGw0AtDDELUw61+uPGRz9u8spm+
	 pjKJLfqkWISAfygUd/S6GvRly3yWgE9OibmWTaATp5JY25j1yRkERZ6NdqttMnMIo0
	 09nLjABfWuCCLsJfF40VDbDKGMFOghnzUInJjXps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 395/403] scsi: qla4xxx: Prevent a potential error pointer dereference
Date: Tue, 26 Aug 2025 13:12:01 +0200
Message-ID: <20250826110917.946836056@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index af1c45dd2f38..4957e50b7b5d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6593,6 +6593,8 @@ static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
 
 	ep = qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
 	vfree(dst_addr);
+	if (IS_ERR(ep))
+		return NULL;
 	return ep;
 }
 
-- 
2.50.1



