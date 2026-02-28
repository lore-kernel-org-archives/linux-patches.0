Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718D4375AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301621; cv=none; b=s828M55wX5YluxoGFdvIKLWz949VX8wNMV4suu9OI/ZMh55SDvQwmRA2ymEkkGwplCsxF1WqjTxkFbTV0Gsl1kwH+9kRXVrvjdHzHNH5tNyDWjJwCcUxSFwZfp5wA5U9Oj6nb7LFOVu9QLIeeH2Gslr39zzJF8BNE77h43XTBNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301621; c=relaxed/simple;
	bh=ObaJ8EIxJDndK83zpRMY8Pz0POdulBXmipwPxtgUJQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zji0BoAC7x5QUyYEpMQm3mayBK4p5axblead4OOF4pcSvempUr87pDOyWxktj6K+Vo66AeeTRJEvT01dVBU94tC6CkiAe0B8qTq6UezlGtHfp+RSmlanbfbPDhp35JPO3Z2RaiRzbByUozKR5N+F3TA5dyq1JCBN2bwFrJzUA+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENYIqqbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENYIqqbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0878C19425;
	Sat, 28 Feb 2026 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301621;
	bh=ObaJ8EIxJDndK83zpRMY8Pz0POdulBXmipwPxtgUJQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENYIqqbog6pHzPF2gePt6JoVDduvg0DnuxxFhJlJkT55nSx4U6Hc6Gbg2hTfdNxHA
	 XXvmiqIOiUq4n/WId6I0K0m6rTox63TYSAYnelrwyykh+/jMx1XMWYRdtdRWFE3AjR
	 Mg76xcomhbIcFQeGgz+YQbUDKkdtCAGb1Ux8PirucLyNjzgvqmYFYi31ovl9OiNvQa
	 VcBCJIoDi3vgNlNSR1d65S8hImmXkok9w+Zff/qan8uJCkLAzUPjmSICT1y5kk8CKC
	 8jKSbSicQ38Zw/WzrEGlWj/UhyKj4TrBsuBTPfaEDEfOxguAiQEg7tu3rIiaioSK3F
	 gQ7Kb6/hUHBiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/385] i3c: master: Update hot-join flag only on success
Date: Sat, 28 Feb 2026 12:53:53 -0500
Message-ID: <20260228180011.1568201-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 5c0cb3f38c90b..fe6f956cc3111 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -619,7 +619,8 @@ static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
 	else
 		ret = master->ops->disable_hotjoin(master);
 
-	master->hotjoin = enable;
+	if (!ret)
+		master->hotjoin = enable;
 
 	i3c_bus_normaluse_unlock(&master->bus);
 
-- 
2.51.0

