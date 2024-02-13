Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE597604BF;
	Tue, 13 Feb 2024 17:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845753; cv=none; b=i+ZecUzOGSLiXNNNxWvwzrC38wBIvNuROf2zkMUo66eZMFn3cIt4MhMpvz4r4lKxDQoNu8cXzIgIqydI9/0BYCKQJUoEPAtr7KKHns2jfSofnlp3W/E0z21ue2OVRO2js8yij4szFzAnDJyb2dV1dPOZ6DOV7NvzUn1e8YlcllE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845753; c=relaxed/simple;
	bh=Qkl2lQO7eyQ0SPavBtfbIrV56R2VMvFwVTgN4GiRUXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfH+4aNuWNSiiggIncbTbux4GTaFsxnxeHfXoKhEklTqtVZLqz8YTCUT4Z0IhNfIxQMO3zI73J9y7kO0tLg4rWY8O+QX1g3GFFx8b1+twjnkmE6Jf7D03gW+82sGEXJ7zVT0m0QRWMkYFIsgtq2uj+ypqcb3jcV5IAwodTcBkD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ckmiz5p+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ckmiz5p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6336FC43390;
	Tue, 13 Feb 2024 17:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845752;
	bh=Qkl2lQO7eyQ0SPavBtfbIrV56R2VMvFwVTgN4GiRUXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ckmiz5p+gpKgKuAxWJ2U7mCqD0yS3RNr13TDB/JFEg/qTLSBiO+o477vtjTvona+L
	 kZNYiTygNua2mNkjzW1Rs/dRy+QCVgLUksSXmj6DgvbbqSNpu+iaC2oky+DuRIUBKA
	 dp8JcONXedqBI8EzKbyc3l4dr3VYtJwD0LxRJgY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 047/124] drm/i915/gvt: Fix uninitialized variable in handle_mmio()
Date: Tue, 13 Feb 2024 18:21:09 +0100
Message-ID: <20240213171855.110630068@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 47caa96478b99d6d1199b89467cc3e5a6cc754ee ]

This code prints the wrong variable in the warning message.  It should
print "i" instead of "info->offset".  On the first iteration "info" is
uninitialized leading to a crash and on subsequent iterations it prints
the previous offset instead of the current one.

Fixes: e0f74ed4634d ("i915/gvt: Separate the MMIO tracking table from GVT-g")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/11957c20-b178-4027-9b0a-e32e9591dd7c@moroto.mountain
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/handlers.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index a9f7fa9b90bd..d30f8814d9b1 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -2850,8 +2850,7 @@ static int handle_mmio(struct intel_gvt_mmio_table_iter *iter, u32 offset,
 	for (i = start; i < end; i += 4) {
 		p = intel_gvt_find_mmio_info(gvt, i);
 		if (p) {
-			WARN(1, "dup mmio definition offset %x\n",
-				info->offset);
+			WARN(1, "dup mmio definition offset %x\n", i);
 
 			/* We return -EEXIST here to make GVT-g load fail.
 			 * So duplicated MMIO can be found as soon as
-- 
2.43.0



