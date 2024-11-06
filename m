Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816431F4FD8;
	Wed,  6 Nov 2024 13:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898340; cv=none; b=iyjOHPB+UBeJ08BgKU6GGllpE6tTY89F65nbYiMYBZio9Ur23RzkGhQKKL1PWk0dRPUMUg3QsfFSQhP2Hvb5hysCB9pXKW+9aKUuhJOxWyDg1uItQ9cewsvmDMehyEJKcgvLmleY5E3eMV1GTPF/tNWz1vekXvTQ++GscVbN07E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898340; c=relaxed/simple;
	bh=bsEGQy0pPmSg1gf79rSWogxQ8Z7L0asaWIMI3I9xGus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWJv6QOliCHPTFQOem+buGmTf14CbuqQiYOT3bXWniblYp9O0DpPiH+feKwS+/URcO0o4UhwBSqeQkxiIVoOrVb+KwvJCpXV89Izq9qw/0QPD8dJ+PaSNXE2sq7r7EklhaCKHv/T4rEvszxsaIwL/xLeNoO7xql6DlK9nWRD+rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ool/an6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ool/an6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF672C4CED6;
	Wed,  6 Nov 2024 13:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898340;
	bh=bsEGQy0pPmSg1gf79rSWogxQ8Z7L0asaWIMI3I9xGus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ool/an6fQpbvn1rG0+qYV8E6FraKcv/6J4SnvnfyOBif+lsPYSU9NNiG9jpiDs69I
	 HFRlV1EIk7xDRXnYI8mxxyrjCInOsDpy7SCTJgyPCOvFPUV7pI9frLwYyNrbFEiGyp
	 uT5jJ2eOldO+tjhFq6kbeTFrNLnQwyku/Qmi+KRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/462] tipc: guard against string buffer overrun
Date: Wed,  6 Nov 2024 13:01:39 +0100
Message-ID: <20241106120336.606751405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a0bc919e4e473..dc5c6b1e97910 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -160,8 +160,12 @@ static int bearer_name_validate(const char *name,
 
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



