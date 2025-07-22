Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D902EA15F;
	Tue, 22 Jul 2025 14:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193136; cv=none; b=ac5nuGjtSWQ9cRYxIlyBTzuwdEGHuaNEgXjuVPeapHpprE0YJ/v1xXXCiI1mF5Kz8Z+yuDAu9pMNIX5FwSQoRkp5PhGY9bupGcDsjQA12QNiYRSe1b7xD+F2yyvhBDeWCVYiowV+jfzRFvIelbodavmSMjcvQCIZ+wODcgZEFU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193136; c=relaxed/simple;
	bh=Kv7KhltUPFPwFuguzr7xuHKI6tYX2pwD+HsWqu436Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/XX75LaXpJaSDZZJG2LPqnlJASeS7aIuqsBj3WO/C8JENpnNIG/2bQKfBwMf7lpHz6ZlvZChjVDGxxofwgHtzOqHcw/SoFtGtfOZmbDAo+9Bnkf3r5GacKDDtGk0SO8pFt0eXS8AgqNJQpOGYDjI8+N3G1vIqqk9tPhH9ShGVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiHddXVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiHddXVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F079C4CEEB;
	Tue, 22 Jul 2025 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193135;
	bh=Kv7KhltUPFPwFuguzr7xuHKI6tYX2pwD+HsWqu436Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiHddXVLwhoiMvcrkmo5+xQ3ZNR+7AaH6vDk+f3G3rrD7ywoQXUqmhbgcTao37Mcj
	 b9nnIL0iUZpK+XSgG2kM0B/g03Ej85sRpMnukuvlLdo2RBnMc2xTACUTz55Vi9UP8b
	 v9u0nLM2vcaD9ulTFjWQ3L8Fc6Xk1crXM5x/mHEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/158] efivarfs: Fix memory leak of efivarfs_fs_info in fs_context error paths
Date: Tue, 22 Jul 2025 15:45:23 +0200
Message-ID: <20250722134345.913903674@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 64e135f1eaba0bbb0cdee859af3328c68d5b9789 ]

When processing mount options, efivarfs allocates efivarfs_fs_info (sfi)
early in fs_context initialization. However, sfi is associated with the
superblock and typically freed when the superblock is destroyed. If the
fs_context is released (final put) before fill_super is called—such as
on error paths or during reconfiguration—the sfi structure would leak,
as ownership never transfers to the superblock.

Implement the .free callback in efivarfs_context_ops to ensure any
allocated sfi is properly freed if the fs_context is torn down before
fill_super, preventing this memory leak.

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Fixes: 5329aa5101f73c ("efivarfs: Add uid/gid mount options")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/efivarfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index beba15673be8d..11ebddc57bc73 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -354,10 +354,16 @@ static int efivarfs_reconfigure(struct fs_context *fc)
 	return 0;
 }
 
+static void efivarfs_free(struct fs_context *fc)
+{
+	kfree(fc->s_fs_info);
+}
+
 static const struct fs_context_operations efivarfs_context_ops = {
 	.get_tree	= efivarfs_get_tree,
 	.parse_param	= efivarfs_parse_param,
 	.reconfigure	= efivarfs_reconfigure,
+	.free		= efivarfs_free,
 };
 
 static int efivarfs_init_fs_context(struct fs_context *fc)
-- 
2.39.5



