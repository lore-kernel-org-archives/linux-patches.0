Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160151DE8AE;
	Sun,  7 Jun 2026 10:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826864; cv=none; b=nDW4Y1HuMJHG98hj56yFg7ygp6gwrg7sgvByp14al9wtOpdZdFiwU/dfEPkzC4yDmGNJ89Tt9tjZcWuoBKN6+y+KqRSCXPyGHxbI30EvS33YbjdJmzk6aD8d1ZqMQUvsGs8TfszIGKN0wyU4ISzJUyE+XRYJ7tmSsvGum38rBq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826864; c=relaxed/simple;
	bh=GjYXSkvmA530Y3oRjNhbM9moi/Co+rRlLe6GOFWBTJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJW1TQfnPCJ9akKRpBwuBkeC6pWoi8kx6Q+AsDfI7KiZgtNS5oFPfzsm3M9GC0czBB/ZI4wU5Zg6VGnaGk/PirM8PZhIsrPZImhvWKiipgetCzokTBDEXhGy2d1cOjUIfV22tSLYuENgmL0PydBxKV3dRv9v97lf0Fn5VY/BkIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/RnS9Ag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/RnS9Ag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFBE1F00893;
	Sun,  7 Jun 2026 10:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826863;
	bh=X8JU7I5Kf+f9+SqTNF5VCig/gJ0Ca9vBa0uNAzMCMW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/RnS9AgRBNBMJyqrRwqNwzfvEWW0XNjV9PtZATzPUN+reHv9PAB1cGJq2x4v2M0i
	 0ghJ46hfHQYXZlUjDOkok3wByH/hEbOWpEPdAHAZJ+7fzeYQt5aWUGwUnYYHSAW+ZZ
	 41oWyAJWcls5XrJoCD/PfixzHOLk8hdF93t8qw9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 037/332] accel/ivpu: prevent uninitialized data bug in debugfs
Date: Sun,  7 Jun 2026 11:56:46 +0200
Message-ID: <20260607095729.469763305@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 44e151be23deb788d9f6124de93823faf6e04e99 ]

The simple_write_to_buffer() will only initialize data starting from
the *pos offset so if it's non-zero then the first part of the buffer
uninitialized.  Really, if *pos is non-zero then this code won't work
so just check for that at the start of the function.

Fixes: 320323d2e545 ("accel/ivpu: Add debugfs interface for setting HWS priority bands")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/ahP24m6Mii9EDL7Q@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_debugfs.c b/drivers/accel/ivpu/ivpu_debugfs.c
index a09f54fc430206..e93883914bc274 100644
--- a/drivers/accel/ivpu/ivpu_debugfs.c
+++ b/drivers/accel/ivpu/ivpu_debugfs.c
@@ -440,7 +440,7 @@ priority_bands_fops_write(struct file *file, const char __user *user_buf, size_t
 	u32 band;
 	int ret;
 
-	if (size >= sizeof(buf))
+	if (*pos != 0 || size >= sizeof(buf))
 		return -EINVAL;
 
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, pos, user_buf, size);
-- 
2.53.0



