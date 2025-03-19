Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F17821D3DD;
	Wed, 19 Mar 2025 14:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395158; cv=none; b=ZPtb9CGgkEvTbaFEU9PxW0xp7eF7XiEmzXznfUcecj/s5NaK/31NY3Rlx0Tmm0/psUgQBqJOX1zTyKmvPquP5ddxqR63/IUoICm2DSYHpwQUFYDWB+RcUy6J42adhTh41Mux6UoG4QjjZ+9u2GVWQWpZWrhtItOWcW1LmreH0Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395158; c=relaxed/simple;
	bh=YxBHVHzkwl7hxQ3cuIudrZ9284Un5pJfE46YjtptD5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dfot9444KYgjWToJqPmP8yGEbVQilF33jLNGVEaIeU3ZzU9giEPgCTFXnEviub9EonpoVPsoRszX0K0QkeF7y2Jwb6HokCKwVUFOlLWLKGfdr9mLq9Kw/01CpG8uvj+Z4eTlpjGcvoi+50LdVkU7zbqI4zNr8ELqjecewkiOgKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsjPQX0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsjPQX0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6A4C4CEE4;
	Wed, 19 Mar 2025 14:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395158;
	bh=YxBHVHzkwl7hxQ3cuIudrZ9284Un5pJfE46YjtptD5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsjPQX0TD5f9tZ2fZfBQitFdks4+dAzvgmTzEe6ZsFYlMf36u7vtZ/mnzBF0Jn61M
	 5J2MnJsRnzb990hTN6P3vHOSjT3MAbZOnx8ktHVbTpptYuk4CiORU4Th1K5rafv1/f
	 OSTfXEHPd4ld5fD6OHJRyNgKNqWQ1t1lOGxaVZWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/231] cifs: Fix integer overflow while processing actimeo mount option
Date: Wed, 19 Mar 2025 07:31:50 -0700
Message-ID: <20250319143032.206852909@linuxfoundation.org>
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
index 1b54287593298..934c45ec81957 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1268,7 +1268,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



