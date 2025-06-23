Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892924C7F;
	Mon, 23 Jun 2025 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685165; cv=none; b=LZuOi1uzwBwfLurFMUUwi6Ti+LsKfugzC7GoG3oWj3HO5La/CWn0Xg84u6kVkvrTxA2+gBNYgcw12XP7OO8zHYGczn+Uvxx7TYfeWgDK72997n9pxjCBf7BX4K4TlRnWC4yGyp9Lh+A/5U6r7Su3Oig9pc5nDO2xwvwv/wzN0+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685165; c=relaxed/simple;
	bh=MhTXEYxYmEzryqgYC1c02RMk/eFGdL+c98gUUalMsww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR2OZI5lodkoVfpm8jaVT74dVCu6cd468nfltyrBX65AkaxS6omS5Au2NPw88Z6xv1En/J6G9rhV37IB8YQxrvH2hDOBcN4EF0y+vZRy0kvaRZzZ7+BlcLtoPhYvOhOMZG7dHc8BpBtIy2LhpEPm8HYskfShoj+YwU+yvkUkU/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoGpXH7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoGpXH7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C87AC4CEEA;
	Mon, 23 Jun 2025 13:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685165;
	bh=MhTXEYxYmEzryqgYC1c02RMk/eFGdL+c98gUUalMsww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoGpXH7k40vR+VIIba+mKf74PJXqTK5yGJRW7pDf8u/YVQCNl/fs9yZMbtVeGpygT
	 FqyqaWwkO8DDcUuccwNTj6IGKjOkfiG1H02eJcEtbObZJLLQmuFIXAgUh1rWqw+i00
	 /EoPdmxAwo9x3D4nFcwSjB+yNmnkvAOEjTZceFKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/222] do_change_type(): refuse to operate on unmounted/not ours mounts
Date: Mon, 23 Jun 2025 15:06:46 +0200
Message-ID: <20250623130614.238911212@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 12f147ddd6de7382dad54812e65f3f08d05809fc ]

Ensure that propagation settings can only be changed for mounts located
in the caller's mount namespace. This change aligns permission checking
with the rest of mount(2).

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: 07b20889e305 ("beginning of the shared-subtree proper")
Reported-by: "Orlando, Noah" <Noah.Orlando@deshaw.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index a5cb608778b1e..8a35144897686 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2246,6 +2246,10 @@ static int do_change_type(struct path *path, int ms_flags)
 		return -EINVAL;
 
 	namespace_lock();
+	if (!check_mnt(mnt)) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
 		if (err)
-- 
2.39.5



