Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9E42571BE;
	Mon, 29 Dec 2025 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025448; cv=none; b=b053rYXDFWtVrdgYr6YwejK7FVh6k/UGVJ8JrVeIaDpOih/irgCFhyOoDyN5Loi/aWsKnYGHFWfIhsIBTYwSl7PA0kt1e0YnxdCFnVN39dEwYV/Yrcu23qycVaKr358uNYrvGE+QNtO+336stmsoKVCt0T9AEDFtxuuSoqyY888=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025448; c=relaxed/simple;
	bh=S/Ii30pLW+G9j2T9qI0hzW25zJYKIC5t1r1KHo+BsT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKC/yQLxqcMrmzvjVyl5ef4pJvkJQ2pO+zs3PpKVPXoE5dttLxpsQeyLMR5kd/G2K+u7QiXDIq1uB+2BBDEPtlsgYiOm4vJmfuON7wuDgIfkIPq6uAa+CliGkSC3xm/envIOwIorF2QJqcUwoBfh3Eb2C3dvW9Am9s5sOBAKR8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiqBRc7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiqBRc7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF70C4CEF7;
	Mon, 29 Dec 2025 16:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025446;
	bh=S/Ii30pLW+G9j2T9qI0hzW25zJYKIC5t1r1KHo+BsT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiqBRc7reQ+PyfVMjGz7BNdL3L8zyevuqvyNZSA9HVqVzVXhm/5v6RlsCsSZz5rH9
	 X216TPLxsQrrJuOxmRFayWZzX34Ap0XBd7C3zlR/Q/kikBlTgIhvAqtDqtIcIsigIA
	 4K7wbzxVi3VFfJNTf06a5mdtcGFIRDjWE2FQ/AUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 217/430] block: rnbd-clt: Fix signedness bug in init_dev()
Date: Mon, 29 Dec 2025 17:10:19 +0100
Message-ID: <20251229160732.338236111@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1ddb815fdfd45613c32e9bd1f7137428f298e541 ]

The "dev->clt_device_id" variable is set using ida_alloc_max() which
returns an int and in particular it returns negative error codes.
Change the type from u32 to int to fix the error checking.

Fixes: c9b5645fd8ca ("block: rnbd-clt: Fix leaked ID in init_dev()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rnbd/rnbd-clt.h b/drivers/block/rnbd/rnbd-clt.h
index a48e040abe63..fbc1ed766025 100644
--- a/drivers/block/rnbd/rnbd-clt.h
+++ b/drivers/block/rnbd/rnbd-clt.h
@@ -112,7 +112,7 @@ struct rnbd_clt_dev {
 	struct rnbd_queue	*hw_queues;
 	u32			device_id;
 	/* local Idr index - used to track minor number allocations. */
-	u32			clt_device_id;
+	int			clt_device_id;
 	struct mutex		lock;
 	enum rnbd_clt_dev_state	dev_state;
 	refcount_t		refcount;
-- 
2.51.0



