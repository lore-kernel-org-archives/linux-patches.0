Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C84382871;
	Wed, 19 Jun 2024 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802311; cv=none; b=Q6EGxQmgK49HUD6kIqSLOo9jvT4+s++3mqx+ncukmo537XKILlsUItw8pTcioTr15FGq1lRgmNxdXoEQqWCo1GowQgHvJNMCbTBkMVhu84FRhcXbGnoiuVvUjS2wBCibZgODGwgHwfmC9bFpcXHEEA8aJnXUU+T1lNc9k26+98w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802311; c=relaxed/simple;
	bh=H6EwSKKB0DdT/CAajCBSxjvDCzqNpuTz9tvpt5tcWTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlX4ZSIY5/b4bLVLB019GURpQe8SjuPVPJd6XZUDMDg7/3iZhEMw0HZ36dXCUmhlYxzVCqAUMeyfWRzQmtO8F85kRjyxZZzVQ1LMN6pdTHomQ2dUptToxUN30BXzdlakLmtvtwpDtdVbddjBvtKHpYeZM0/EOri8H8r8z8WYo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGgIzPzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGgIzPzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C460FC32786;
	Wed, 19 Jun 2024 13:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802311;
	bh=H6EwSKKB0DdT/CAajCBSxjvDCzqNpuTz9tvpt5tcWTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGgIzPzrrDQqLfkU5Gyk8OW+73ozXaOXTWEbgadjutx/J4UL5bO3u4EdvFfROt2+R
	 2jzwRNiVi9DfCCxDVOAslM+jfPGbmjdCrXvEt3rQ0rF0nmvpxDME6RQyeVSNJ1LQ/n
	 fQI2E35m4UvljuMt4zG+jH6eOGC3xn1e7V+Fbqlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiwen Hu <huweiwen@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/267] nvme: fix nvme_pr_* status code parsing
Date: Wed, 19 Jun 2024 14:54:33 +0200
Message-ID: <20240619125611.031377619@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 391b1465ebfd5..803efc97fd1ea 100644
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



