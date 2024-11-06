Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E431DF254;
	Wed,  6 Nov 2024 12:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895253; cv=none; b=u/M7lM5is02w9D5Ku4MGM78aMpvAjSpyzM1Qp4IWnBUQ3Sp0fPS8njsi9yl5qf6i2d9bnITAZsRqmF5AIyWMcTUf/2bkiAgficuS54GR+kvWX9gflZA8SEC6WASOZpGsFWg5rPhwzGzxbjVybf/7gV62KAPTSjValvdcd3HyiOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895253; c=relaxed/simple;
	bh=KLLgt7zVSsNtqxXUwnw26C08FPUMn5b14VFbeEQSWwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkIbCQ2/bl9JQYwTXTYmUXGXWl0zppCufGGb001SXycW9suf3DyR7UCF3KxXB7oa+unV+7/Bhx79JfuYaRnugTK+FIitA7f1mcpkKsu97HZUiZuZcOoShW9nHwQULJmo9wRN4tj9Q/GZsUZgQbrs0LSU2zqb1ZwL5rV38gRYK1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZYhlAFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZYhlAFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1BCC4CECD;
	Wed,  6 Nov 2024 12:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895252;
	bh=KLLgt7zVSsNtqxXUwnw26C08FPUMn5b14VFbeEQSWwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZYhlAFPXzyt29Nn0uA6EbJl91iPnswXWH1eh69mMbRmvGKc2K6vH89KxXtJvBMr7
	 5fUcs9yhhe/O4DGVXMScjhrhpLick0DMO1znx3XhM2C1GZVc7VuleBplBl8uekQANA
	 o6Hc+/NXRYd7cSnFsG69P7GjccoFL+VvXNOXWYUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/350] tipc: guard against string buffer overrun
Date: Wed,  6 Nov 2024 13:01:23 +0100
Message-ID: <20241106120324.749050220@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c7686ff00f5bc..5ceb7d489686f 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -158,8 +158,12 @@ static int bearer_name_validate(const char *name,
 
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



