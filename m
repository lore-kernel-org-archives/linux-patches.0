Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE1E14AD0A;
	Thu, 15 Aug 2024 14:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732382; cv=none; b=XcrldDhQPzghs2+8asGY0aaU/uybj0smLeMyJIi0g3ywNjWpVrMpWy+Po8XQRn93dOCw85DWgtRUn1wHFUV2gpk6072amGQ8x7eS4zZa5yYkMnQ9pza8+AhFZIWmq5+ZY+q/3t6VTw4ipeHArxkjsI0AF9RqjXqwLQZhQ0pB1Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732382; c=relaxed/simple;
	bh=t+LkI0Dx+H+a+oOofr4H2IPAUi+hlbjZE74ZjO0nciE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNhp0WtP9ZpVf5jTeP6eYuO9obsKSoajY43L7m9WI4opJ/S6JgJ1BEMskVeWpq4qHCC5JO27mv+z1nj4R0pVNmDDx33Z6oVdGkYfegmMEjOw+zwiXf7nZjFa5RVTKloECasKK4G+tBD3T1ePGKopwtZ0/bDuWSjQ9q/E8DokcbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DU/TovHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DU/TovHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34795C32786;
	Thu, 15 Aug 2024 14:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732382;
	bh=t+LkI0Dx+H+a+oOofr4H2IPAUi+hlbjZE74ZjO0nciE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DU/TovHPNxwo5MFRvMy/spJ2zPuXEdooUVci9q8RnmoKTnZCHeg+wL2386HII3fxG
	 y0kc8nsxj46F4UFt0CCKYP6WBzxAXhH7UOnsL1w072gHbdjjZKwxqpEnr0rWDKoc8h
	 8s2xi7x4/cBzOAATozcw++ZOG5a81brIpTpGMGqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.10 163/352] devres: Fix devm_krealloc() wasting memory
Date: Thu, 15 Aug 2024 15:23:49 +0200
Message-ID: <20240815131925.572066732@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit c884e3249f753dcef7a2b2023541ac1dc46b318e upstream.

Driver API devm_krealloc() calls alloc_dr() with wrong argument
@total_new_size, so causes more memory to be allocated than required
fix this memory waste by using @new_size as the argument for alloc_dr().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-2-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/devres.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -901,9 +901,12 @@ void *devm_krealloc(struct device *dev,
 	/*
 	 * Otherwise: allocate new, larger chunk. We need to allocate before
 	 * taking the lock as most probably the caller uses GFP_KERNEL.
+	 * alloc_dr() will call check_dr_size() to reserve extra memory
+	 * for struct devres automatically, so size @new_size user request
+	 * is delivered to it directly as devm_kmalloc() does.
 	 */
 	new_dr = alloc_dr(devm_kmalloc_release,
-			  total_new_size, gfp, dev_to_node(dev));
+			  new_size, gfp, dev_to_node(dev));
 	if (!new_dr)
 		return NULL;
 


