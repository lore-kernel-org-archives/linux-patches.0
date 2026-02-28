Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D2236C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302296; cv=none; b=lQNJUmkU+LLSlUTfP4UPI3UvXlQ8sbVNOaqVy6SRhvOt3ZxgiXoM43C4xg8e8F5fM64NXNSfQFPnotGy/yUDGP5qJ1SuEqot7lFtjyINs2xL5tN3p7nnIG2ZRYc3aPlYNn/n3oThbVZzS9K8wURVBwWZ+tVjZVqFoCv5H/WBNTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302296; c=relaxed/simple;
	bh=4vsN6sJQl6/9Cqq0DSuax4Dm1GQpR5Gaei1MpE2BsoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCYf6Ax4v0SOAqVMHSK9fkHJYmxQhDlm2jmXJCnxlkcdxFKXFHTR5QZH8JlBuPX5M8FfwRmH9CEUFgJoraVRVvY3q34sbIvPNxmpyrKYWXwD86W8YwN3kbkVTOEwjApVFjQ0mIDBFdXEsWT16fBOyU3bFJOqd2vT6IJCE6QB8ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=poTKcDOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="poTKcDOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FE3C19423;
	Sat, 28 Feb 2026 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302296;
	bh=4vsN6sJQl6/9Cqq0DSuax4Dm1GQpR5Gaei1MpE2BsoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poTKcDOXL8R5BFjcGPSKr+t7DOJITMBWYuRkPXcdDJVbgoLY5h0AvuBW2H/ELx+QS
	 b7m9kJ600EIHMTvhOuOUUSaofq7nTYvKQJrciMKM9hCxexLNouCJrvFruxIDjMA4ET
	 v0qiTdQ7/19ryivk0lXerkUCXcEFyZas7jKKz9ly5IGRPK0tb3H8Q3W6fsqb9Ec303
	 GsUMroWF4A5ejPyRFkdsSU3SYNrqFV4H1rHvj8fruNqUddOGJ2jV/qZAhjStXPqh4k
	 5Hq4/fh0hK2MjCad3iLErcpWq7hG53GPffcdfUQNDwEJgpr10sPzlGggGGVmsEk7me
	 Wj1oxQiS4N4yw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/232] i3c: master: Update hot-join flag only on success
Date: Sat, 28 Feb 2026 13:07:42 -0500
Message-ID: <20260228181127.1592657-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit f0775157b9f9a28ae3eabc8d05b0bc52e8056c80 ]

To prevent inconsistent state when an error occurs, ensure the hot-join
flag is updated only when enabling or disabling hot-join succeeds.

Fixes: 317bacf960a48 ("i3c: master: add enable(disable) hot join in sys entry")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index fea1f852358c2..74138c499642e 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -586,7 +586,8 @@ static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
 	else
 		ret = master->ops->disable_hotjoin(master);
 
-	master->hotjoin = enable;
+	if (!ret)
+		master->hotjoin = enable;
 
 	i3c_bus_normaluse_unlock(&master->bus);
 
-- 
2.51.0

