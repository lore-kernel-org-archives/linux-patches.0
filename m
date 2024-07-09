Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A21C55E4C;
	Tue,  9 Jul 2024 11:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524798; cv=none; b=Jr+rlEfE8mIOHbuWu7uxY1dT/X4xL5AiJbiaeMymxrN6Ys6SStR/Z9KVcYeSrrgJwURGa4NBk/0ENf+nkyt5Rz4AKJ3YVOwgAU2UqjzvJ6n8BzjNzXVtWxa6GrZcA8I2LOx9GEoJ9bucqINjH8km1Nd0DQryHPp2mU7/45hssKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524798; c=relaxed/simple;
	bh=lFQi/oICmBDXKJ9A/Q18CWkmA5NT4ycN9wpjwfqh11k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwzkiY87qUszUU5hrT57dvTUCDVwOFKf2wdYKOyVR3DshCYHx/Qkjz8bbaEgi+JZb79tkl64v5CJt6dZQ6jN7NR6/bH9Pju0nGcDimmVCuqrHgO8CA2K46cH/39qanMNXhryz5Nxb0vVYzOdMglipj8owZ5VdoXZzfRUtgQWP8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGyeKHxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGyeKHxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBC4C3277B;
	Tue,  9 Jul 2024 11:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524797;
	bh=lFQi/oICmBDXKJ9A/Q18CWkmA5NT4ycN9wpjwfqh11k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGyeKHxepN+jRYlPxsPEetO/JwookgkDaIOh/U+xkALg6vpLhVGmXRKAmfuwsUgRk
	 2hMRPPhAPxxS7EqspftqGUvh7l5CScPsGBlEjqMJu5X0t1hoee7J9B2k9zrZ9jr4ZU
	 M8cE2n72NTl6ycO017GhVCMnp3eJ7qMoOgZoUI2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/102] fs/ntfs3: Mark volume as dirty if xattr is broken
Date: Tue,  9 Jul 2024 13:10:52 +0200
Message-ID: <20240709110654.835336069@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 24f6f5020b0b2c89c2cba5ec224547be95f753ee ]

Mark a volume as corrupted if the name length exceeds the space
occupied by ea.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index d98cf7b382bcc..2e4eea854bda5 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -217,8 +217,11 @@ static ssize_t ntfs_list_ea(struct ntfs_inode *ni, char *buffer,
 		if (!ea->name_len)
 			break;
 
-		if (ea->name_len > ea_size)
+		if (ea->name_len > ea_size) {
+			ntfs_set_state(ni->mi.sbi, NTFS_DIRTY_ERROR);
+			err = -EINVAL; /* corrupted fs */
 			break;
+		}
 
 		if (buffer) {
 			/* Check if we can use field ea->name */
-- 
2.43.0



