Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD3443A94;
	Thu, 30 Jul 2026 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424989; cv=none; b=kqrNWFwY+ma1MLrhFJYljHBgyR5LVxFmiiMiT3ZM2ECwTujNg6Dljm79+a4ELnSjhDH6gmQVSHynRoY8BKKe4MoGvCYjMh4xC9dLr+iwRtGD48rF/2NZkwPclmGSi7lWSkUsWNIYmv70qwekfofowsj1fIQ2Lkzq6z/1oBQ/xhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424989; c=relaxed/simple;
	bh=ltx5nVPTkhBX8iUAN/ggU1U+9gZKLK7sa6//H76Cm3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2JO1ZJp8WBE9WJL/gdhVGPamaUOslVnkd9qCpnX5WUr+UzGzm3yV8C725eiODbCPgOgFmmKK8yG5poZfNOkB27hxCgI+3hMFAlfxpRyLOaBOkjrGxUxOrO4ti93z1UBKnEKrsxxUhG9KIvG1E6ghnQWmVLMO+T2K1s8Q9APV70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDAQzcVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDAQzcVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0491F000E9;
	Thu, 30 Jul 2026 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424988;
	bh=8y5WjU6nJe/RrKlB4cssziAbJF52e0mtLjL7pA3kgxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDAQzcVkvrd/Wm/NMvIcPk+Tw0h7RmHpT+KCYg/llCpo6zd182tm7P86ExI1SJqBu
	 /YJsj3lEGFjgURB5UtZ3/yE0BWcrSjTteKV3zRr48pkj34YtoDCFwXwVea2njSd5v0
	 o1qDf9uvEh1Baq980ZzRCXWnmUOywB267k39vGNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 586/675] drm/amdgpu: fix resource leak on ACP reset timeout
Date: Thu, 30 Jul 2026 16:15:16 +0200
Message-ID: <20260730141457.577285598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Ce Sun <cesun102@amd.com>

commit 020da7c5aac5b86bad8a1571f6eda6b8cff9331d upstream.

When ACP soft reset poll times out, original code returns early without cleanup,
leaking MFD child devices, genpd links and all ACP heap allocations.

Replace direct early return with goto out to force run all cleanup logic
regardless of reset success, preserve timeout error code for caller.

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 98073e4328d7a8d75d03696ab27f6de70ef1aeda)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -505,6 +505,7 @@ static int acp_hw_fini(struct amdgpu_ip_
 	u32 val = 0;
 	u32 count = 0;
 	struct amdgpu_device *adev = ip_block->adev;
+	int ret = 0;
 
 	/* return early if no ACP */
 	if (!adev->acp.acp_genpd) {
@@ -526,7 +527,8 @@ static int acp_hw_fini(struct amdgpu_ip_
 			break;
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
-			return -ETIMEDOUT;
+			ret = -ETIMEDOUT;
+			goto out;
 		}
 		udelay(100);
 	}
@@ -543,11 +545,12 @@ static int acp_hw_fini(struct amdgpu_ip_
 			break;
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
-			return -ETIMEDOUT;
+			ret = -ETIMEDOUT;
+			goto out;
 		}
 		udelay(100);
 	}
-
+out:
 	device_for_each_child(adev->acp.parent, NULL,
 			      acp_genpd_remove_device);
 
@@ -556,7 +559,7 @@ static int acp_hw_fini(struct amdgpu_ip_
 	kfree(adev->acp.acp_genpd);
 	kfree(adev->acp.acp_cell);
 
-	return 0;
+	return ret;
 }
 
 static int acp_suspend(struct amdgpu_ip_block *ip_block)


