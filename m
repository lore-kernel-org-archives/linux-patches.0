Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B4025FA13;
	Tue,  8 Apr 2025 11:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112447; cv=none; b=O3wwYyZ0YxqxQdajFoWK/WhgxrusjX6TvfE8EralqjTHgHOUTTDXMbouWGF+EaAPYl+jd1IbZATfsyxMrInal+VvOxYY2UwTVyVk5X3VG7N0OoH32kwMTFkhTlnTydNGpbTAHpgp5ILx7qLajk2LDkcap5cZgOagDBAGP4EPhkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112447; c=relaxed/simple;
	bh=Ht+dT6khLKm7gtd3b46P4JwLg97Jw37Ms+C06tQM5to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJmdqgLOgwIxWxG8IPGid4IgVSKLjq0iJ4X4xho6A7/vD70ImVX3sZk8Br5vblSUqbkSGkC59ea/yaVX931k432/kTwljQCoBtsQvPw639inw5smqPXsFXkqy/xJ+ycIkp83OyKYKgCN52fVovb0cjSQ3vY7e+Sx7GNu0YyrVMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeWrhmTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeWrhmTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA545C4CEEE;
	Tue,  8 Apr 2025 11:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112447;
	bh=Ht+dT6khLKm7gtd3b46P4JwLg97Jw37Ms+C06tQM5to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeWrhmTJccQdSFSg+dHWsx6yaz6VjQ9cb7o2yyYu79ERfkJ7/N53dLDjplmtnk9Dg
	 N2gg/2nXUMmzlqijcQPFkpMtO+q+/QNI4nrM21SJ8XZiE24wE3lBqISf5GsBKqDa/O
	 U4I+c+ceYKD9G+kvxJ9rqIWmtZjSrMuz6D4SDRBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/279] cifs: Fix integer overflow while processing closetimeo mount option
Date: Tue,  8 Apr 2025 12:47:34 +0200
Message-ID: <20250408104828.257529636@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index f45a29a51700b..24c42043a2271 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1081,11 +1081,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



