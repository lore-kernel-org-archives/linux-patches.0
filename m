Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F2D1C07DF;
	Tue, 15 Oct 2024 13:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997967; cv=none; b=MSfNDL6SyAhN+oUBrO9LzVsxAeep3VCcN9c5Ejr7C94cwi2sgJKKc7/qFlhiY1UNZmwneuGK8xaNDhUvcCLjv5zNZmWZo6uUhA5AInJonkLgj8tUGKnz2LVkXEoEp5VOdVwlut8wbM22JhBooMVm/1izpz+LfjjNwEtGVBRcZ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997967; c=relaxed/simple;
	bh=XTF9xmdeT5WwwQDCrh+PDetaQCKfZxuM03P+m2SxGWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpUYRvitNjoUSbSdVV/Uws4Ynv8dOd1MzA2AMp4a+eCoSbnQ9EgQANZczQW+v0Bwr+WVN9AWScLdlR0vcHU6MkgNLt31tKvspfsnRSUd/oN69VzGhK+F7HAMNBKuUxEOSs1BCATy7FJENe1rfH/GoB81qXeqGd9qGv9Qa0Mf3A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBOU8pNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBOU8pNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6003C4CEC6;
	Tue, 15 Oct 2024 13:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997967;
	bh=XTF9xmdeT5WwwQDCrh+PDetaQCKfZxuM03P+m2SxGWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBOU8pNEmYS3C16hbmHuR7KTJ81DwtX8WPzY/Xdf3t5RrDPxUOcRr57+afti1inJs
	 y9j+U/GV5+I9nNYJFEjsDtA5NyKN9pVAyZXXinVeKgdRvO3B9fbfFU6i6XQSKQt8BX
	 IUXRBQXf0wOiiTHu50O60A6tcAr/66WhIcF+eoew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/518] tipc: guard against string buffer overrun
Date: Tue, 15 Oct 2024 14:43:33 +0200
Message-ID: <20241015123928.909433455@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit 6555a2a9212be6983d2319d65276484f7c5f431a ]

Smatch reports that copying media_name and if_name to name_parts may
overwrite the destination.

 .../bearer.c:166 bearer_name_validate() error: strcpy() 'media_name' too large for 'name_parts->media_name' (32 vs 16)
 .../bearer.c:167 bearer_name_validate() error: strcpy() 'if_name' too large for 'name_parts->if_name' (1010102 vs 16)

This does seem to be the case so guard against this possibility by using
strscpy() and failing if truncation occurs.

Introduced by commit b97bf3fd8f6a ("[TIPC] Initial merge")

Compile tested only.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240801-tipic-overrun-v2-1-c5b869d1f074@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 2511718b8f3f3..69dfb04310085 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -161,8 +161,12 @@ static int bearer_name_validate(const char *name,
 
 	/* return bearer name components, if necessary */
 	if (name_parts) {
-		strcpy(name_parts->media_name, media_name);
-		strcpy(name_parts->if_name, if_name);
+		if (strscpy(name_parts->media_name, media_name,
+			    TIPC_MAX_MEDIA_NAME) < 0)
+			return 0;
+		if (strscpy(name_parts->if_name, if_name,
+			    TIPC_MAX_IF_NAME) < 0)
+			return 0;
 	}
 	return 1;
 }
-- 
2.43.0



