Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919BF31197B;
	Mon, 27 Oct 2025 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591304; cv=none; b=dFWO9qdzvDu7Wr8ggFaBIo+KFmYF0XtNqgIyVs7EUx3SDq1dKyaQISh6EkmjLsWgz7x0YCgcfMJLzJihlyjPtsQJ1vxMoVnuWbXu7qMEmQgMGipMxbsKX2ZiHtrlYORI9RBnTHeEUTLrsGmcSOh+TJ1nyeLEq0Iupr3ggS/YhCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591304; c=relaxed/simple;
	bh=2q4s/km++UTkV/qTxzoK8Q4AtmS5gWelv47bn9tck2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+L1NizZQhcYv/zJmE4sP0ejmPhPnIzT+u3UudtVHfTWhtfR4XDd5gGEu82oAcJd91sydNOeKUYBowsBjd4XlQjcUiK6Dz7U5IECJErJZ4C9ygPqRaYRK3U1J3yODoo3YIMiq5ekynTlqoaJAwGYycQLmGGzFGOH9CdNBE6A4dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCL8GQW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCL8GQW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223E1C116C6;
	Mon, 27 Oct 2025 18:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591304;
	bh=2q4s/km++UTkV/qTxzoK8Q4AtmS5gWelv47bn9tck2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCL8GQW6NEwt7BqKJQGGAb9Rqnsl3lC4mhjjLYRnC3n5DWSp+eKq5g1PHtPu29GwG
	 5//rCbCcizwdkBL6MPrxcBXeGYeUTIxPP8HLetJNcJ597DfpuH5i4UFSNgY5rVbb0L
	 WotMSw9RiMWL9YaFWkiElO0QKvDcXvaE3W7JvsjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 144/332] lib/genalloc: fix device leak in of_gen_pool_get()
Date: Mon, 27 Oct 2025 19:33:17 +0100
Message-ID: <20251027183528.436146884@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 1260cbcffa608219fc9188a6cbe9c45a300ef8b5 upstream.

Make sure to drop the reference taken when looking up the genpool platform
device in of_gen_pool_get() before returning the pool.

Note that holding a reference to a device does typically not prevent its
devres managed resources from being released so there is no point in
keeping the reference.

Link: https://lkml.kernel.org/r/20250924080207.18006-1-johan@kernel.org
Fixes: 9375db07adea ("genalloc: add devres support, allow to find a managed pool by device")
Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/genalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -893,8 +893,11 @@ struct gen_pool *of_gen_pool_get(struct
 		if (!name)
 			name = np_pool->name;
 	}
-	if (pdev)
+	if (pdev) {
 		pool = gen_pool_get(&pdev->dev, name);
+		put_device(&pdev->dev);
+	}
+
 	of_node_put(np_pool);
 
 	return pool;


