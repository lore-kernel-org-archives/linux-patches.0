Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3364E1487CD;
	Thu, 12 Dec 2024 15:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017000; cv=none; b=eiX6a3dDyCyI2GIDiOYXR2njquW5+ULfFNGxIMwu0S5SVjIuOfzp02fcEc6wJ2P9Lpt4BkrgVDh9K4pJLa05U9ElmfdcJl7ayKadG7IwsxsZTVvmYlkqNdvkLP8djaYzQ63SyiToNSYdKPz4pOfID5PpJtCfRB3cH/AlCasziPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017000; c=relaxed/simple;
	bh=INs0ifV7W0PdQagi671WRFB9cPCvnVCRzMltVE8gVOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcMUrH7/cgJg/6xX+3CcmY09t8u1LJ73l45d4HHC/brbAe3NAWn6NzLi0kUKqVyctZ3syvq1VbL3tv6MNx1FoRvhslcilgy5dClpi/mdRFuu64RHhStqD455kBqXr/n1uAFPFL1JpPE3z9fNyWxZgNZYbNBqrSoNUTH2YAZ2bwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFdYc0cT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFdYc0cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95116C4CECE;
	Thu, 12 Dec 2024 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017000;
	bh=INs0ifV7W0PdQagi671WRFB9cPCvnVCRzMltVE8gVOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFdYc0cTX2V9NNJAklym+gnA37fuI/doLq6gLld3v5kcATEbMr4n79ekBwGRgg6W5
	 EOrE2dYUxbTOIYvlqugecw5LTfpmsJP5cVnMRdvQrPrWlj8kFawtbp89B1iYSsBIig
	 EJJ9aPRA5sKIQKb1tcI+bWAZuwlHx0T4131lTDBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 352/466] net/neighbor: clear error in case strict check is not set
Date: Thu, 12 Dec 2024 15:58:41 +0100
Message-ID: <20241212144320.691929465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0de6a472c3b38432b2f184bd64eb70d9ea36d107 ]

Commit 51183d233b5a ("net/neighbor: Update neigh_dump_info for strict
data checking") added strict checking. The err variable is not cleared,
so if we find no table to dump we will return the validation error even
if user did not want strict checking.

I think the only way to hit this is to send an buggy request, and ask
for a table which doesn't exist, so there's no point treating this
as a real fix. I only noticed it because a syzbot repro depended on it
to trigger another bug.

Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241115003221.733593-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 77b819cd995b2..cc58315a40a79 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2876,6 +2876,7 @@ static int neigh_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 	err = neigh_valid_dump_req(nlh, cb->strict_check, &filter, cb->extack);
 	if (err < 0 && cb->strict_check)
 		return err;
+	err = 0;
 
 	s_t = cb->args[0];
 
-- 
2.43.0



