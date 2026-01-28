Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97D91D6AA;
	Wed, 28 Jan 2026 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615927; cv=none; b=RdRvZQZ+q2y6qEf2Y8PFe9EnPb2nfRHU6InVG6zHWaeejiAXLTVjFSK3ntRTUx0j2yARet3qsgA47JYlZ8j+zd8K3nEhjR8eiRj4dafHI1A74q7aHW/0lRIQeIWoxApUT6W/pAZlHRsNixZHb4E/4PZcY7J8AoDtuo/pmUmyHTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615927; c=relaxed/simple;
	bh=qb2R7Ljgi8Ie+QUlqwY6ejOlhh6ceXgJxdyWTie0FsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nsd4FBomm/QZEbH2VvjzznPRI2syVbvQqTPVIHTgjgNnKvKcMv4v0tGFqx2Cmrx7IMBg6ZKa3pqNBrwNBL7agcuID4Gx9wMHlNhVeEtmUVWcHoZt9rvc0vkxyxPs0F1L/aakcGE2D/K1fej08f4g6hmUSWk0mPQw+MpgnRAnZuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlmFjOtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlmFjOtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F55C4CEF1;
	Wed, 28 Jan 2026 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615927;
	bh=qb2R7Ljgi8Ie+QUlqwY6ejOlhh6ceXgJxdyWTie0FsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlmFjOtYn0FYBuyp/fwlcKYRO6BAu2swf+svjsSKWnGpxcN8T0VfyPVSRgYaA+Eqg
	 amNECGqeF53V/W1HFVwgIrmjWE/XSwDUtcv/UMAJFCskMs39EIeSa5lCg8iL8n6eUO
	 T75+T7leoF49OW1cbS4v1Y8lfkytmnsN4r9Xa2lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 155/227] of: platform: Use default match table for /firmware
Date: Wed, 28 Jan 2026 16:23:20 +0100
Message-ID: <20260128145350.031159405@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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
@@ -569,7 +569,7 @@ static int __init of_platform_default_po
 
 		node = of_find_node_by_path("/firmware");
 		if (node) {
-			of_platform_populate(node, NULL, NULL, NULL);
+			of_platform_default_populate(node, NULL, NULL);
 			of_node_put(node);
 		}
 


