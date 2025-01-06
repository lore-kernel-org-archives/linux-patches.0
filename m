Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0217082A;
	Mon,  6 Jan 2025 15:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178030; cv=none; b=GzJPaw+w3xhYwnOFB8vIufi3FHgTjS0G3pZnjBtocl/Cxhh2oFqcim8mOgq2UdWasOrMIfOvWn7fz/uclsIeHJl0L8zX2LjUz0cXC/9hzUU64XRiQ3aSLoD1uReyjHpywx5b/0BtKZPVeSGuPlbDfWPFcaEoy6P9eBddUwKQeFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178030; c=relaxed/simple;
	bh=3p0GNTkbPulqGqDz0cVffkfG/0OQNgLB86xIONebYYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wu9i951do9QZGTgOolx3idA8S5LBEIGUZjPMzVq4i2ATKRkihLFEitSbR/gNQ7igODadeQHGDrQLqzStVnOYe1uvAHANr9IMowtez932FVQH25YWCW4tWMcorzc5Qnm6rWKw+d2PXliiSswZvT+GXvYEuJp38ygt4roo8LTzFIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfsYAoaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfsYAoaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9B7C4CED2;
	Mon,  6 Jan 2025 15:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178030;
	bh=3p0GNTkbPulqGqDz0cVffkfG/0OQNgLB86xIONebYYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfsYAoaRtfNwkBSv/bsLoUfl9ciz7tSIcF+v9fBhvylScOyW+AlOMSlR4GaMKnuK2
	 ZC3aCvDidxC1ibWgSkkJcwQSUlc34h9thdwxO8tjvA2O6h8HNJ87eqrtRrOJwwAmPZ
	 SLaxr+WoV9Ic/N+cqurcB9EI4oQX7Tr1G2O8Sg6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 138/156] mm/damon/core: fix ignored quota goals and filters of newly committed schemes
Date: Mon,  6 Jan 2025 16:17:04 +0100
Message-ID: <20250106151146.929099200@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 7d390b53067ef745e2d9bee5a9683df4c96b80a0 upstream.

damon_commit_schemes() ignores quota goals and filters of the newly
committed schemes.  This makes users confused about the behaviors.
Correctly handle those inputs.

Link: https://lkml.kernel.org/r/20241222231222.85060-3-sj@kernel.org
Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dc52361f1863..0776452a1abb 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -868,6 +868,11 @@ static int damon_commit_schemes(struct damon_ctx *dst, struct damon_ctx *src)
 				NUMA_NO_NODE);
 		if (!new_scheme)
 			return -ENOMEM;
+		err = damos_commit(new_scheme, src_scheme);
+		if (err) {
+			damon_destroy_scheme(new_scheme);
+			return err;
+		}
 		damon_add_scheme(dst, new_scheme);
 	}
 	return 0;
-- 
2.47.1



