Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74833C3F4C;
	Thu, 30 Jul 2026 14:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423231; cv=none; b=CpgGj0DTugWTFvYs7m3Y9QDeag8L8jhxauh1CeqGsbZ8U3g7bi1Ermjo81IHAJ0HKeWqHsW2ooL1sQkbMkSXlK5JdFfYAwGEhSuZDUf4gdn8oz5VYoBEoxWLRy/nSj+VBK9gZtlVY2YeX1mTbk384g+ML+b6EXhwmO1D75WOOqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423231; c=relaxed/simple;
	bh=iEWZ384J+cBqr8E7rINUi+99Q1Vm1R3hhkSE8AEEIOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txGMCitj6AT24nFUSJ1opqVw2bjxTXDYiGodvuPTzc4ZZ9pcRSxtvkx11fuBTsR1Q7pgmi8t8tYHeKKpidX517m7Tl6N6Af+TL+0jA8CuXf8YlL742FfaG64gM6DumjyRNZnv0OLvUMU4zMtKWgAKRWGsulOPrpqUYCWomzbwgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTX/Q5lF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTX/Q5lF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0051F000E9;
	Thu, 30 Jul 2026 14:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423230;
	bh=8HlEcq7/ktHEgVq5WA8QrLHAnz+F9i2xGdBMpyf1vVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTX/Q5lF3EfQoB2eSXt2zf1H1pkI5d6XpLeOuX103kxdmPim/vH7kS7Pb7zkBC9S9
	 LQTMLOqBJiHbcm60joGtUj1S12zt0IpE+16GMBFL05kWKfpX7E7o28x2r+umWsA9DD
	 yUkMyoT/2DofVUdaqD1hDw1BSwyBlAxLJadF00c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 713/744] drm/amdgpu: fix resource leak on ACP reset timeout
Date: Thu, 30 Jul 2026 16:16:26 +0200
Message-ID: <20260730141459.433802816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,6 +509,7 @@ static int acp_hw_fini(struct amdgpu_ip_
 	u32 val = 0;
 	u32 count = 0;
 	struct amdgpu_device *adev = ip_block->adev;
+	int ret = 0;
 
 	/* return early if no ACP */
 	if (!adev->acp.acp_genpd) {
@@ -530,7 +531,8 @@ static int acp_hw_fini(struct amdgpu_ip_
 			break;
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
-			return -ETIMEDOUT;
+			ret = -ETIMEDOUT;
+			goto out;
 		}
 		udelay(100);
 	}
@@ -547,11 +549,12 @@ static int acp_hw_fini(struct amdgpu_ip_
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
 
@@ -560,7 +563,7 @@ static int acp_hw_fini(struct amdgpu_ip_
 	kfree(adev->acp.acp_genpd);
 	kfree(adev->acp.acp_cell);
 
-	return 0;
+	return ret;
 }
 
 static int acp_suspend(struct amdgpu_ip_block *ip_block)


