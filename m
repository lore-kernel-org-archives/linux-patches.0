Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B0314831F;
	Tue, 30 Jul 2024 16:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358129; cv=none; b=ES/7QDy39r3H7CLfxF6J0EH8n/PQECGXSqtFmrnR+a9i9zhuVQIJtHk7YDixDym4H5wm1kkDHh7CsvlwFp03BAOoBjE3xHAXz7lrsoFJIYaLCFPsESjhX37EEUzhH7F2AEcIo7xmnAdCHYKG1Ng/lquo/UuyTP0ziypVKfiEeBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358129; c=relaxed/simple;
	bh=7413nFUJA1OM1tvVbVp19DI0v73Li4So0fUJckRdNuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebEjPO2iKwhAzdn7SQ2aEWveoBKh9DTrJdA6H/30oJqZM8MADAs8plq0mihgS21SFci+cV8uC4Sn+NvQJokYxwUAVt2vXt3oMgMA/2cQvrY+qImT6Mxzj+gsqcGcuDfV5uQEMGrpscqVvfK6/vWTJ8m6H/7uQj+9z/MRgQJ251Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bw4T9MkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bw4T9MkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4487C4AF0E;
	Tue, 30 Jul 2024 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358129;
	bh=7413nFUJA1OM1tvVbVp19DI0v73Li4So0fUJckRdNuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bw4T9MkSxGz/ZNYzg0AFqsdFfUftsNnIU+bhyKcQFwxXe7ReJ9WE7EeYfAseCd7kf
	 bxunsbFKkLl2FovYPUAR+faA5KpE4Tkd2K/Ij1IYw9u54Z2LXmWZZNs+T2mRrv5re0
	 JhrM00qrOSp0+bTCw8rG//oVG5OLjyuE6q5E4vyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.1 341/440] devres: Fix devm_krealloc() wasting memory
Date: Tue, 30 Jul 2024 17:49:34 +0200
Message-ID: <20240730151629.133747174@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -892,9 +892,12 @@ void *devm_krealloc(struct device *dev,
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
 


