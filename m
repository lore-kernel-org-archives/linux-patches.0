Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2692046E00E;
	Tue, 21 Jul 2026 17:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656045; cv=none; b=Su8GQIKsDY/xHLs1eUp26Q7I3D+Qosifw0rQ3ufVbSFloSiRIcUeXwd78pdjhVdvFqqecTBfo63L3rGAFWS8W+5fefpMsQ760UYp6fcGZBQY412jaffKIB4EkfSs5P7fTdHv+WD7WcCTaJCtvn2582UPnDtVpzWccGz2sh/aRTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656045; c=relaxed/simple;
	bh=AH1z5Xxu+HdkPMIq6JvAw7x/2fHFNMtbdhOEMTk/dgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h810TeB3ekuVpYoCMVA+Fj/QkTDwRaaEnjKdQQh33OZnMeVFGhwrE6JMdmBMURFTxxiTV70xPuNb9wkEz/lM0dmW8RJLVU3FhxLKjTIiFjTVtDNFtv7WoF4Yb6VektrHNlASXVbp4CgTHtuh2nyB5uF+jpKJuB2o6YWT294+L/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/s+BGC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/s+BGC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4DF1F000E9;
	Tue, 21 Jul 2026 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656044;
	bh=ilThvdZFoSP31zUZQ0maGqCMt+egic2ojYYy+9O7ynU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/s+BGC7pkr5Sq5ycSMg+fzs+UTLfPZXmw5ETZ5AwlZb4gLEwrf0Gg8tIxkg7RAu9
	 wkb8arzk4LYKgDHgwS5aQtJtkmvjGKsf0W3I8GU7U7G2HpLdC0sAixD9L3bhXwFneE
	 UDn8qSYaWSAZLyeGKI8yxbTbqn1qaX/ZZBNkULm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0195/1611] device property: fix fwnode reference leak in fwnode_graph_get_endpoint_by_id()
Date: Tue, 21 Jul 2026 17:05:11 +0200
Message-ID: <20260721152519.332976421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 8d9a34be57fbf1..b2dc2bd7e5acab 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1267,8 +1267,10 @@ fwnode_graph_get_endpoint_by_id(const struct fwnode_handle *fwnode,
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



