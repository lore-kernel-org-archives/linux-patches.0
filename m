Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EC4156F37;
	Tue, 23 Jul 2024 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759234; cv=none; b=M3Ev7xJ3EiS4neEMLlr/kxvja/0nQ16PSd5adfTZQK9OqNzc186NDxuOj16FI+0zr0vtKF/n2PeORNO/0uVSqlw2L0yRYfso+u6zo7KnmCPmwEqgBX8PkKpXfmTVZsdu4D6KDbxjfqjWPu9OUpec3iFtXi+6dZA7NtDuLn1B5Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759234; c=relaxed/simple;
	bh=umqC/fw6lYjhQfUB6Q9bW5ypaULukBPaI80gKN6VRIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CW4ii0kB5XvQhpt1yId/6v0IQVARd/+w8cnOiqM/5AKHb1OsEgGRHWYUvmHIAunlNIt0KGYYobTqqeQCZwS+AkHAcnkc6qc5Ez7MKfC09/qWRh4j7PAOG/2cmpFNt3tnI3io0gftMFVWYfQRfU+iOHPGADOKa+pXUaaU8QHOHbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxt5KZEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxt5KZEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57604C4AF0A;
	Tue, 23 Jul 2024 18:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759234;
	bh=umqC/fw6lYjhQfUB6Q9bW5ypaULukBPaI80gKN6VRIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxt5KZEFfRX+PuNZOrNGn25bbK68gHj5Xo0tqrUk2tp2sTxMmyWAeZ6sQKHDtL2uR
	 tAaphvitSs6J/w8yZskcv4UbCO3h7QTvOGl3Nkj6lZEg1AF8qMpsEWc8x8uTAezntv
	 EBzdTJsNOaCsR9X3/qgq+2cuoMN+SVM0dWiJ1/20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunguang Xu <chunguang.xu@shopee.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/105] nvme: avoid double free special payload
Date: Tue, 23 Jul 2024 20:23:24 +0200
Message-ID: <20240723180405.063434457@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunguang Xu <chunguang.xu@shopee.com>

[ Upstream commit e5d574ab37f5f2e7937405613d9b1a724811e5ad ]

If a discard request needs to be retried, and that retry may fail before
a new special payload is added, a double free will result. Clear the
RQF_SPECIAL_LOAD when the request is cleaned.

Signed-off-by: Chunguang Xu <chunguang.xu@shopee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 75b4dd8a55b03..1aff793a1d77e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -954,6 +954,7 @@ void nvme_cleanup_cmd(struct request *req)
 			clear_bit_unlock(0, &ctrl->discard_page_busy);
 		else
 			kfree(bvec_virt(&req->special_vec));
+		req->rq_flags &= ~RQF_SPECIAL_PAYLOAD;
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_cleanup_cmd);
-- 
2.43.0



