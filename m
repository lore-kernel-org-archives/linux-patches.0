Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E1D2054EF;
	Wed, 19 Mar 2025 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394986; cv=none; b=ZPJ9r9DgNvfXPNkNPsiQiJSgqU/oYqF1GmCZ0zOC5GxdQNTDsO1k5n2UkUTob9177ut9lzVLifsyZ8eoisJG2bzMRIuQT1d6wPYhEfVjYUuQjSY+7Vuduc493YvPCZ69IT2thERbIzu/saCo6XDpV7uKG6hoYhXPn4Vk6TAbffc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394986; c=relaxed/simple;
	bh=qaO/8g0pc2iwnBEWC+/rKo/USxWj1vRNlc5OZrPYtCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFXFM5pyfm3JYsXUv8yiu6IN3l+yJmxGv6TTra9jQlZZFMUcjU+YEy4fYmOgmXcZrhBneNuhAT1OUOOAmqxMHrqRm7nJEWBgMku4FoB/zRfEJVqNWMQTywpcrt2N4vAAfOSOBrp2XnzwTBtlVSbafeDm87VKQQ0Hezp4+QW3YRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9jjCQFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9jjCQFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531F0C4CEE4;
	Wed, 19 Mar 2025 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394986;
	bh=qaO/8g0pc2iwnBEWC+/rKo/USxWj1vRNlc5OZrPYtCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9jjCQFSZh/UZaVbtmSp/yuta0LPvqIe3b5n3mENN4x49YD9RmSp6Ws49D+WfgmaI
	 bP3bLyDZqjlQCsSTJ/KGtL0ThMdOqjO+eL3PBSK1fVTSAtR5A6wLze6NrHIKHD/EW9
	 UwOMhMSYo1uvXUIDf8UU7hFBaEz3wzJgFjonEp+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 226/241] cifs: Fix integer overflow while processing actimeo mount option
Date: Wed, 19 Mar 2025 07:31:36 -0700
Message-ID: <20250319143033.335920393@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 6d7091ddec16e..55bc036b243e4 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1298,7 +1298,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



