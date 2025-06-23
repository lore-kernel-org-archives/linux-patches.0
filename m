Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21302F24;
	Mon, 23 Jun 2025 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684822; cv=none; b=OifkUTuX7HkPdRxZfwKSPOBms91FWPwCzolAlztimpCeU3Y148kRYc+5uu3OcGTjb2zz9YL8zYOv76DKdgkMN25ZNGf5cTGu8PeB3SdN1Oz0S5NDs1x/RjrSOVPgCB7XErtzAir8zFVWFcgSIS9BCEWwQC7iUzbyHE4JmeykWhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684822; c=relaxed/simple;
	bh=UGogxGrbJPCZI61fhlJe3lgFbWbU5QJ+Z5oh3hayeBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioValLkPfl4s9Gu4xKFabdUYjPjgQLSyOgEHWN5p/jsoT1ELTMJgyQWSbQMVyCPFa+8Dhryzn1A7HLlP9BsDfZVB27seXEJ0Zd2/kSLVYtKZb0lLoLRE1EiN+qVW5/9bvK6M/kN8BrfLdOGi6L3DGMXx/Ql+zlHhGLhSVzrw+lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miZjO8Xi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miZjO8Xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E19C4CEEA;
	Mon, 23 Jun 2025 13:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684822;
	bh=UGogxGrbJPCZI61fhlJe3lgFbWbU5QJ+Z5oh3hayeBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miZjO8Xino6t9NmDz1pohvVdha5svyQB/dAW6pNEmG1iS62NYQaKPj+eGRxAVcHb0
	 yP5dAl1u7RyrP0/mCOCBpRPZkkgWIca8YCrLdeO3IeomhyzfqOpnci+vrK2Uh2Yxru
	 W/2NqKYOiUqqodIh0XGGi2/FtQp+dqihT71c43ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.15 179/592] uio_hv_generic: Align ring size to system page
Date: Mon, 23 Jun 2025 15:02:17 +0200
Message-ID: <20250623130704.537528468@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit 0315fef2aff9f251ddef8a4b53db9187429c3553 upstream.

Following the ring header, the ring data should align to system page
boundary. Adjust the size if necessary.

Cc: stable@vger.kernel.org
Fixes: 95096f2fbd10 ("uio-hv-generic: new userspace i/o driver for VMBus")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/1746492997-4599-4-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <1746492997-4599-4-git-send-email-longli@linuxonhyperv.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -243,6 +243,9 @@ hv_uio_probe(struct hv_device *dev,
 	if (!ring_size)
 		ring_size = SZ_2M;
 
+	/* Adjust ring size if necessary to have it page aligned */
+	ring_size = VMBUS_RING_SIZE(ring_size);
+
 	pdata = devm_kzalloc(&dev->device, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;


