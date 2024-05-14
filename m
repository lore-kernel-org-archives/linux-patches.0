Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05F312F5B2;
	Tue, 14 May 2024 10:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682436; cv=none; b=WEoOdBcL7jgjkDH6vIG3/ghaR497hyyXInsFg90FN4d20O57P21Fu6tce6iQHNsbvmHlwwMgKDusjozO4OSg2Si6kRfIXQb+Ze7TMAd2Oq50rpSIYiRArB4KGgU0kCocL2aTaa23/FVB3oP1YojsO6CbeNodXORpyq5/UWP3+SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682436; c=relaxed/simple;
	bh=WKCppEWi+CHecmPfoEbxifFR/Xo4S4le29cHVAKStRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YGlgfMzuj4H2Ol37wl1Ap1BezSeSqPJccKazOEWPsX8M86F7jXFEz/eoSC6CRHh4ThhOrF9oZPPz5VmESFbqHWHx8tVhWwKq7kyXusfj7id8LX4OoYSo87TpRlsJ4pQ4spEiIsykhhSERQqcaetcVCP+o211nNaOd7K9LLkk010=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHeYZpgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHeYZpgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C74C2BD10;
	Tue, 14 May 2024 10:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682435;
	bh=WKCppEWi+CHecmPfoEbxifFR/Xo4S4le29cHVAKStRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHeYZpgFv2gg/NTOKBsLBkAc/avH1qx1wkUfjr+M0326+lCzeIIEkpgXcjDoxRW2S
	 4lNdc6lmv/S/8xNno7jrDjFuwMWcDoWVgMEqzW2rNMr97IVi3EY5jmTo2+wluycIsD
	 lQJFm9WI3CmeEPr+6ItoB+4NsfCRzGE1JocVRe7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 060/336] net: qede: use return from qede_parse_actions()
Date: Tue, 14 May 2024 12:14:24 +0200
Message-ID: <20240514101040.872198666@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



