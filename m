Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83421328618;
	Mon, 27 Oct 2025 18:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590615; cv=none; b=CPEBEULF7q6RHzn8W4SURm0zWjzOYa1AFvMLGY+qelJjFLbJBE/XsOoc8wBJ5E3jW0BFr4jwduqv1osbEwi7Ua85V+sLJ4dGjs0SFOlkL0w8MBXqVvFYfDY9+hZ9d+cVGr58ZHPzdxtc0/yJxLrdoo+hJFR8Q9hYG4vBZmEay30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590615; c=relaxed/simple;
	bh=A8uM+fZJ25I2gyiASiDxvGqFTvr3eyt/dqouW+V9CYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ny/0zjmk40n+zClWVMI1JW0YJle9k5wEHS4qkRYTY8C5nJPZRfuvO0IwZucjmdZ5A9cxmPvQOzDRodqVKvu5doTW8Hqmy/vH2jmLLIYZR2ATVkFImYPrX9yQA9Kuco7hEjhnhF/Mu+qqjvFciwhCXUj71cqWjcjuCtYxK9l7TvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4lgQg8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4lgQg8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1714AC4CEFD;
	Mon, 27 Oct 2025 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590615;
	bh=A8uM+fZJ25I2gyiASiDxvGqFTvr3eyt/dqouW+V9CYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4lgQg8OMoINCI5mbfO5JKKfwtO/0dG8XjYWohMiHSUC5iPmbfTQJWwpuXzYnmZgl
	 +U/6pKUjSPnbqeEyJW5oH62BXfQw3xTT5j5VvnbIy6uzImbLWSGSKCzXuzxkNtVoBy
	 kVuYDhaG8e98fGsOCrfBN445YfPljCstFfoxy0HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 112/224] lib/genalloc: fix device leak in of_gen_pool_get()
Date: Mon, 27 Oct 2025 19:34:18 +0100
Message-ID: <20251027183511.987724119@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -892,8 +892,11 @@ struct gen_pool *of_gen_pool_get(struct
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


