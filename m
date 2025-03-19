Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE55F20B1F9;
	Wed, 19 Mar 2025 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395262; cv=none; b=aypqO1ZHxa7mffGxcOqKYomi6KREdl4ogPCkWWR7prVzg1DDjeoZ54yHgniK47hKHdlRrP1DEip8aHK9dLkT28UP+N0RzR3yCSjkxBapB5qo9+dROFEMnlt3pOqz3Xx0//BxkbXYa8alYaEodMBHMginc5UsN7ewhJl0avdWL6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395262; c=relaxed/simple;
	bh=J0AH9sojMX8WHIJ3wRIdj10+KlY2Do9eArL4YxsvRRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TicI2GrEmplJxfp0e2ZSvUnyJ9aVo3LxvLG7pNMiVdumtSyKnxkGlIJUqJ3R6A8aoJlBo/HgrsTMV5tGlJBDgZwkZaz/HB5RLI3jX53hZb65faUB/w8g2luE+cqJyNMWJmHT1cvG32tNqskvEVoa4RnWr8Noin0giQldEOYP7KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgX3irLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgX3irLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4796FC4CEE4;
	Wed, 19 Mar 2025 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395262;
	bh=J0AH9sojMX8WHIJ3wRIdj10+KlY2Do9eArL4YxsvRRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgX3irLpUQ1oPmmIfQC5o1PrcbbcNuj03vwq67B81o7y955KG/GT8IBbn+9APHbDx
	 piPYm654Bc6+AjNA8gQZA1GzkVHRQj8aNJCze3xnAtVhIr515is3ARwaGYnxPh+z0q
	 IRLViqO9Y24OWjtyIG0rWcy5kRHmFQs2fa9k1KC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/166] cifs: Fix integer overflow while processing acregmax mount option
Date: Wed, 19 Mar 2025 07:31:58 -0700
Message-ID: <20250319143024.007730182@linuxfoundation.org>
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

[ Upstream commit 7489161b1852390b4413d57f2457cd40b34da6cc ]

User-provided mount parameter acregmax of type u32 is intended to have
an upper limit, but before it is validated, the value is converted from
seconds to jiffies which can lead to an integer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5780464614f6 ("cifs: Add new parameter "acregmax" for distinct file and directory metadata timeout")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 249dd3f4904e3..82a0987f4f868 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1266,11 +1266,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		break;
 	case Opt_acregmax:
-		ctx->acregmax = HZ * result.uint_32;
-		if (ctx->acregmax > CIFS_MAX_ACTIMEO) {
+		if (result.uint_32 > CIFS_MAX_ACTIMEO / HZ) {
 			cifs_errorf(fc, "acregmax too large\n");
 			goto cifs_parse_mount_err;
 		}
+		ctx->acregmax = HZ * result.uint_32;
 		break;
 	case Opt_acdirmax:
 		ctx->acdirmax = HZ * result.uint_32;
-- 
2.39.5



