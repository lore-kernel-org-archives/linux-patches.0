Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE851C6AB;
	Mon,  4 Mar 2024 21:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589163; cv=none; b=ItRoHmQmb+oJ1kYIOW23R+I1ojmle+E1jOqzwb20CBPops+ne1uRzra8+DydzIsmbYisHU5q2VrlTDcJDI4m8SSNMFJ3D6gZUyjTw/4/y2eHZk8fJci/lKqPNMqNAu7XV+j0qHbOGwZ6+6AjG5v5HQhxksdxHfoxhbu5sbLjmlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589163; c=relaxed/simple;
	bh=vJ55UNsjpa8ED4IaEhieaVOaA9OHgQhs0eoTEjXA12s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI5fFn+h5d0CydCPNOxscL8x1vaDMZQSSojbsn9QVBsndIFiq/IJD0MeugAgGAh1N2Ce88Tpp5I+iQ4ao2i2w3cN/CT9QHROXZbtrTGgdMxLXohhhIZAqVfg33o8wKKr2H6w80A3tcQ3jNBYUSgF1g0ypQ/fO6jOXNL347yA6RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWR4T273; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWR4T273"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3194FC433F1;
	Mon,  4 Mar 2024 21:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589163;
	bh=vJ55UNsjpa8ED4IaEhieaVOaA9OHgQhs0eoTEjXA12s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWR4T273G35ivUsaxd4dcHmGS2JS0dbB25qKaa5wfG1Jnt4x9UemgY+5XXP7FUpVX
	 sZu/YgjwWo06hX9XxevbqeT/Zc1ceXmCWgBTAWqy/aMAsanhyDGPMWmOw4ItCvUadq
	 w2xDY4UZPxyYWF/R8CFM0tHAEGOIxK1WJCbGKB2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Georgi Djakov <djakov@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.1 205/215] Revert "interconnect: Teach lockdep about icc_bw_lock order"
Date: Mon,  4 Mar 2024 21:24:28 +0000
Message-ID: <20240304211603.495045938@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 0db211ec0f1d32b93486e8f6565249ad4d1bece5 which is
commit 13619170303878e1dae86d9a58b039475c957fcf upstream.

It is reported to cause boot crashes in Android systems, so revert it
from the stable trees for now.

Cc: Rob Clark <robdclark@chromium.org>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1146,21 +1146,13 @@ void icc_sync_state(struct device *dev)
 			}
 		}
 	}
-	mutex_unlock(&icc_bw_lock);
 	mutex_unlock(&icc_lock);
 }
 EXPORT_SYMBOL_GPL(icc_sync_state);
 
 static int __init icc_init(void)
 {
-	struct device_node *root;
-
-	/* Teach lockdep about lock ordering wrt. shrinker: */
-	fs_reclaim_acquire(GFP_KERNEL);
-	might_lock(&icc_bw_lock);
-	fs_reclaim_release(GFP_KERNEL);
-
-	root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/");
 
 	providers_count = of_count_icc_providers(root);
 	of_node_put(root);


