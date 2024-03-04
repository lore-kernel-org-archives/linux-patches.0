Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC2D78B4C;
	Mon,  4 Mar 2024 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589389; cv=none; b=H5YHcMvwL/wFuF02+GjvhmIyPrkljx2hoMCzEMSP6BfTt8JnbcvUSlzrvw9+qT2O1GRcVXBzbC3llEuq50l2gmJDfO1TUx1f729Cs0hYJAaR7/cIveo4+dZxmB3bGKYNFcO7WYJZ3I1Nly8j95QopPMM744/iEoUhYHRYwuvDrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589389; c=relaxed/simple;
	bh=zlHGyVmAG7DW2sazddgTuNr3glka6w8cUYiEuzWCPVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCFsLxUPaFk1/HIjT2FdRe3MMPaibQDAlpzHX6ftFkrZW8XQuwet/EitPOic3W4Qd/fYmpvfHN72qoOT6nwD8a/4dHeBlZOlehQCht3lhYqsaVRulFcV/+ylpjcoayjxXqWPUDzFQCwnlqdUbxFpgLOyf4Ch7UVgaOzNX7S4nU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wluKOVps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wluKOVps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05FEC433F1;
	Mon,  4 Mar 2024 21:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589389;
	bh=zlHGyVmAG7DW2sazddgTuNr3glka6w8cUYiEuzWCPVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wluKOVpsNeRW8B79hzQJl6oPztemTAi4qfRuRMd8WbjGC5/xPIUcnXznzzOG7Ggf8
	 bxKUd1VgAJyBA+wNNDgbSsz3E18OqbzhVpbqjvBa/91p0AyJ6Tw6itq5KTLdZ8Trsf
	 ZdP+TYSso00u7e8C1KyfdYIaiL/XTg5JKEQdPFhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Georgi Djakov <djakov@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 5.15 78/84] Revert "interconnect: Teach lockdep about icc_bw_lock order"
Date: Mon,  4 Mar 2024 21:24:51 +0000
Message-ID: <20240304211545.011234761@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit e3a29b80e9e6df217dd61c670ac42864fa4a0e67 which is
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
@@ -1135,21 +1135,13 @@ void icc_sync_state(struct device *dev)
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


