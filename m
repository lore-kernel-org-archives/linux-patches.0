Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E803A7F43;
	Thu, 15 Jan 2026 16:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496383; cv=none; b=VvDj/scOSRHS6qwiUUw0eG9m5eaviH0IRyUjNVDlHGNUXMYfe1esMV9nlBesKCVGSvsq1uRMn7fouVCsTkZQoCefsRHeYPSfoVDkHSb6RkTCNqnh/fN+aWcH7rhYFFLJwgw6iy3x2fqWX3E8AeWIvXXvZq7Du3sVI3rgekh0oQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496383; c=relaxed/simple;
	bh=Cbzh5bC1/Yb5ahlUjz41ns7rBuLavlxpcPBSEycZX8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjBj+H5EHXPubS44wewf3PPEdnMgIn/TjuRdtuUkTfWsBQSsS8b/3VIEQeZ1Gbwccwbw/d32v2E4mogOlE713VYt8tiM87R/z88/NJt+kbzFdpXTKQ1xMFtMWmv3S/O1wMrt7zhtLHY6Fflo5q7YjCn+D6pRV8o6QqKV3Zudn/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORQxopPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORQxopPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57250C116D0;
	Thu, 15 Jan 2026 16:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496383;
	bh=Cbzh5bC1/Yb5ahlUjz41ns7rBuLavlxpcPBSEycZX8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORQxopPCJGH2DZL3WFmb7gzD7jp77o0DTJ+B0CHwhQ27nYDMXajg4uoj6qmWaglt7
	 u0SWJaLcWKwG2oY/bAmrY7nYvdLTUGXqk3AVzNSqdUQgDoKH0eKksgG7ajdMbgi9Ex
	 2VEbwu/LbuAW5O57mjTFXwjvrrLFLm/PVbJbQTNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/181] block: validate pi_offset integrity limit
Date: Thu, 15 Jan 2026 17:48:32 +0100
Message-ID: <20260115164208.632477265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit ccb8a3c08adf8121e2afb8e704f007ce99324d79 ]

The PI tuple must be contained within the metadata value, so validate
that pi_offset + pi_tuple_size <= metadata_size. This guards against
block drivers that report invalid pi_offset values.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d74b13ec8e548..f2c1940fe6f1a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -148,10 +148,9 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 		return -EINVAL;
 	}
 
-	if (bi->pi_tuple_size > bi->metadata_size) {
-		pr_warn("pi_tuple_size (%u) exceeds metadata_size (%u)\n",
-			 bi->pi_tuple_size,
-			 bi->metadata_size);
+	if (bi->pi_offset + bi->pi_tuple_size > bi->metadata_size) {
+		pr_warn("pi_offset (%u) + pi_tuple_size (%u) exceeds metadata_size (%u)\n",
+			bi->pi_offset, bi->pi_tuple_size, bi->metadata_size);
 		return -EINVAL;
 	}
 
-- 
2.51.0



