Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8313BFE5A;
	Tue, 16 Jun 2026 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634307; cv=none; b=U6TFJZkNDD9KAifh20oUFBzwrLqmdJmJ0NkSSd9Ir1ZoNPjatKZJzKQJiqZ9s1T2+ub9W85XmJZ4XTbHe8jMW0VKzcvpCCLXvclmOUSPI8bFWAv1bMn+d6OxPJYifNOgpQks9N5l6x5pYBA/IaBePfTWIGpVS/+tuhT4OXpKGcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634307; c=relaxed/simple;
	bh=k+ijF8fAOvMNdFiTnNqFp7DfppmTMREx2TDTP0FpI7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4qxhh3nQiIq+5q48OZ8WeLb5o5uWPUAbUxftm/v/9eXVoc5rxN4VxJ/TbRIA81wEe/4VUc0Fj+2uTxwKDj4Mwr9mN3dlWh1WsJfweRWBUZGmtGl8W+bUqN/aiLQS5Ii+zVN0p2knS+JyYIm0j68H8L4BkzL9niW08RQvkZaVJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFlGtaP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFlGtaP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149F11F000E9;
	Tue, 16 Jun 2026 18:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634306;
	bh=N5nxG92jzAspVdZAda+DwaekFAKptW+fcMrn/fWZhvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFlGtaP655MEtu3qCsT6OzEUODSsuAUoRJaCnaDF026ZloK8yW/Eo60u9IdOtrUK0
	 4PrPvQyfonZQuwx1pGwJKjShNr7T1oDuq46CKLc1wwG6Qgbj6f7ijeg8SiTICUJVpD
	 Xxgs868xJhQKvIbt88slsV78V8fiJ7CwG+0WGQuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 240/411] thunderbolt: Limit XDomain response copy to actual frame size
Date: Tue, 16 Jun 2026 20:27:58 +0530
Message-ID: <20260616145113.650066405@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 4db2bd2ed4785dbadaeeab9f4e346b21ac5fb8eb upstream.

tb_xdomain_copy() copies req->response_size bytes from the received
packet buffer regardless of the actual frame size.  When a short
response arrives, this reads past the valid frame data in the DMA
pool buffer into stale contents from previous transactions.

Use the minimum of frame size and expected response size for the
copy length.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -96,7 +96,9 @@ static bool tb_xdomain_match(const struc
 static bool tb_xdomain_copy(struct tb_cfg_request *req,
 			    const struct ctl_pkg *pkg)
 {
-	memcpy(req->response, pkg->buffer, req->response_size);
+	size_t len = min_t(size_t, pkg->frame.size, req->response_size);
+
+	memcpy(req->response, pkg->buffer, len);
 	req->result.err = 0;
 	return true;
 }


