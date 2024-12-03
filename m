Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BECB1F890D;
	Tue,  3 Dec 2024 15:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239888; cv=none; b=TfVb4r77QHl/PrWh37n7UZgSmWuTV//H056XVZmPM7RrqPXBjgDM4ZhJrcmrmPA/me70eQ2VQdsQCpcv1PnbcYxPngphQNtL1H7nNZbSacCS1T3BpQNuJ8RCekHHPX9sJffMfOtURv8nF+zr6Zu46hmzbmQd1VccpZnCJ2Mjk0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239888; c=relaxed/simple;
	bh=GIPn5Aj/VxNDa9ENPuM8y4FRpJlNlu+rVGYmnSKFbCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qinClHPQNZMcR51jxrp2a3L/z4U7pUypxkeC5zdzXJO+tSjhGzVaj9+7H/mxgCl+B1zAoeu/Gu2Y4txDU7I8RVGYSoQ3XF7ztc1o0YPPLRfY6g/VFql4xNkuqhXy0bolLJakd1ArxSPv5ASrBKVXUqcuxYRQBFjEAzC2889A6KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGR1iaKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGR1iaKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73D2C4CECF;
	Tue,  3 Dec 2024 15:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239888;
	bh=GIPn5Aj/VxNDa9ENPuM8y4FRpJlNlu+rVGYmnSKFbCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGR1iaKZEoT8AsrSyJM8lgKN6vGsKbLQ0V5qSAVB1uX/tWXrgfWzJ6Jiu0qcxHRSP
	 r14x25BUff+AKvMa/jkkxWui/zQ+qGa0AuvxU6XM5K5R0o1stpF1JVEpQ9+cTDTQig
	 z2KNdFU47H+Fxxp+h93BAwQk6pAHsF852cmSP3Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 768/817] um: ubd: Initialize ubds disk pointer in ubd_add
Date: Tue,  3 Dec 2024 15:45:40 +0100
Message-ID: <20241203144025.988936602@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit df700802abcac3c7c4a4ced099aa42b9a144eea8 ]

Currently, the initialization of the disk pointer in the ubd structure
is missing. It should be initialized with the allocated gendisk pointer
in ubd_add().

Fixes: 32621ad7a7ea ("ubd: remove the ubd_gendisk array")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://patch.msgid.link/20241104163203.435515-2-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 119df76627002..2bfb17373244b 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -898,6 +898,8 @@ static int ubd_add(int n, char **error_out)
 	if (err)
 		goto out_cleanup_disk;
 
+	ubd_dev->disk = disk;
+
 	return 0;
 
 out_cleanup_disk:
-- 
2.43.0



