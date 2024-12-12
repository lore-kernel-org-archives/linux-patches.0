Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F052165F0;
	Thu, 12 Dec 2024 15:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016334; cv=none; b=B+JMLmI5a9cYyZhNCqfJasvFaISdBqBbdmaVYQm9vSy7Xbav5gJNpSQr1nuoECQnikrt84gnFOfTmAygp4+fex4P/Lkzm8QllgJmfomJPBposYVtkttYacb64th9BxJYsuKaJ0jD5sJiss9wNCHGXqpO+6VOHbzgU20W6qwPDUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016334; c=relaxed/simple;
	bh=0UR8fI9/OeKCjjeND6DSuWOIHLLid+WXMkE4N+avXs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwyM8zMAAjCrEcwMyLI6+7FWZe6JZHD9Ty1gmhywxlj7SON37wvgw05LBvzYTwhDHmKLJP6Dd4bGifWC2nccSKjsr1juj+WYSuzM5bHcA//KJKIyO1wrvEm6S+DfH3QGRPiD1vsCal0Bqw3ba1c8M0hY+mSYcME4CNz4ONdqvCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3IS6HWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3IS6HWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BB5C4CECE;
	Thu, 12 Dec 2024 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016334;
	bh=0UR8fI9/OeKCjjeND6DSuWOIHLLid+WXMkE4N+avXs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3IS6HWtVYMctSgQ/7hoovaipjk4R3DvrWSew6KYwfKaAyvcHCt2IhZVKs/GLbc5N
	 rjYDjC9mPpLDxWOPzhkVe1mKR1ReNqVE2iJVu9mFUA6lWliofsu0QqwebqIU67xx04
	 2rgwlFVBsAg//Z6i3wg8h7OlkAt8jGwLN28U/rE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekant Somasekharan <sreekant.somasekharan@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 170/466] drm/amdkfd: add MEC version that supports no PCIe atomics for GFX12
Date: Thu, 12 Dec 2024 15:55:39 +0100
Message-ID: <20241212144313.515780681@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekant Somasekharan <sreekant.somasekharan@amd.com>

commit 33114f1057ea5cf40e604021711a9711a060fcb6 upstream.

Add MEC version from which alternate support for no PCIe atomics
is provided so that device is not skipped during KFD device init in
GFX1200/GFX1201.

Signed-off-by: Sreekant Somasekharan <sreekant.somasekharan@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 956198da7859..9b51dd75fefc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -235,6 +235,9 @@ static void kfd_device_info_init(struct kfd_dev *kfd,
 			 */
 			kfd->device_info.needs_pci_atomics = true;
 			kfd->device_info.no_atomic_fw_version = kfd->adev->gfx.rs64_enable ? 509 : 0;
+		} else if (gc_version < IP_VERSION(13, 0, 0)) {
+			kfd->device_info.needs_pci_atomics = true;
+			kfd->device_info.no_atomic_fw_version = 2090;
 		} else {
 			kfd->device_info.needs_pci_atomics = true;
 		}
-- 
2.47.1



