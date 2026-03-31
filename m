Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBD63DB62F;
	Tue, 31 Mar 2026 16:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974250; cv=none; b=PVShvpYuz3Rx4JxpalOV4ECvl5sD2VC1vp0DU4EBnPUTssXNiwD6Qn5lEGCkdAQoDSNw7xoMsVtCg7BVHTc4R66CAv5qRHABCRY2KCPU9aQtcPqXZm083xFOaMN6/xTcj4GMpiRjDaaHUUX2eOBrjynN8wLKBSGtjpWpHizUr8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974250; c=relaxed/simple;
	bh=ue2/sFDQMy+I/wUTxhafhghbRnWoVJHI+3kia64HF1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nrdpr4Qu+adIrgtD6l7st0LOdHjoI1UyGoQYXaq50Il0NAzItLFUkBkyeqDzewqIflYI2o20jWZZtDVW4tv9+tfryof4nK1V70Ed7bl7yH8nAgFrAQXKhKS5JEXnfYTCJkvGcbywHXldXpeewKbue8w2/GVMI5joZplKU/ALGqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4QzrI5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4QzrI5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B36C19424;
	Tue, 31 Mar 2026 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974250;
	bh=ue2/sFDQMy+I/wUTxhafhghbRnWoVJHI+3kia64HF1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4QzrI5bzaRTCMFajR/YV/+34+Tfq1qjA0xhuWRfYb6lxmX1tmrInDGmTEHrzVGcq
	 02TTtSmAHdlCkhw26BmaTuG1GsTbtSCMQhAxo16kO0o3+qawyotAWUlmyJI6cNDHz8
	 lo+S+UNNV5hLfQbuQayYnXbQZsllItqq8DJTTs/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daniel Hodges <hodgesd@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/175] nvme-fabrics: use kfree_sensitive() for DHCHAP secrets
Date: Tue, 31 Mar 2026 18:19:57 +0200
Message-ID: <20260331161730.269325744@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hodges <hodgesd@meta.com>

[ Upstream commit 0a1fc2f301529ac75aec0ce80d5ab9d9e4dc4b16 ]

The DHCHAP secrets (dhchap_secret and dhchap_ctrl_secret) contain
authentication key material for NVMe-oF. Use kfree_sensitive() instead
of kfree() in nvmf_free_options() to ensure secrets are zeroed before
the memory is freed, preventing recovery from freed pages.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Hodges <hodgesd@meta.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 5963e8b695ffc..cf6fb2d51886d 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1179,8 +1179,8 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->subsysnqn);
 	kfree(opts->host_traddr);
 	kfree(opts->host_iface);
-	kfree(opts->dhchap_secret);
-	kfree(opts->dhchap_ctrl_secret);
+	kfree_sensitive(opts->dhchap_secret);
+	kfree_sensitive(opts->dhchap_ctrl_secret);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
-- 
2.51.0



