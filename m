Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFAC196C7C;
	Tue, 26 Aug 2025 13:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213991; cv=none; b=ZygF/65PQTYhHjR+rRnoZnQ5+7i80kIJ7wEKHGd2jgWWZ4IgULi5Hck8NSOi2kG5kPwB1qamyMaFs5SeNT6WtMbXBXl24tm57aexMbbQ8V7aN7aItaIGHaL/3qgvnVQIBK5AtIcjK3ubhO7w7AAdtOZB9NR9xjp0NhirTof9Dzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213991; c=relaxed/simple;
	bh=Iw7jweKngYcYGIkp7f4RDaX8d8dzch0HT6D2KF2/kvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMNQyG30fqTDj80BiXqqqsFUzaCI4nWtfGm8duIAlC6G1gxH2qDzQsLk1tf2+KP/1DNAkhpDwT/5KYyRu/z80yLv4FTCgJDQ+NnqfDj27ZYj0X77tO+cjUE0H+NtOTQqwwS30gjokJuGRIfBpqSKHSBuPvwM8IJ5qVN8Vh8ycdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdsmQx7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdsmQx7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6788C4CEF1;
	Tue, 26 Aug 2025 13:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213991;
	bh=Iw7jweKngYcYGIkp7f4RDaX8d8dzch0HT6D2KF2/kvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdsmQx7HuXB6lfXR4SipYjxhRR+w5a1ImXVdAV31n0fGnAhK0Tw27i495Ns8GPwRM
	 2tJ3koTm0GU8saZCe8MYat8H8q8Hscywsxyj5IM1o8/AQyBAZqcfZrUPTX1Xo8Es8P
	 p5tJ1tA90fkTnef+UAJSwlXLx4ncMWT5NnGTfMVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 557/587] scsi: qla4xxx: Prevent a potential error pointer dereference
Date: Tue, 26 Aug 2025 13:11:46 +0200
Message-ID: <20250826111007.194503274@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 77c28d2ebf01..d91efd7c983c 100644
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



