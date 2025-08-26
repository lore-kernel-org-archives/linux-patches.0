Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD722C0F9C;
	Tue, 26 Aug 2025 14:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218458; cv=none; b=D0x6bF401srIiXb8mHhkJMbqfDBD7mGoAWRDC39K03LTo5Yuh2BSedNd6UkCYPJ/4iPS5LPf8vNRBozxk1BPllI+EOA6Odd8J6ocpQFBPsEg1E/QBzO3Gyrq7h+Zv3PP8ikLygEyIM5C4+psD6LSJBAcWuFBrkpRGTb664yqOYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218458; c=relaxed/simple;
	bh=F9wvs114TzbqpmagzU4mgNNDq9lSARuv0ivFcWqKIAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiD+/8szGjZ3DXgKRY4TasTbFzSTbfa5rk5N35vOqH+b7ug1hTpg9Wsiu93Wu+P75A3QqgYxA1M2xUZyzYdqnrmude2DHUonog/27YEGjO+aeY7sjMLAN8JUPoLrfV2tVsb/hzZR8KAZppAL983xuqTfscEnMz40tj4WvL54vJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJVyHpS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJVyHpS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF93C4CEF1;
	Tue, 26 Aug 2025 14:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218457;
	bh=F9wvs114TzbqpmagzU4mgNNDq9lSARuv0ivFcWqKIAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJVyHpS7xfDw4/UV8seS0PGtgrs03Eyo32SK89ALh2//NCXkFhN1R4nb9KDQlk1c2
	 c4bPuM9a6P/adNVEvYaWLwqlEyK5EOYN1TJWNXcCAmymNjwuAQDvE+qw6kXVMm09pZ
	 Cc/Sb37AwJWv70pzH/q9C4LVh7Mv/jAwunOJg2zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 510/523] scsi: qla4xxx: Prevent a potential error pointer dereference
Date: Tue, 26 Aug 2025 13:12:00 +0200
Message-ID: <20250826110937.021253125@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f02d8bbea3e5..fc9382833435 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6619,6 +6619,8 @@ static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
 
 	ep = qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
 	vfree(dst_addr);
+	if (IS_ERR(ep))
+		return NULL;
 	return ep;
 }
 
-- 
2.50.1



