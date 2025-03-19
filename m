Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8501F09BB;
	Wed, 19 Mar 2025 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395159; cv=none; b=iM9G6ExUvHLNiOQMWJya8cx0myJlwzZ1nDuDmLS/YOEjZjQmAhRh8gtlLKaDHH+65TNqu0goAxTw/rhQP9xhPzhzvIl0YbKJPnoU5Ipm/agg3rOO4hOv63x6RqoDwy0aPkRVAsQZTDrTYo0J4YKLmjXYQmWmWGEZ2RpdwDG1LtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395159; c=relaxed/simple;
	bh=DoCECirrSavCb72UxJ8ba3+9iCCSjHbS6YIFqdSJ/j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKLcHYKteOF9FpHjWBE04ad+JrmdsiryZU3YsEAQiDWfwLD4HwXztvyza/HlPAOMCs7Hac4QgeVhqOmVSTaD9dEbY5lpru0poNgV4/rVb47ni5AuXaBE+6MX1bUw7PrgzSC7NwCZILW3SqxCDBHxhXsWd66FfOaVdUiyn2KTasc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jx6Pl50i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jx6Pl50i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2CEC4CEE4;
	Wed, 19 Mar 2025 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395159;
	bh=DoCECirrSavCb72UxJ8ba3+9iCCSjHbS6YIFqdSJ/j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jx6Pl50iKTucWRyxoCpKBbbNCERRwmDdse8FdNRBVn7iyZ8GKGalPWNk64DvA225b
	 N7Ux5ytwPWBNXT5KeZLmB44yyLY1KA82j7Kpg5N+K6lqJcek4851gs6xutbZ2u6vxa
	 g961Z8zwrnAU18/DYzhEAjE/2f3Yth2uuuszgjGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/231] cifs: Fix integer overflow while processing closetimeo mount option
Date: Wed, 19 Mar 2025 07:31:51 -0700
Message-ID: <20250319143032.230379551@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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
index 934c45ec81957..f8bc1da300378 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1280,11 +1280,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



