Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E741DE4CD;
	Tue,  8 Oct 2024 13:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393217; cv=none; b=NazN0di+YGrgy/8rBV7XbqEkCHmw9BqjNGLjbim8uIHhrjN5XGpHte2N9PM89RI78bRa1Gk3TpsInCTku6DFu3HsDPTAf7vqI34LJWhIFqFy/gA4MORNc8pngX89J+SWFePc6rnrDN9RuxUpWRYd8G+Q5nEG0UOphVsSMtKyunc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393217; c=relaxed/simple;
	bh=0yCWKFFx+GfDzWNROGyZChvpWRQPL8iCdOlPI+mLstM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ3pE4pSVNTlgCnyIO7ZlK9IwpJ4k2u1RpGDe0qY7lld+tUbHFOKWm1hjrMshtGWwFsGo85t030/Hio1RgLuXZreZ1MVX7JCtSdqFO+b2R6gP48gAP+Mi60D3FeI5szLZ+Ee/RhU7CHKA1Fa5sNmDIMeRiNcEn7BNlziEVx4lYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j185uZEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j185uZEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D2FC4CECC;
	Tue,  8 Oct 2024 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393217;
	bh=0yCWKFFx+GfDzWNROGyZChvpWRQPL8iCdOlPI+mLstM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j185uZEiLjxZqv8l0cRrnSWsavI3mheN8bSF1zsuPRdlmqtasFjOHWr3QQO+6ektz
	 HvGqdybQ99spwEwwBroyx0DqJyQKIPO4Mwfl/8wnQItjEyr4fPLowimQU8OJQ6v9iq
	 BoE395vPEysl2TBrdFv+bIQlJ5cnpTFw5QbjDmBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/386] tipc: guard against string buffer overrun
Date: Tue,  8 Oct 2024 14:05:31 +0200
Message-ID: <20241008115632.839847961@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 878415c435276..fec638e494c9d 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -163,8 +163,12 @@ static int bearer_name_validate(const char *name,
 
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



