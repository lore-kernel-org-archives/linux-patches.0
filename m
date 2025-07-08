Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FB12E091E;
	Tue,  8 Jul 2025 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993872; cv=none; b=SZhQzUg0ShKRpuQvLXpgRHPExmeNl+oUz4W7TxjJefdcTp6YKjU+x8DcUhV/Kdn62MEOW7RvFbIhmmMjHKfCerP7h3TCNkaryVGlwjmCE8oe3CjWssGyaXc+ZZ5/xtqY+GNqe4BNwgNXtbV53Fso+QoL2ELQmbXBIodHP5UV0+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993872; c=relaxed/simple;
	bh=ce+mnEmqVsPR5MoZFEtkRDVpBBcyz4TiZcqnNamlrEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shpjcXAvnL7rMt2TuFDSJilo0R6obM0gP6rXQ/Kx7kl6CiF1j3mGIkttxnmfkLBL3QSuc2L4pjVJWbLKVCC3vTCgF60oHLISf5L7rmCvscRAjqG0XdRgCDm2FFmmJpEnjh7rfCAGOjPurVC7OPxbRJn2ibvtoi1s9THmdkx8g0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8BEyhgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8BEyhgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83A9C4CEED;
	Tue,  8 Jul 2025 16:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993872;
	bh=ce+mnEmqVsPR5MoZFEtkRDVpBBcyz4TiZcqnNamlrEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8BEyhgn46y76L4BGAHi7RiOxi3SVgwT16j9DP+qfvrCGCHcdRRWoJCd40imaArV5
	 Uvfb+2kSn0AT0Un0mz/APUnFBOgiseZ4P4TDhdduoNZkF8NiD6XnjhhFb1Z151Zbnr
	 WeGMKMJuwUZx3v6AOIQR+gUO3KgFSR9pJ6WNJRhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/160] uio_hv_generic: Align ring size to system page
Date: Tue,  8 Jul 2025 18:21:25 +0200
Message-ID: <20250708162232.868238349@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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
index db8a450b5a19b..865a5b289e0a5 100644
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



