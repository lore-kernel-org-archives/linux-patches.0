Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AD21C6AB;
	Mon,  4 Mar 2024 21:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588245; cv=none; b=eh78+zVYWX4ydVd6CoynGVYwjIKlMpZ6S8wK0FP+XuzyCJJ//WSEin1U7EpFFfV4uGkT6fQRVOMP/TM/dvQbEKZmlH6eoDr3y3797o7Y7ANS72xr9zH7+hRoTC5rjpgQF5Kqc40uXR8LpKGVi5+9VzflrPscry7/V0a6J/TEK6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588245; c=relaxed/simple;
	bh=aGg6vRlOkiNLATLx+RhsvSVEc/mn9ewKFaThlGJM7xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hG5PQ2GJ0HYggu0o59Xpzipf7eu8eqi2eHlVw/rvGzBXwKFrTzZwv00qp2P8TEzPxkzrochMXruwtN1hO7I1z8FdvYO6qcle4yUdo4pHu3Bvy+u4w6V4m6DYhILMsDllgDIHNwotURBp0mMd0bqJMwo6MTmGAe1kADlC660y614=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeJdx8cq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeJdx8cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC34DC433F1;
	Mon,  4 Mar 2024 21:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588245;
	bh=aGg6vRlOkiNLATLx+RhsvSVEc/mn9ewKFaThlGJM7xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeJdx8cqovIqL14ng6RlWzCQE0dLFiX7xCTfQ+rOXr1kkwB/Gznr9IooPlYbxUT4U
	 nEMHtnFI3bizifOS7cxgns9XF+cdkFdJYJSwKglsQCkowsFtnRSAIQXfsa9r9ONEVg
	 5Xsn/QZWNTaiPw/i47BxnOlu6hH9sPTr3YggNbAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/143] tools: ynl: fix handling of multiple mcast groups
Date: Mon,  4 Mar 2024 21:22:34 +0000
Message-ID: <20240304211551.023915761@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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
index 11a7a889d279c..ae61ae5b02bf8 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -507,6 +507,7 @@ ynl_get_family_info_mcast(struct ynl_sock *ys, const struct nlattr *mcasts)
 				ys->mcast_groups[i].name[GENL_NAMSIZ - 1] = 0;
 			}
 		}
+		i++;
 	}
 
 	return 0;
-- 
2.43.0



