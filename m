Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C4D2E719E;
	Tue, 15 Jul 2025 13:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587516; cv=none; b=T2qpPXku8ymtCRG9Pl2BOBUgsVIFayC+ZkDWxQBVJsCou3CDdHtwGdrJjoyFHIeuD8E4Wj3lZg+5A/x2fja6TtbmMxAjzadW0SL589dq1lmW8ayrzcYH9fvvptIilMYRXB6COz3Vo/WtHIKpxUpzHLoHDM2eQS4kPYSaXnMW4A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587516; c=relaxed/simple;
	bh=JjIJyPkDFOoh4eK5A9dW64lPwpmFX5DKBO4XT0/Q4Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQwnIQg0tg27k+Kf993gE+0XF3Xl3xRQjs+BScQ4heWvsMWlu/F2Tg1Gfis7LfD5YAEdSv5fGZwElGWBESounPnLkilJggANXilAB6KBSOcPUcM4QZhkqeowMc+eV7VldBpEpiALXwpcHGhDxrMmvACuY+cFVgDLUjMMoKX/G/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PU9SZAfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PU9SZAfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E51C4CEF1;
	Tue, 15 Jul 2025 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587516;
	bh=JjIJyPkDFOoh4eK5A9dW64lPwpmFX5DKBO4XT0/Q4Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PU9SZAfcsteVeqt2R0uvuNlOURIHTzYqk1/ZPNur6s5I/dSydLk3GbOydCAlkYEjS
	 2kG121F0Q2JUZ/JDxRC+T5hJ+401gyEIlOzafQA5OFyoTmvN/liN+VK6KkLVbiLbdz
	 JQ+XjPnWaPPv/fhO1tlxrEN9kLI30P/MPtlhW5II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/208] uio_hv_generic: Align ring size to system page
Date: Tue, 15 Jul 2025 15:12:31 +0200
Message-ID: <20250715130812.642677989@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit 0315fef2aff9f251ddef8a4b53db9187429c3553 ]

Following the ring header, the ring data should align to system page
boundary. Adjust the size if necessary.

Cc: stable@vger.kernel.org
Fixes: 95096f2fbd10 ("uio-hv-generic: new userspace i/o driver for VMBus")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/1746492997-4599-4-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <1746492997-4599-4-git-send-email-longli@linuxonhyperv.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_hv_generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 03a4ca762c499..6625d340f3ac5 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -260,6 +260,9 @@ hv_uio_probe(struct hv_device *dev,
 	if (!ring_size)
 		ring_size = HV_RING_SIZE * PAGE_SIZE;
 
+	/* Adjust ring size if necessary to have it page aligned */
+	ring_size = VMBUS_RING_SIZE(ring_size);
+
 	pdata = devm_kzalloc(&dev->device, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-- 
2.39.5



