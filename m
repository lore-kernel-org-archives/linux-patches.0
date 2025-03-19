Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7CB1DEFD6;
	Wed, 19 Mar 2025 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395264; cv=none; b=NMlOFlaaV9iYWAza4b+KDKFMtRWxIQXfJw7KLYZJtz1Qzi6q5Larqsn5BAc0Q85XHI2fevidtD0yVnktfbrLAeLXVdBfNPrMasz3dP4EANBJvUFEFBMQzGdMPd9NUwB7lb3cbCJVmq71qkC7qVGyHAbhWnGy5Tbg9Yr8kFMTgo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395264; c=relaxed/simple;
	bh=63h9uovDKjRqPpB6UmsZOw+YIOkOjmgFsjCaBIh+yd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6DmcmCslwbI7Hijz6cK0yHmkTb0RhLgntvEfPAv2bQ0DnXQONCjNRHEdrq5n8xrdYWKsocyLYWseC/g2uNEjVkMk/G0Sp9cXvydZOPOc9eOCPY9q30MkrRl5YZ301pF2LyZDlDHlcb39Ba/VMqAAlbvy3H1pGcbcj/CgtqOK+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTVlkoGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTVlkoGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DE8C4CEE4;
	Wed, 19 Mar 2025 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395264;
	bh=63h9uovDKjRqPpB6UmsZOw+YIOkOjmgFsjCaBIh+yd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTVlkoGFYH01q9LAIDyXsQJT5XA8N/4p4UrERaNJx/Gdf3lMIoGmdUGbNe+YGDldJ
	 YalPAtqykM1G5MJ4gFYvCg8VWsceABHFDmhsYJNPolnbFpUVBFmEb0HkpwxDgrSXqV
	 51AP+Xtvh2/KDopNCF3aakFpJwo4cHK44sNRhJxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/166] cifs: Fix integer overflow while processing closetimeo mount option
Date: Wed, 19 Mar 2025 07:32:01 -0700
Message-ID: <20250319143024.087334509@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 51604c78f9ea4..b90cc918de7a3 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1292,11 +1292,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



