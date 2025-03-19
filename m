Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E89E22257D;
	Wed, 19 Mar 2025 14:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395263; cv=none; b=i8/2Yf6dV+u+aKae1ZG6yoX0GpOAGZs5kKPVQVaDtA24YOt1P2XOlTcAAl4cgyBOkWSfCOx0TYuruxPJtZBVbY1+5YGKgMHEj4YG6C00vKXHPbmtFl6ms9oQkUKdXT9JgTXaPal8K+H9m3Hph1mOz9bt42eMDy7sXPKZzhdu9dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395263; c=relaxed/simple;
	bh=73nGemykkPt2eSNb1aiDrlueOVujt6XfYjDL0oMY2kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Td8QP5rOf4HX2gMszGcFU3+VFHTIUAjK27gH2QeSktnjNddD6N5CfeRG5Ypcaw4/w/R3ICPg0TCEZkdO065kkfQVXyks8hmSVFr97wthv1BoCJD2aYqPT1gyIK5p5BzZlc/1oiFajzWsH3gS6lRM1d3xcOdOnivBM9mte5EOLSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVcfAzwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVcfAzwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72E8C4CEE8;
	Wed, 19 Mar 2025 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395263;
	bh=73nGemykkPt2eSNb1aiDrlueOVujt6XfYjDL0oMY2kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVcfAzwj8QzsG86NyuBbqmtYJWH9/O6w071lcXzHCAnU6c0RlBRO2YLV5JBprUh3a
	 SWA0idweiJJEWK/D11SkeL6UqVksggfVUML8oxUlS83pRLokxnvltgmgAy0Fah8wst
	 hUtH3ubQBJ6W5JA8y9IXFPwI60P1lrWP3AS677RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/166] cifs: Fix integer overflow while processing acdirmax mount option
Date: Wed, 19 Mar 2025 07:31:59 -0700
Message-ID: <20250319143024.035343079@linuxfoundation.org>
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

[ Upstream commit 5b29891f91dfb8758baf1e2217bef4b16b2b165b ]

User-provided mount parameter acdirmax of type u32 is intended to have
an upper limit, but before it is validated, the value is converted from
seconds to jiffies which can lead to an integer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4c9f948142a5 ("cifs: Add new mount parameter "acdirmax" to allow caching directory metadata")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 82a0987f4f868..479801187c762 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1273,11 +1273,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->acregmax = HZ * result.uint_32;
 		break;
 	case Opt_acdirmax:
-		ctx->acdirmax = HZ * result.uint_32;
-		if (ctx->acdirmax > CIFS_MAX_ACTIMEO) {
+		if (result.uint_32 > CIFS_MAX_ACTIMEO / HZ) {
 			cifs_errorf(fc, "acdirmax too large\n");
 			goto cifs_parse_mount_err;
 		}
+		ctx->acdirmax = HZ * result.uint_32;
 		break;
 	case Opt_actimeo:
 		if (HZ * result.uint_32 > CIFS_MAX_ACTIMEO) {
-- 
2.39.5



