Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF734D5A1;
	Sat, 12 Sep 2026 07:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198351; cv=none; b=kA4gWvcp8f0zPhsfhThPguFxZpyailiZZselCWxSI2AO5xPFiC77QsFOVu9PMpax+Jv8s2Td9M3cLVPywuvcEA2XYUL7SBEmxgKRafjF0Qthx6WAy+uoVlznI7ls7TdKu6pwHJ3uPUrNGF6K6wwLi1OvOVjxYz/gKCFKNKJVE7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198351; c=relaxed/simple;
	bh=ul/HtUUH/L6u7AaPlUJTtWj0umk6ju6x2fzh60/TOhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQRwo4tUlwqIkenlErLXvmCGwCESszhM7B5SadZwaCY4BPUUl2r4rHGbdCQnJQRPis0Xac9UWJo0rcApRHRdQF0DRSE7ipMYTCSaqbN25kHy0hzL9MSzaeLzcJL870QuhInQCTHDis1f/oMoVbRNtokMCZXgBkZbxOqShglvAgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWBMaGxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWBMaGxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DF11F000FF;
	Sat, 12 Sep 2026 07:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198350;
	bh=TVczL4x+fG1FM7EzRKddcvjMLULRQIe6W9nKNR6zm5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWBMaGxAzRg28MrSXGtuTF9byK7qL9O/LSAI+R3Ep5J9lN+R3OvClbuPQzcQ9WdQX
	 rvZ+MCP7WUqHgIVjrvRQfVw3nmtayYG4bws2FjUo/fPRmO928ergJjlEdlecROIP0G
	 V2EJVFSvz29FJ+pyU8b9Kltl7ftZ6D9fJGXGELdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0360/1815] RDMA/rvt: Return NULL after port allocation failure
Date: Sat, 12 Sep 2026 08:35:10 +0200
Message-ID: <20260912065657.358310041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 2982eaf3b9d2d953318c74cd6f1b7576ea6d7b1f ]

rvt_alloc_device() deallocates the IB device when its port array cannot
be allocated but then returns the pointer to the released allocation.
Callers treat any non-NULL value as valid and dereference it, resulting
in a use-after-free.

Return NULL immediately after deallocation so callers can propagate the
allocation failure.

Fixes: ff6acd69518e ("IB/rdmavt: Add device structure allocation")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-1-b9e9641268a5@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/vt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 5fa3a1f333268..f37d6d64adb9d 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -55,8 +55,10 @@ struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 		return rdi;
 
 	rdi->ports = kzalloc_objs(*rdi->ports, nports);
-	if (!rdi->ports)
+	if (!rdi->ports) {
 		ib_dealloc_device(&rdi->ibdev);
+		return NULL;
+	}
 
 	return rdi;
 }
-- 
2.53.0



