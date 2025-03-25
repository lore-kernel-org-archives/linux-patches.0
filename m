Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4B82571DB;
	Tue, 25 Mar 2025 12:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905929; cv=none; b=GMoaFiLRQXg6/yKmODhla9f1ySJ7Cp2hddexVWVAcsUsJPA5tK74S/vPXgbHpXFg7YEhhh4rhAg+tMvBSLvtY5K1NRnPalY5D6JxfhIoINqK9jmOHGajZ9GGzrcXSyOGA/ijfcqeCQvUAssGqN4xKq4LgWFHr+4SRoH13nlnRNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905929; c=relaxed/simple;
	bh=D4/LmYY1nSONTbMVGa/aj40bS70pu+NgRD1f3NHOul4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twBmaQXXXcYOOWfY5/eV5RQezns7HRTR2kB2oNCIpiQFW2WkScRPnRMEatNvO2J6tovNg+9awyjW6hKyPZztfBDYlULNMpp3s2OM/GeG8QEztjkAMp5DJnyYPrc52HMrkcQe5d7DIzXE/ZHgIvpWofM6Qviry0PFTqZcPy7MkE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pm+fbz+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pm+fbz+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CCAC4CEE4;
	Tue, 25 Mar 2025 12:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905929;
	bh=D4/LmYY1nSONTbMVGa/aj40bS70pu+NgRD1f3NHOul4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pm+fbz+vY0k7pn5UdQPJhskdMwolvrjcJIYFO9ohLIyYx9rjqZxuKwInPDviP1YEL
	 bo29ztcioc021orqKtseH9LV7i1mL2lLiEYOYQjASEksiP9QXi36Fsode59lFVdFBa
	 BUMhtTV4/0DEwN+l7faKB7puO9tQNDIOzDwdSpDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 041/119] devlink: fix xa_alloc_cyclic() error handling
Date: Tue, 25 Mar 2025 08:21:39 -0400
Message-ID: <20250325122150.107952407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit f3b97b7d4bf316c3991e5634c9f4847c2df35478 ]

In case of returning 1 from xa_alloc_cyclic() (wrapping) ERR_PTR(1) will
be returned, which will cause IS_ERR() to be false. Which can lead to
dereference not allocated pointer (rel).

Fix it by checking if err is lower than zero.

This wasn't found in real usecase, only noticed. Credit to Pierre.

Fixes: c137743bce02 ("devlink: introduce object and nested devlink relationship infra")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index f49cd83f1955f..7203c39532fcc 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -117,7 +117,7 @@ static struct devlink_rel *devlink_rel_alloc(void)
 
 	err = xa_alloc_cyclic(&devlink_rels, &rel->index, rel,
 			      xa_limit_32b, &next, GFP_KERNEL);
-	if (err) {
+	if (err < 0) {
 		kfree(rel);
 		return ERR_PTR(err);
 	}
-- 
2.39.5



