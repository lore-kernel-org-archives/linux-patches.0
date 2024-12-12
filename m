Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A53226532;
	Thu, 12 Dec 2024 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019933; cv=none; b=Vr4e5Hd+PkLGT0qNJshUxH93b4Eo+rGcHHlhnpgqmMjZ83rtcP0e5gL0+3fUDhXPY6D2TM2OgXPKNEbXNJLxZjzIj/hPhvAzlhP4eVP8ZjtvgaV9PhF/krsHGgMNJibHdwr8oKvilcq505QQ6hWUZGXi2rX8mI/LmarT8dujJPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019933; c=relaxed/simple;
	bh=htyk7VkXzhAlBjaCuv7wmagsDNsQF4NZxROE3+rDZbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXvB3rtfz4EdN1lDwJI9gMlIkjrJi1l/7h01Nmep1lFvtjUJDd/i7V8DJXQL/fJCXiNdZJ6AQdNqt/cFa3qPlRrO0lUjLDCV7CzdsFoFA/cscmbd19muSQ2kv0BpGcjng35b4TtwoQ/vMz6oGw/6ZW4dXcG1wke4FlP+aFEkTm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXrzVL4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXrzVL4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C94C4CED0;
	Thu, 12 Dec 2024 16:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019933;
	bh=htyk7VkXzhAlBjaCuv7wmagsDNsQF4NZxROE3+rDZbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXrzVL4+kqLSBk9ny1K0EgGtiZ5QTzPoodG/vF3uzKPv0xNFd0/dQJTDX2La6tDME
	 h45SUft2RvHaTOPiNhrwwynCrvu9UYzU7e+KVkIY/DR9Er5j61NgIz/x5Gibh9GI38
	 u5Rx7InfBckuHXX3p8pOBnW01dKAP/mHYkhZ0lok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chao liu <liuzgyid@outlook.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 335/772] apparmor: fix Do simple duplicate message elimination
Date: Thu, 12 Dec 2024 15:54:40 +0100
Message-ID: <20241212144403.751401683@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: chao liu <liuzgyid@outlook.com>

[ Upstream commit 9b897132424fe76bf6c61f22f9cf12af7f1d1e6a ]

Multiple profiles shared 'ent->caps', so some logs missed.

Fixes: 0ed3b28ab8bf ("AppArmor: mediation of non file objects")
Signed-off-by: chao liu <liuzgyid@outlook.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/capability.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/capability.c b/security/apparmor/capability.c
index deccea8654ad8..1b13fd89d5a9f 100644
--- a/security/apparmor/capability.c
+++ b/security/apparmor/capability.c
@@ -94,6 +94,8 @@ static int audit_caps(struct common_audit_data *sa, struct aa_profile *profile,
 		return error;
 	} else {
 		aa_put_profile(ent->profile);
+		if (profile != ent->profile)
+			cap_clear(ent->caps);
 		ent->profile = aa_get_profile(profile);
 		cap_raise(ent->caps, cap);
 	}
-- 
2.43.0



