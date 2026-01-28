Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356D8302779;
	Wed, 28 Jan 2026 16:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616056; cv=none; b=mYFH5bf+/SFVNXSFcc9tOBd+NHj7pFGPO1PFocQiiGMFBiV2et9CgfCHnENadSHz+bQTelKYztccJyiygZCFgy+/XHWh6O0bRqmH2CPO50FJ7H7tBxoHERPe11A7Kr9QGCmQ8us9kTcD+jjqEiYb37JYJo615Sryfn9+EBsmL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616056; c=relaxed/simple;
	bh=JQa8Cba617G5DnuPPijoon7tGmscDZgwjH0FAWWGklw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iugu8CZ41qBjUZCZRl941LJQh25mfBVaiInSArWryQ7PBetAeq2rHfFkENQh51yIDaM8fidB78NxMojKxld+rpuuhHPbiqithNsFSCn0ObGeFe8hY92brpi3nc5gjnT7ly7WLp86YM2celvh0+t03AoXVOF9haVYV8iaE09/Nzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7lHS1OA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7lHS1OA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CFAC116C6;
	Wed, 28 Jan 2026 16:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616056;
	bh=JQa8Cba617G5DnuPPijoon7tGmscDZgwjH0FAWWGklw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7lHS1OAngfIxRXQHnloKsSvpCIxtckvXazmwZD3euvXXilIInY2oacbQe/GVHY/o
	 4ssZZb+lWoSd5+xA+wYI4FQaLDKbonc55851jAakaPJTWvHoA+OLvkiEPM9VnSOIWt
	 qZ71jWT7Xo11NwlMT9dtR12PXdnHKX4KXb/+2HOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shen <shenyang39@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 6.18 193/227] uacce: implement mremap in uacce_vm_ops to return -EPERM
Date: Wed, 28 Jan 2026 16:23:58 +0100
Message-ID: <20260128145351.391471633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shen <shenyang39@huawei.com>

commit 02695347be532b628f22488300d40c4eba48b9b7 upstream.

The current uacce_vm_ops does not support the mremap operation of
vm_operations_struct. Implement .mremap to return -EPERM to remind
users.

The reason we need to explicitly disable mremap is that when the
driver does not implement .mremap, it uses the default mremap
method. This could lead to a risk scenario:

An application might first mmap address p1, then mremap to p2,
followed by munmap(p1), and finally munmap(p2). Since the default
mremap copies the original vma's vm_private_data (i.e., q) to the
new vma, both munmap operations would trigger vma_close, causing
q->qfr to be freed twice(qfr will be set to null here, so repeated
release is ok).

Fixes: 015d239ac014 ("uacce: add uacce driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Link: https://patch.msgid.link/20251202061256.4158641-4-huangchenghai2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/uacce/uacce.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -214,8 +214,14 @@ static void uacce_vma_close(struct vm_ar
 	}
 }
 
+static int uacce_vma_mremap(struct vm_area_struct *area)
+{
+	return -EPERM;
+}
+
 static const struct vm_operations_struct uacce_vm_ops = {
 	.close = uacce_vma_close,
+	.mremap = uacce_vma_mremap,
 };
 
 static int uacce_fops_mmap(struct file *filep, struct vm_area_struct *vma)


