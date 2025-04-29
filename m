Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E495D216605;
	Tue, 29 Apr 2025 17:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948723; cv=none; b=OiMahFkyga5pcx/kgfN/zbVO36GFRwqKvNk3Ne8s84VtjOjo5XKjB6yUka00ww1lJdnAEYJoifxOWFKZ0O8rU2VnbPhNQgDiIlMxNBeu98dNt47HMY5NdxEbqkbDXVfLvgjgw+/xSHXYC0eqyk+LhsljieHOtIGtjDKwmADhn08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948723; c=relaxed/simple;
	bh=/M3ziKdwGTb89YW3MublGa3nYKZDIvQ/tfnlSIbBMU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsaGpFJluijlP+518r4E5RSv/tCB/3aFDkjB7M1k0u9lE4836Hu7AeSOg40ihyP/YwVRdv7orbL8qizl34FK7kkm2y35Hqem85HCqRfJwBH25iPkGMKv2M/SqDMYGEvq39zXlZVPtPIxSEjQprSsGyaouZVtP905f0ZEnFlyiIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cizTqoE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cizTqoE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CCDC4CEE3;
	Tue, 29 Apr 2025 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948722;
	bh=/M3ziKdwGTb89YW3MublGa3nYKZDIvQ/tfnlSIbBMU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cizTqoE5oEKLQACm4LC5vUmvYnut45e9EfE9/YQbXrUWG9ITZADbqoURD7AFh90Bz
	 PV7mzkjQHyldKnGW/VXsBF8w+WdxOty7Is/ffchhTZgcFFGPICl80JZ2dMmUPxbnLx
	 GIsChfkT3lk3r5sBmFv/4MUB1EdVLQ877nhMIOu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 062/373] media: siano: Fix error handling in smsdvb_module_init()
Date: Tue, 29 Apr 2025 18:38:59 +0200
Message-ID: <20250429161125.684409213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

commit 734ac57e47b3bdd140a1119e2c4e8e6f8ef8b33d upstream.

The smsdvb_module_init() returns without checking the retval from
smscore_register_hotplug().
If the smscore_register_hotplug() failed, the module failed to install,
leaving the smsdvb_debugfs not unregistered.

Fixes: 3f6b87cff66b ("[media] siano: allow showing the complete statistics via debugfs")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/siano/smsdvb-main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1243,6 +1243,8 @@ static int __init smsdvb_module_init(voi
 	smsdvb_debugfs_register();
 
 	rc = smscore_register_hotplug(smsdvb_hotplug);
+	if (rc)
+		smsdvb_debugfs_unregister();
 
 	pr_debug("\n");
 


