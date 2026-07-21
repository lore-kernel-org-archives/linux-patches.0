Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D066F37647B;
	Tue, 21 Jul 2026 20:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665746; cv=none; b=Jd5ElhBSJ4QvMOj13f/YjFdfGql7Io3p6pxki/c95GC91D4wFZJGbkgkX6qx1S63FxRrempwLh/mqZAD/ZNmL0TudRs+CfpOvLme6YvLM0bU+W78V1RaqcdLpRcgfThsW++/UZxda+dQF2cNbsO0qGcQbHyb12Vua9colv5niDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665746; c=relaxed/simple;
	bh=LzM4XWaFqtUMfFWEbxDefO+kwjdRUlHVlzdHC1191QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyyZtgRGtdU2yEOcFhKpK+rahp4tOh2d+Di2BvLGgWt2TiCCAOoJ46/tugLGT7QpSEtJUB9C94XTwSN/EcDMYYe2OfM2q9uJsX17oxn7NKW/jIR7UpOW6uyr5P5TCK0f4R8LuKZ6XU0q7ETbKAOAiutAyB/c/ibJGCTlmaO+A7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2VUXoJL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2VUXoJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13801F000E9;
	Tue, 21 Jul 2026 20:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665745;
	bh=dfeuQadHxNjksi67KR1wmYxDeHsmjeKWbu9VMf29rsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2VUXoJLxBUJ+bNjSuh0zAJcZUcnsQKFoByKB7PQoTFQ4I+w1KN9CJmGvZDXIdnxP
	 sH9oN+knik/cSz0/9Q1uepUzWgZeAagrmgMtU3/gQHYV3kd+7B1VBjCSwm++HnNbIu
	 ca6M7Ne5QhDAXKqrcf02DAEBR+0w/vhfymymOehw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0421/1266] device property: fix fwnode reference leak in fwnode_graph_get_endpoint_by_id()
Date: Tue, 21 Jul 2026 17:14:18 +0200
Message-ID: <20260721152451.261176668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 9582485a65eacfd7245ec7f0a9d7e2c34749d669 ]

When called with FWNODE_GRAPH_ENDPOINT_NEXT, the function walks every
endpoint under the requested port and, for any endpoint whose ID is
greater than or equal to the requested one, may store a fwnode
reference in best_ep via fwnode_handle_get(). If a later iteration
finds an exact-ID match, the function returns that endpoint directly
without dropping the reference held by best_ep, leaking it.

Drop the saved candidate before returning the exact-match endpoint.

This affects callers that use FWNODE_GRAPH_ENDPOINT_NEXT to ask for
the next endpoint with ID >= the requested one (used by a number of
media drivers, e.g. imx7/8, sun6i CSI, omap3isp, xilinx-csi2,
stm32-csi). Each leak retains a fwnode reference until reboot/unbind.

Fixes: 0fcc2bdc8aff ("device property: Add fwnode_graph_get_endpoint_by_id()")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260514171455.27271-1-sozdayvek@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index ea93fc8ba59273..f0dd0d46c04b2c 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1207,8 +1207,10 @@ fwnode_graph_get_endpoint_by_id(const struct fwnode_handle *fwnode,
 		if (fwnode_ep.port != port)
 			continue;
 
-		if (fwnode_ep.id == endpoint)
+		if (fwnode_ep.id == endpoint) {
+			fwnode_handle_put(best_ep);
 			return ep;
+		}
 
 		if (!endpoint_next)
 			continue;
-- 
2.53.0



