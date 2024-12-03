Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311291F7071;
	Tue,  3 Dec 2024 14:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237937; cv=none; b=UF4mrZFvcBTyYwwh2JLRTtAWmYHZhsuok1HI0DfoQuWSQUYQ0dDwTFZH5HVY/2B2IIB/58UA6UyAwtBAdCdWgYtg7aPoVKS1Ik6UAOnKVwDXfXato5nbwxZhJWFWduyK9FCe8rUxhO2+yeY0J83sKgZxNQeiAJckV61T/KgHwUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237937; c=relaxed/simple;
	bh=S9ZXZD5Ps/oNW7iL0Z21Bh/vpHSoxegwfCgoRLo6RUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZLznbmkH5+Zb9ULFmPwIxpsEllQrjo16S7AgZHBcRpohsAEGT/X+MtPiJZ1sJ4rz219ILrmdwpB05jTduz8B6rC/fP73x4ZBkMom+1DIcxYInjbJ+ZnS6t+bEERowszkIZTw6W45o6HUCzAhVmdM9oMx1ivBxL2lo4tF+oOVCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPth/wRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPth/wRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB139C4CECF;
	Tue,  3 Dec 2024 14:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237937;
	bh=S9ZXZD5Ps/oNW7iL0Z21Bh/vpHSoxegwfCgoRLo6RUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPth/wRSwLBJFUC0WGKvXrrSzHJmKRc5YjedDtPWhcdTwhUQDiGH/6IlsJzMfvRNj
	 TDYQoAk3cf1qh5eVMd+dv4FVGAUQEUH8Ti4PSL4kggBy78uqewBTGYbJwAISo+lyJt
	 dg5WYlL7BO/0yKLWXbsCgxAVB37oYdW+7Oh+9Dqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 113/817] crypto: qat - Fix missing destroy_workqueue in adf_init_aer()
Date: Tue,  3 Dec 2024 15:34:45 +0100
Message-ID: <20241203144000.123225759@linuxfoundation.org>
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

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit d8920a722a8cec625267c09ed40af8fd433d7f9a ]

The adf_init_aer() won't destroy device_reset_wq when alloc_workqueue()
for device_sriov_wq failed. Add destroy_workqueue for device_reset_wq to
fix this issue.

Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 04260f61d0429..a6db216f5b761 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -281,8 +281,11 @@ int adf_init_aer(void)
 		return -EFAULT;
 
 	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
-	if (!device_sriov_wq)
+	if (!device_sriov_wq) {
+		destroy_workqueue(device_reset_wq);
+		device_reset_wq = NULL;
 		return -EFAULT;
+	}
 
 	return 0;
 }
-- 
2.43.0



