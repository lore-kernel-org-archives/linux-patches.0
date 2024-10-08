Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EAA1DDC24;
	Tue,  8 Oct 2024 12:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389810; cv=none; b=AmsPYgEfp2VgtGSMEo79grCOGT10Cy8I5RrXMCXmrrOAmbxQ8pdUFhDBlbFPpjgwGo3kx6lcj6gWPNP4LUlQ6YFmdXQqjERdBzVpamSuah1EvAKUEdedDSwEhw8yUcge5vWxuje9RDhz9gKMpeZZ1OPj5ciq1kjzXgypyw5e3h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389810; c=relaxed/simple;
	bh=KPXkXkAzYEEKkT0MXk2kbJ3GN9FJEDmexX4yPHqa8w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvKw7NoDBpn8Ir5CMhSkA8HUSkFlaq26yhabkvjkmdPA55mPN1JSXFjY4ZW7GFzLILJMlfl6OfdejjVK8X/PzGbBmfe4n2XwXzHi3s0KUA6GOuzTILIUSwQm2BaCmYaS0sA1kHetVxaFbPlz53afpAvjNs+uGuVSGMaLdn7miLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rccPwmgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rccPwmgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A625CC4CEC7;
	Tue,  8 Oct 2024 12:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389810;
	bh=KPXkXkAzYEEKkT0MXk2kbJ3GN9FJEDmexX4yPHqa8w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rccPwmgnCwxMcfL0hjDYj6shRvq0GTJ6qsVsGyyRs5At6uBTv8FtLt/rGwkl8e1RN
	 NwaCorG46aMDmyjUpHrTdG8DasaHh7pspkIS0ghWXyXxrDhfBSnJ7f4P9krSFPZF90
	 f7jEtg+VDNdncKyno2RN7EJBsh33Np0n9LaLgXDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 103/482] tipc: guard against string buffer overrun
Date: Tue,  8 Oct 2024 14:02:46 +0200
Message-ID: <20241008115652.363126240@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5a526ebafeb4b..3c9e25f6a1d22 100644
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



