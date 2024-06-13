Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FA314601B;
	Thu, 13 Jun 2024 11:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279402; cv=none; b=Um5BfK+oljgOkqeRmFHJO8hKCfvRaYM4yAGfCKD4WpEVkUYjii05kuUIRNckMmhIpdXK+C0kCdihCPnEHkh1rdnP8gx35kYyw9MNzD5YjFko9LeomcMhfPqJB8eDRC3l+78ARjC+RY2Gpqb8+al+C3fpLP7lhDomNo9AP8b99BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279402; c=relaxed/simple;
	bh=cK7W3bqE35uJxojP5Rb62D+YzmcBqbf81DSkB9QPccU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USjOtsOIUNj9ugLihhu4ZYn0KXUNYNOIk8429mYNothzxWimnlxhx7LYDQQjTmF5DzLdvRVDBDBnxsic35CJZNJu5C56R0AKDgbA3nf6uEBI2qJsQ+GrvLKvcc9RD2oNF7VkKpIP0Th/hcBHU92wcRmD1xyEmsLJnXlYUYFyV68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjBrqIJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjBrqIJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6E1C2BBFC;
	Thu, 13 Jun 2024 11:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279401;
	bh=cK7W3bqE35uJxojP5Rb62D+YzmcBqbf81DSkB9QPccU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjBrqIJp9RLWkIDEpLyQOz8ZDk0rOqij4sLYzaNlzxiFW8GkAVM9cnHmqx6FsOEhY
	 +An23ZcjFJRQousbjPTRtD6VU52z0GPR9/zaRCXGhgesEzHxt7CfJgmyfFWAEBkQ/B
	 1kLhlilGFom6dgWHxh3kafNnk9JsezC8cJ/2wtvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Feifei Xu <feifei.xu@amd.com>
Subject: [PATCH 6.9 056/157] Revert "drm/amdkfd: fix gfx_target_version for certain 11.0.3 devices"
Date: Thu, 13 Jun 2024 13:33:01 +0200
Message-ID: <20240613113229.594157372@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit dd2b75fd9a79bf418e088656822af06fc253dbe3 upstream.

This reverts commit 28ebbb4981cb1fad12e0b1227dbecc88810b1ee8.

Revert this commit as apparently the LLVM code to take advantage of
this never landed.

Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Feifei Xu <feifei.xu@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -408,15 +408,8 @@ struct kfd_dev *kgd2kfd_probe(struct amd
 			f2g = &gfx_v11_kfd2kgd;
 			break;
 		case IP_VERSION(11, 0, 3):
-			if ((adev->pdev->device == 0x7460 &&
-			     adev->pdev->revision == 0x00) ||
-			    (adev->pdev->device == 0x7461 &&
-			     adev->pdev->revision == 0x00))
-				/* Note: Compiler version is 11.0.5 while HW version is 11.0.3 */
-				gfx_target_version = 110005;
-			else
-				/* Note: Compiler version is 11.0.1 while HW version is 11.0.3 */
-				gfx_target_version = 110001;
+			/* Note: Compiler version is 11.0.1 while HW version is 11.0.3 */
+			gfx_target_version = 110001;
 			f2g = &gfx_v11_kfd2kgd;
 			break;
 		case IP_VERSION(11, 5, 0):


