Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB56920AF78;
	Wed, 19 Mar 2025 14:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395263; cv=none; b=TnsWdbxHeVPhcVjgs1dfSkzbmQacCgMTUZ4j1llqoQl5YP2Yg3Ibd9rMfRHSqn1xbaQas/KaSEC1WrlJkOcHWNqt34p6MlABC199gLbr/C9EIiaSFX1S0uBTqX0OCcVQ7T6bVqDDZttBESzL/8zNjGFLkVyVBOXKkWLYgIQ887k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395263; c=relaxed/simple;
	bh=/lXTDRFXhJ91ucjEUllagGwevV+cyQlTxJnOVIS3HYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slo9He+vKaBL33+lxNzoO26CsC6t13BWoglV1zIBqQhs/WEWZs7IfxnpzEKr1yhrkSZV3QLG1Rrqhnm9Km5W9XqqxD/BMiNuhKGMHlmJ3S8JCrIkVGKj3qoNJ6suGPgo1nErx33x4q7GSI62j8SolNV6QGNDR3/TXqzkWIDAfsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VF3VRTzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VF3VRTzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E393C4CEE4;
	Wed, 19 Mar 2025 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395263;
	bh=/lXTDRFXhJ91ucjEUllagGwevV+cyQlTxJnOVIS3HYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VF3VRTzliainvTLeBxl+kzjGNGkVqO7z843kss3SOqUQYTkw/6747N6C4Gy31rXE+
	 hcco6J5n6lq8TEFZC2omAj+FqTRBYsLGSl776IrgzGYosVHJZfN6XhUNJ6DvWHwaz0
	 pnM614sX4ReLOqgdciCeH4Mf6wE+J2U/3KR6ytMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/166] cifs: Fix integer overflow while processing actimeo mount option
Date: Wed, 19 Mar 2025 07:32:00 -0700
Message-ID: <20250319143024.061848256@linuxfoundation.org>
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
index 479801187c762..51604c78f9ea4 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1280,7 +1280,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



