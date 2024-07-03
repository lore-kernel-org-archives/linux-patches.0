Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12AB6E5ED;
	Wed,  3 Jul 2024 11:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006055; cv=none; b=o83XJsQ6GKfZ59Tn6rSjMZms0V2zR6NMiNBvQW0HO9d7D711wcRZx9x9SMeCY8K2D7Q/7bKQ00DUCwSz4sZDw6IEc4tEX9B5ljyRFkC9eMvxMxLIfF+cudW99XMctqB6gBfmn/y1vezVL5OncI3eui9nHavtDRFo026IZYcVRLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006055; c=relaxed/simple;
	bh=cEPMXoJFTpMTXXZa1FPcsO4fLOPeXTx2SCCK29FBI3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6xmqUzN/luJYwtJBDu2FuwwW5YcVHMlRhPizNvFen5a+p/GAyy1kz4RkuOPFYKYx7rlVZhJiH5ypK/2zi8cbg7WT0oBNXJY8dGT28xPFGlGn8swPs1aMbg0irFl64EhuLAa/fsDeUdmh+hWjAZKV19mEYTs7Gp2QARf2pSATH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yA5eTdV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yA5eTdV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6629AC2BD10;
	Wed,  3 Jul 2024 11:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006054;
	bh=cEPMXoJFTpMTXXZa1FPcsO4fLOPeXTx2SCCK29FBI3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yA5eTdV0oKYf74Hpvw0ObxgwiSruDEN/uKr6mOB7ShZBPEYkr8HU3Z60xmPBwOuFZ
	 kBl0im/9sbrxMV30orusMCZhnI79jzjXisWmgsBC63ivCProKi9DkKi9oYhhfYlomy
	 fbikC/8eTDmiXkt7wOsG/LvMCuZm/yuWrI9ph+Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandor Kracser <bonifaido@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 244/356] ksmbd: ignore trailing slashes in share paths
Date: Wed,  3 Jul 2024 12:39:40 +0200
Message-ID: <20240703102922.345195455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nandor Kracser <bonifaido@gmail.com>

[ Upstream commit 405ee4097c4bc3e70556520aed5ba52a511c2266 ]

Trailing slashes in share paths (like: /home/me/Share/) caused permission
issues with shares for clients on iOS and on Android TV for me,
but otherwise they work fine with plain old Samba.

Cc: stable@vger.kernel.org
Signed-off-by: Nandor Kracser <bonifaido@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/mgmt/share_config.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
index a2f0a2edceb8a..e0a6b758094fc 100644
--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
@@ -165,8 +165,12 @@ static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
 
 		share->path = kstrndup(ksmbd_share_config_path(resp), path_len,
 				      GFP_KERNEL);
-		if (share->path)
+		if (share->path) {
 			share->path_sz = strlen(share->path);
+			while (share->path_sz > 1 &&
+			       share->path[share->path_sz - 1] == '/')
+				share->path[--share->path_sz] = '\0';
+		}
 		share->create_mask = resp->create_mask;
 		share->directory_mask = resp->directory_mask;
 		share->force_create_mode = resp->force_create_mode;
-- 
2.43.0



