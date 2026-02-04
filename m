Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B53B21ABC9;
	Wed,  4 Feb 2026 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217919; cv=none; b=UM8g0sa0w+WUVm+bo7qcqH4oQmVwZ+17cEUDwZDCskfApfLz4hhWvQnILVicVmCW7ARB23Ht2uhR0PtuazfGWCwmtcYUgi/0e9mo5fMlxgnKEsVkjo09WtOaW5NlPd22wJzjVn2WV5f/AKuoXQleCoj1V+fYfDZE263l6bU3RMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217919; c=relaxed/simple;
	bh=Ay/YagLmfCzuK5gWilCjQbEizNaY21tEVuGP1ydYdOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqXStGIVks64+YLt9/sMYQ8LtNtDqdF2Yi7P8qoAbfjDKqOqi4R3MjPyLOr0kVSkHMC+Eiz9GdTawgYtCSE/M7VrATeNyAbTEbcKcvkhN8Er886jHc/6yOHl7660vYfKXXn7Bg/v/g3UU1Drg07J2ztemWazVslLoEK2tPFeRPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/SGZZ3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/SGZZ3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94BEC4CEF7;
	Wed,  4 Feb 2026 15:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217919;
	bh=Ay/YagLmfCzuK5gWilCjQbEizNaY21tEVuGP1ydYdOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/SGZZ3o2Ib8rgPPxBh3cHW9m/uqVqSxSEj3Je2/t383tQOosvcWv+YGXfFZE1/Tv
	 1I5ttt9cQf3DkoldR00y5ZwRYpz5CabYizG7xgz8Bu6dTfpmHCmbqkEU4TECOoJa0v
	 VVnlrIAAVOI1YZoXguM4ekSdsluTQ+CZ55ZKvHu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 157/280] of: platform: Use default match table for /firmware
Date: Wed,  4 Feb 2026 15:38:51 +0100
Message-ID: <20260204143915.276008530@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -587,7 +587,7 @@ static int __init of_platform_default_po
 
 		node = of_find_node_by_path("/firmware");
 		if (node) {
-			of_platform_populate(node, NULL, NULL, NULL);
+			of_platform_default_populate(node, NULL, NULL);
 			of_node_put(node);
 		}
 


