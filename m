Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC59AD58;
	Wed, 19 Jun 2024 13:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803022; cv=none; b=HwYKwU0+Mm2wPKO8fE4afMhmUBOcXUPoHf2EIDf+Ag/DRRwi3QAjLwiRPaHKak1aPg2aXah0ReF3RvgNKREFMS1ncYwGQevspWzL4KRWHa5VknwrB+oIqvGgYDvGHoLMaA8cENsBwPd42AvjV4mb70bj0Vc7i7gEAvDdfDsnAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803022; c=relaxed/simple;
	bh=yIwcwDZ04LOD6rTUCieyPulYoiOYJC6QBxIuzW8UavM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvDeDJx3S9n3XN3VK74DX7Bo6iNzwOdox74dlgjAYmVt6K9oCWgahpJ7qVrP5sKGZ5whMWohXH8lV2jVlT42SZXVkj5ME/NmQ2/eadYC8V2MsHeJgqfEYYiZw3rZbtokbBcF0kID6QV0bTL6COtboL7g5tMzLB+3lJavraBLc78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpdvwX1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpdvwX1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3536C2BBFC;
	Wed, 19 Jun 2024 13:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803022;
	bh=yIwcwDZ04LOD6rTUCieyPulYoiOYJC6QBxIuzW8UavM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpdvwX1Ot7X/1ZC3KmRU8cwN648p9756w2htoUIQeKGXSKJ9f5iugDf3jNENrA8z+
	 trobfuc5hAbK0oK+N7PY5JolfcfhDv4KUzPBLNReSEAYc7pWvv7LpTrfhIoR9UyD17
	 /y1Ajzh7j/dDDq8dgRMMhw6KpkDyy2IVk1LhJJC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiwen Hu <huweiwen@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 127/281] nvme: fix nvme_pr_* status code parsing
Date: Wed, 19 Jun 2024 14:54:46 +0200
Message-ID: <20240619125614.732032046@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiwen Hu <huweiwen@linux.alibaba.com>

[ Upstream commit b1a1fdd7096dd2d67911b07f8118ff113d815db4 ]

Fix the parsing if extra status bits (e.g. MORE) is present.

Fixes: 7fb42780d06c ("nvme: Convert NVMe errors to PR errors")
Signed-off-by: Weiwen Hu <huweiwen@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index e05571b2a1b0c..8fa1ffcdaed48 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -77,7 +77,7 @@ static int nvme_sc_to_pr_err(int nvme_sc)
 	if (nvme_is_path_error(nvme_sc))
 		return PR_STS_PATH_FAILED;
 
-	switch (nvme_sc) {
+	switch (nvme_sc & 0x7ff) {
 	case NVME_SC_SUCCESS:
 		return PR_STS_SUCCESS;
 	case NVME_SC_RESERVATION_CONFLICT:
-- 
2.43.0



