Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC7F281530;
	Wed,  4 Feb 2026 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216645; cv=none; b=rnotvMmP4kRu7JKS90pYeQxzBQ+lZHA+OQmVbnY3dvgN/nFhh5g8BDO83tkJQTrJeb7m/sWsEtBZGUUGktbpdNBO6ZCk6YwwKNUoZIqZNsieAjBzyyPpMLVz+8V0fuZ0Xk+7g0g50TutOHHoz/++4ifQyOzDq/kJ5gIZrRUVyDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216645; c=relaxed/simple;
	bh=gV1JhdC8MSUKC+wzR3t90b7tbLeH+SbLl2DsGlP5NhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHdMoGVlSjEjQ4P4TwEtZugGWaXsbXWU7E2tUDCv/cb91HY8n0c9aVS8w/XhcwNLmjGvM17R5lkdqQap9gbO7PruuqbxZmxVLTTDPsCTSkHJg28LDEYtjt4GA1wzSn9GMVttTx3EgAs3yDuN75txPhqat1liH2fs559/Rujv398=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhIoBkWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhIoBkWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177B8C4CEF7;
	Wed,  4 Feb 2026 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216645;
	bh=gV1JhdC8MSUKC+wzR3t90b7tbLeH+SbLl2DsGlP5NhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhIoBkWCeylYUSB/DRheM2dTyX2KuuaHVX6QeIu37hgxAyVzPOQFBEZBKzIVYosYa
	 MbKanVBm61DWN4SJQP6DYj6JXJE4E9TvvWlQKAAxgnYe9bAe7dKt13oq9jeMXKZWk0
	 NcJkyihVsgqI/7fPu2pxpq5S7ZLysbtRp6DijmEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 151/161] of: platform: Use default match table for /firmware
Date: Wed,  4 Feb 2026 15:40:14 +0100
Message-ID: <20260204143857.181912448@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

commit 48e6a9c4a20870e09f85ff1a3628275d6bce31c0 upstream.

Calling of_platform_populate() without a match table will only populate
the immediate child nodes under /firmware. This is usually fine, but in
the case of something like a "simple-mfd" node such as
"raspberrypi,bcm2835-firmware", those child nodes will not be populated.
And subsequent calls won't work either because the /firmware node is
marked as processed already.

Switch the call to of_platform_default_populate() to solve this problem.
It should be a nop for existing cases.

Fixes: 3aa0582fdb82 ("of: platform: populate /firmware/ node from of_platform_default_populate_init()")
Cc: stable@vger.kernel.org
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://patch.msgid.link/20260114015158.692170-2-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -533,7 +533,7 @@ static int __init of_platform_default_po
 
 	node = of_find_node_by_path("/firmware");
 	if (node) {
-		of_platform_populate(node, NULL, NULL, NULL);
+		of_platform_default_populate(node, NULL, NULL);
 		of_node_put(node);
 	}
 


