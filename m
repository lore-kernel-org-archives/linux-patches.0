Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED431CAA60;
	Wed, 19 Mar 2025 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394987; cv=none; b=nLVW+Tm0rnorhr31ujPEovqmkEJn2/256UNHr6cKraAzf2bY53SuaS32EXq2ABb4ZE2vdxJqdXGRr6ONpcE5d9vDLCXarmSsmJP+26boCaJkTY+ZcyQeDFm3ci77TjNslgMZmJGpkHMeiDMCPxSttnHqukC+3Qd7nOmqyYF3UXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394987; c=relaxed/simple;
	bh=P2zgmam0jaUCd+hAdhpYtXjtaF3pP2fXaFASFxTBZ/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1Zc/0USzWlzxcMOvS1oy+NHyTgip0f6b/DMB87AahwHucTBMgCs8duyKNY02iJGJeVKBVCagbImgpcOol9nEZZ+6sh6AHAjJmYm5iVvZ906AcnjVU3J/bPOgnQjbhH9vRakac9xu3ObEPmuOxSnPOs0ZEPADhDzrG6F4va2vwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtkilE5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtkilE5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AB3C4CEE9;
	Wed, 19 Mar 2025 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394987;
	bh=P2zgmam0jaUCd+hAdhpYtXjtaF3pP2fXaFASFxTBZ/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtkilE5c9TjCciGv26x2J7KDJBTYXOEz3y10O4pnkumlVYSgi79DT3+Ws88oP+auI
	 Mk84xczGMF2pldcKBaQDn/YEyEGuR136qP15dJNmTTI9aPmEqVZSjY08Pv3NtjHNDp
	 QmRhmgJQ706P56WAP1KXqNN/xKTtvutI0IJasCx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 227/241] cifs: Fix integer overflow while processing closetimeo mount option
Date: Wed, 19 Mar 2025 07:31:37 -0700
Message-ID: <20250319143033.358946249@linuxfoundation.org>
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

[ Upstream commit d5a30fddfe2f2e540f6c43b59cf701809995faef ]

User-provided mount parameter closetimeo of type u32 is intended to have
an upper limit, but before it is validated, the value is converted from
seconds to jiffies which can lead to an integer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5efdd9122eff ("smb3: allow deferred close timeout to be configurable")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 55bc036b243e4..c85285bf730e9 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1310,11 +1310,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->acdirmax = ctx->acregmax = HZ * result.uint_32;
 		break;
 	case Opt_closetimeo:
-		ctx->closetimeo = HZ * result.uint_32;
-		if (ctx->closetimeo > SMB3_MAX_DCLOSETIMEO) {
+		if (result.uint_32 > SMB3_MAX_DCLOSETIMEO / HZ) {
 			cifs_errorf(fc, "closetimeo too large\n");
 			goto cifs_parse_mount_err;
 		}
+		ctx->closetimeo = HZ * result.uint_32;
 		break;
 	case Opt_echo_interval:
 		ctx->echo_interval = result.uint_32;
-- 
2.39.5



