Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31991DDC04;
	Mon, 23 Jun 2025 21:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714999; cv=none; b=B511BrsboDRJwdmNahsPFzjvfE+qYQEsOl+ZBsYkkNF34wJ5Gl6eXCuUXCB2245iXN6awFqjKGDvzJ73Y4Hf3SilJzfhQUR9OnUchUl7teUa0RY47bGhvKHYRNYQqMKWZISZ6/vWDnUFnPhbiWFR3chU5nXy7bwJRygeMi3KRdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714999; c=relaxed/simple;
	bh=VPAZo8dgXLGU44BoDW9cvdD0mR/8GTMo5rR66GCqiR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJLzWY6nWSBrqnHEtpZ4cT8TC4zlHwD9bMNg7oSRuefyLvnRvupVDLE/ISRBj8PzvJW3IYZirMBQYxfDOsTf2bfjNCvEdPUq25FmpNROGmRZmsY1za5WRs7pAZaY4unqUwUbqj069Q+Qy7XkFL+fGzAEYIu4Q9jQZZe9b/0xkfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/1CvqQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/1CvqQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5EBC4CEEA;
	Mon, 23 Jun 2025 21:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714997;
	bh=VPAZo8dgXLGU44BoDW9cvdD0mR/8GTMo5rR66GCqiR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/1CvqQ86l+6/UtnP/7/Q51WP6PgLDxxD/KZusaAqIag3rjU6Iqn4Q9GC8fiH6kiC
	 EP8TYMrR6HhyeNTlUXQB915OnaSfNQjmRNB1Iwa3I8CWDQDukGwkLVvEiUCQIfk600
	 pdfQy5duGaCSu4UPCbRRPbDMS32cWlJjA752RfcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.12 149/414] uio_hv_generic: Align ring size to system page
Date: Mon, 23 Jun 2025 15:04:46 +0200
Message-ID: <20250623130645.772843763@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


