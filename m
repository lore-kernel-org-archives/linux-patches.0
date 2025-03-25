Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BD82571DC;
	Tue, 25 Mar 2025 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905737; cv=none; b=RWisUrXTfxaNvmWc7h/SYPKkjlLSA4LtzQ5yOWvZuLwJ9NfGe1G2F7SwN97CmcniW2ac3FuzqcqTgyNLt3YjuwE6DQgcB4WKGGGW6WlUi5/VZJMCDYuzn9Tx/sEFSb/Nc1Nh/8RlfYgIbtKpeTcbkVZ0VG4pS2EE+tbbw68rIJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905737; c=relaxed/simple;
	bh=sQWuxkNsw+oSd05lCOUL+WvDb8Wo7qtRy5gcnIZDjWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLjOYRiaSlufYOvhPCT17xCaaWzTax4onEukW3rsSVqHRUHKD9nug+SMZhyLzu2HeNzoDCx+pqCqc3B71GaZPiVPMpOtP3UFQIwkFpSfyj/YlU4vPzcdncZahfzDsq6rQHpYOR4nu2jPB3woUQVOBtIiLiQEcRDS1vSfRGx9VU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7KPnvvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7KPnvvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A116C4CEE4;
	Tue, 25 Mar 2025 12:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905737;
	bh=sQWuxkNsw+oSd05lCOUL+WvDb8Wo7qtRy5gcnIZDjWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7KPnvvWLG3WUgTjD7Mfk/MKYtpMpS1n13xOfZgBmKnyGKSHiWUT1qUnCNAMhcoj7
	 YlVlix+ADD5SR1MZUWnmrgq/9X9ptLHOAxmu6ewYf+SFbb6rSlBOb9Kv5+dGiqyipF
	 YPtsCUL5WZVuOyplTboeH9t6a942ApWsF5L5OJzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/198] cifs: Fix integer overflow while processing actimeo mount option
Date: Tue, 25 Mar 2025 08:21:37 -0400
Message-ID: <20250325122200.194933251@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 64f690ee22c99e16084e0e45181b2a1eed2fa149 ]

User-provided mount parameter actimeo of type u32 is intended to have
an upper limit, but before it is validated, the value is converted from
seconds to jiffies which can lead to an integer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6d20e8406f09 ("cifs: add attribute cache timeout (actimeo) tunable")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index d2b9aca2b2790..76842fbd2bb83 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1092,7 +1092,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->acdirmax = HZ * result.uint_32;
 		break;
 	case Opt_actimeo:
-		if (HZ * result.uint_32 > CIFS_MAX_ACTIMEO) {
+		if (result.uint_32 > CIFS_MAX_ACTIMEO / HZ) {
 			cifs_errorf(fc, "timeout too large\n");
 			goto cifs_parse_mount_err;
 		}
-- 
2.39.5



