Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C5522F14C;
	Mon,  2 Jun 2025 14:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873293; cv=none; b=nelS4GhV2VmDVS5hh/yq3sRMI+s9derhUZNuCY3N5GKEEaEuGDqkl3kNKFXLRg9/G7neKXKhqsSU1z1l1a+YfG1emqx9S404PpPgFTnLF6izFQIzBWGftKHxns2TPlJi9nkCL8ytTLbHbAfcwYEufQQsfjD+yeTpStVIdJOo5iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873293; c=relaxed/simple;
	bh=JvfS+qMOkHRLfFIEemJibIZ+b9bK6E+gKPN1xEGNvUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0Wf/VJUB9BRmjxO8FJz2XcoHVNKvIJlakpYNRKLx5+SuOSWjS9ZsiidUoe3R9aX0UO5CsLMybELJJnpjG1aVWwUwvUkZODCZ5kN8t0H0jPeP95Ft2MW8xthp/4wUkO1O/z/U9yQXtnTm3/JWCi74edWvNtTNZlAzraWln6nsLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIi/hq6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIi/hq6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA37AC4CEEE;
	Mon,  2 Jun 2025 14:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873293;
	bh=JvfS+qMOkHRLfFIEemJibIZ+b9bK6E+gKPN1xEGNvUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIi/hq6f9EKAqm2ul37gvFxbt/8tN/9vYQjPUhBJ6DZ4UdXriFqV9ylhNYx463XgI
	 E599+/X6rqXfs2TofjJrXxiaVBTmcYA14t9XNCfebG/t2k/1+DzdN/vH3VecqZHxtv
	 CuZhD50fC8ckgT3yzmtORI7fQv5zqPsVeVF5UQZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/444] thunderbolt: Do not add non-active NVM if NVM upgrade is disabled for retimer
Date: Mon,  2 Jun 2025 15:42:40 +0200
Message-ID: <20250602134344.796950689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ad79c278e478ca8c1a3bf8e7a0afba8f862a48a1 ]

This is only used to write a new NVM in order to upgrade the retimer
firmware. It does not make sense to expose it if upgrade is disabled.
This also makes it consistent with the router NVM upgrade.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/retimer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/retimer.c b/drivers/thunderbolt/retimer.c
index 2ee8c5ebca7c3..43146c0685dfa 100644
--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -89,9 +89,11 @@ static int tb_retimer_nvm_add(struct tb_retimer *rt)
 	if (ret)
 		goto err_nvm;
 
-	ret = tb_nvm_add_non_active(nvm, nvm_write);
-	if (ret)
-		goto err_nvm;
+	if (!rt->no_nvm_upgrade) {
+		ret = tb_nvm_add_non_active(nvm, nvm_write);
+		if (ret)
+			goto err_nvm;
+	}
 
 	rt->nvm = nvm;
 	return 0;
-- 
2.39.5



