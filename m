Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12E4168C7;
	Tue, 14 May 2024 11:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684818; cv=none; b=QDAjPxKNmLXR2hatOelSNauzOOYxbp7ULXQLyLpu1hqlepB7Gh4Iv9/INSTGemdPm/1qBQO+xN46UP/jrKwtD2CZmVawgOsDWpCf2RU8qRO8Zavgrir12EssXr8sTZUUqLqg3mRCZeg+iKlKQj+dnVsAzlL3eX2AM5BNnlOMcr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684818; c=relaxed/simple;
	bh=ZBK6hkhvEFC/RQpGLHmzweWF7PjA7yU9IlO7QxfmfcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZiJLzhDTtWVn7g74LLpEIYg6glxxlTPPTgy2kTieFVnTNHY+VoVK6sNpsS7hZBVq3wloHXSCGxyrRp0omRu8uwlrUWElhzwl8aiHzRNxrj9UyqbO4Yvz4olcu22zt0gQNRiGF7frI5f53BsZomdQbW6f10fGkBqv8DicpiQMec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiAqm2k4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiAqm2k4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B599C2BD10;
	Tue, 14 May 2024 11:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684817;
	bh=ZBK6hkhvEFC/RQpGLHmzweWF7PjA7yU9IlO7QxfmfcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiAqm2k4JB2zEg7BKSO/OSeeRFTn4pS4w6Xo+WvQzFvK5XvlkNkD3QUAWwr0PO0H9
	 qTVfMZbLu/09fBbVVO17CrWqyhe0mNgrdG0WhwRB2mG+4kjTZgbOj2x57DtbExDJll
	 VhORs+Fn1ReTMgFdb5agCAsLRH1TNtuRYQQYzIQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/301] net: qede: use return from qede_parse_actions()
Date: Tue, 14 May 2024 12:15:33 +0200
Message-ID: <20240514101034.585053169@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit f26f719a36e56381a1f4230e5364e7ad4d485888 ]

When calling qede_parse_actions() then the
return code was only used for a non-zero check,
and then -EINVAL was returned.

qede_parse_actions() can currently fail with:
* -EINVAL
* -EOPNOTSUPP

This patch changes the code to use the actual
return code, not just return -EINVAL.

The blaimed commit broke the implicit assumption
that only -EINVAL would ever be returned.

Only compile tested.

Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 377d661f70f78..cb6b33a228ea2 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1894,10 +1894,9 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 	}
 
 	/* parse tc actions and get the vf_id */
-	if (qede_parse_actions(edev, &f->rule->action, f->common.extack)) {
-		rc = -EINVAL;
+	rc = qede_parse_actions(edev, &f->rule->action, f->common.extack);
+	if (rc)
 		goto unlock;
-	}
 
 	if (qede_flow_find_fltr(edev, &t)) {
 		rc = -EEXIST;
-- 
2.43.0



