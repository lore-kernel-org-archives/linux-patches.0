Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE86428368A;
	Tue, 27 May 2025 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365902; cv=none; b=iRpqT8eyB98XISsDmJWgsvLxMfcAm0Iil/kiT6kOJ5bm5/GExGgb7YC4IQkjOA95Iauxag7r3PKMKrUcxaRhMAzrLn/5Bci56Ro+8IimJFL3TcaiShPDa8zq5g+SqqLZMIW4iWCWQp2wA9IjEcdG1oKeOErkjKbVC5/5JvXRa7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365902; c=relaxed/simple;
	bh=rfx6EPQqduuLtNTBGjm/rOEihz6w0l6AZRzTBE9Ndww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkJO2p0Y41JaZ2gasLqYbHE6k/Qb9sbGgfdsYr9+yBKcJ5AW4QJBpH4Mzu5zw28uRjcsobYu1MGsH89lfpXW9qU8N9jLT/BCfKUw3qB6pUvWOS4BzwYHcSWFjmlF9TSoXke5eT/u9Z/1DWUYALmjkTEsPvuz30tCnlqjb6W9i64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jf4i4TW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jf4i4TW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF44C4CEED;
	Tue, 27 May 2025 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365902;
	bh=rfx6EPQqduuLtNTBGjm/rOEihz6w0l6AZRzTBE9Ndww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jf4i4TW7PvxGIg7d1QnJmvPpMYT4MSXkOLFGBWmUTIOOtLTBXbV5owiP/dWUmuLf0
	 wD2GhT5bBvyHHjDNQi4rS9QsR12leZXCBt9gLshYmSWq1w1rduaG5chblH1eA7/tkq
	 EdIXkdFRLQVzP3slozO/Hd8nIcD+I8I4w0e8Wqrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 527/626] tools: ynl-gen: validate 0 len strings from kernel
Date: Tue, 27 May 2025 18:27:00 +0200
Message-ID: <20250527162506.407690324@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Wei <dw@davidwei.uk>

[ Upstream commit 4720f9707c783f642332dee3d56dccaefa850e42 ]

Strings from the kernel are guaranteed to be null terminated and
ynl_attr_validate() checks for this. But it doesn't check if the string
has a len of 0, which would cause problems when trying to access
data[len - 1]. Fix this by checking that len is positive.

Signed-off-by: David Wei <dw@davidwei.uk>
Link: https://patch.msgid.link/20250503043050.861238-1-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.c b/tools/net/ynl/lib/ynl.c
index ce32cb35007d6..c4da34048ef85 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -364,7 +364,7 @@ int ynl_attr_validate(struct ynl_parse_arg *yarg, const struct nlattr *attr)
 		     "Invalid attribute (binary %s)", policy->name);
 		return -1;
 	case YNL_PT_NUL_STR:
-		if ((!policy->len || len <= policy->len) && !data[len - 1])
+		if (len && (!policy->len || len <= policy->len) && !data[len - 1])
 			break;
 		yerr(yarg->ys, YNL_ERROR_ATTR_INVALID,
 		     "Invalid attribute (string %s)", policy->name);
-- 
2.39.5



