Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE261DE3B5;
	Wed,  6 Nov 2024 12:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897456; cv=none; b=iue38RzfwN31R9QUaYYBV2aUX/s9OX7eq35bBcXi2kLqEwJiYwort788mBsOgf6gJP8g33lRiU4SB6M+ArKQXbvkmgiKkoH/BSnMGXBxMF95ff2ZsNzDWGYVM/9xeWQStnS8d279uafEGNd3E/pxu6/odtkx5fqPNyIiM+5FE5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897456; c=relaxed/simple;
	bh=uUBv0/zjg3otbPTmn51kllX9+pfzswrSTJyk2VK8fb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cd32H4lUhCEPU61oL4FxHqvyb9Enc5bDLtrvBhalsjBNpQtDro+QjqYvz1YfCEydN0aRGVQ3rMBL0AVVuxswtswKb7jNZbhqCXc1cYjblJ6aA88RNa62Zq9Y9bR6V9TyERfrTnM0XljHcgZZFDpfsgFUocA5J0LAzo0cyxAjTKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agaHr61e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agaHr61e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D81C4CECD;
	Wed,  6 Nov 2024 12:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897456;
	bh=uUBv0/zjg3otbPTmn51kllX9+pfzswrSTJyk2VK8fb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agaHr61eOx2NCkteq8RZL5WLSiUk1vCzbezrkEc3RU93f4km1g3WflTvQqLKL0WUr
	 w5lAJ3lbocVcPdQ8jg8H/zU1Z0CFSK9D637HHDvuijV6Lb0Qw40r3EhyF22LhbsbRn
	 7JI92ruYeoPqLwxhhwsjh6XOZT4EKOMHapyk00BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c6d94bedd910a8216d25@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/151] fs/ntfs3: Add rough attr alloc_size check
Date: Wed,  6 Nov 2024 13:04:07 +0100
Message-ID: <20241106120310.463823715@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit c4a8ba334262e9a5c158d618a4820e1b9c12495c ]

Reported-by: syzbot+c6d94bedd910a8216d25@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 2a375247b3c09..427c71be0f087 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -331,6 +331,9 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 
 		if (attr->nres.c_unit)
 			return NULL;
+
+		if (alloc_size > mi->sbi->volume.size)
+			return NULL;
 	}
 
 	return attr;
-- 
2.43.0



