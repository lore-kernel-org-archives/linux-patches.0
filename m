Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9427C080;
	Mon,  4 Mar 2024 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587667; cv=none; b=pAfpdOBGAqk06fsdC/WXEBONLg7e1nZsPKxeSkNYxOFjm7MaP8PLFxbvlZIjShquPjd+rk9Y8mdC6uRaLBDkbpxwKK74c9Fy/9IbLZLUCc5DiOPO7VKrNma3+ciPsTjUNXwH25PvH4SGELGYd6/IUWU86JFD8RZbME9H/nxaOCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587667; c=relaxed/simple;
	bh=KngQK66CrU27lD5sGkjiuPEozQ0gIFvMm5gInAfRrgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpUXXpiEWgwzQSzXhIaSdWefo+ZObmsVq8GKxNjkNmHiw3LQEqgWU5pxpDgft46jTkk1NGbwg4uiVKNIJ+7bEpUUenGQfMaLUT3SO8TkkVTU89rLHtV/StjH536Q8Ya1N/sevB/w+CAibvFCEVVVjJ5ZsFDQ26an192AYD33H70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eii4E/EU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eii4E/EU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA012C433C7;
	Mon,  4 Mar 2024 21:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587667;
	bh=KngQK66CrU27lD5sGkjiuPEozQ0gIFvMm5gInAfRrgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eii4E/EUiUwZdIV6Rz8kPcRp6HuVq+WexfrpaCrj3xj17JyIrU9e8TTehSCRNEOhB
	 h3SNZQEtgU7G8v2ruIrbp4aZSYBjuN/NRxIsWutcRfVGo4psoPlwvwsA2MyfORkbSj
	 6nzB/LWmNKIjGqHrtAljFAVeExr82QTux/BDXVe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 036/162] tools: ynl: fix handling of multiple mcast groups
Date: Mon,  4 Mar 2024 21:21:41 +0000
Message-ID: <20240304211552.992107987@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b6c65eb20ffa8e3bd89f551427dbeee2876d72ca ]

We never increment the group number iterator, so all groups
get recorded into index 0 of the mcast_groups[] array.

As a result YNL can only handle using the last group.
For example using the "netdev" sample on kernel with
page pool commands results in:

  $ ./samples/netdev
  YNL: Multicast group 'mgmt' not found

Most families have only one multicast group, so this hasn't
been noticed. Plus perhaps developers usually test the last
group which would have worked.

Fixes: 86878f14d71a ("tools: ynl: user space helpers")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20240226214019.1255242-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/net/ynl/lib/ynl.c b/tools/net/ynl/lib/ynl.c
index 591f5f50ddaab..2aa19004fa0cf 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -519,6 +519,7 @@ ynl_get_family_info_mcast(struct ynl_sock *ys, const struct nlattr *mcasts)
 				ys->mcast_groups[i].name[GENL_NAMSIZ - 1] = 0;
 			}
 		}
+		i++;
 	}
 
 	return 0;
-- 
2.43.0



