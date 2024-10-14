Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482A21AB6FC;
	Mon, 14 Oct 2024 14:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917351; cv=none; b=miJn7ctACQWbDAvDRkrBWP2c1cAOLxUDSUUqeKsO0VntyuZB1JUrIK27FLhHesJsO94GX4eC6nWh0mZfz6RLFOHzAeZ7KUpMDwyom1H8Q+/uX/irpdJuKQM084r0bewkZlDOUrc4B2gExGPGn7/F+oLvvoLzNEspVoDUbCbJR6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917351; c=relaxed/simple;
	bh=KAWHkWlJrnc9PuTUOUnpmzcBtJv9mKyaXgLWzzkrJ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xh1TwF/NFOQl2Btu+3BSe+aaDSOKVcXHmP1ntqDmlgkjpXvdlM/RnPXhtw/NOjn9Ojor8H8JvBFURMpVP2KlI9dm/Nf8FFf3DVe9gXRGPWG+S/2jTdo52jSoVlmyb8LqWpbfP0K1rz+xztUznEqTv782D+87SQNQZTTnogp0ao0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCz6pyYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCz6pyYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDB8C4CEC3;
	Mon, 14 Oct 2024 14:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917351;
	bh=KAWHkWlJrnc9PuTUOUnpmzcBtJv9mKyaXgLWzzkrJ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCz6pyYtsx0ZM8tV2lRRVXNCm4f9RvZoi7cLF/3lPkdvcJUt3A2CRE9U/Ti5I6Q6M
	 e6e4sRHgqgQJKpT+9AshIZXbo7PWRHjOmmLJU6eOnmdgfYWlsta24s0o1jHggnCTgN
	 1gfAIrNsx4Ld4xXL68e38s/WsattFmiEOHeV5crs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Hering <olaf@aepfle.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/798] mount: handle OOM on mnt_warn_timestamp_expiry
Date: Mon, 14 Oct 2024 16:09:26 +0200
Message-ID: <20241014141218.432740051@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Olaf Hering <olaf@aepfle.de>

[ Upstream commit 4bcda1eaf184e308f07f9c61d3a535f9ce477ce8 ]

If no page could be allocated, an error pointer was used as format
string in pr_warn.

Rearrange the code to return early in case of OOM. Also add a check
for the return value of d_path.

Fixes: f8b92ba67c5d ("mount: Add mount warning for impending timestamp expiry")
Signed-off-by: Olaf Hering <olaf@aepfle.de>
Link: https://lore.kernel.org/r/20240730085856.32385-1-olaf@aepfle.de
[brauner: rewrite commit and commit message]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2b934ade9e70d..59a9f877738b2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2613,8 +2613,15 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 	if (!__mnt_is_readonly(mnt) &&
 	   (!(sb->s_iflags & SB_I_TS_EXPIRY_WARNED)) &&
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
-		char *buf = (char *)__get_free_page(GFP_KERNEL);
-		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
+		char *buf, *mntpath;
+
+		buf = (char *)__get_free_page(GFP_KERNEL);
+		if (buf)
+			mntpath = d_path(mountpoint, buf, PAGE_SIZE);
+		else
+			mntpath = ERR_PTR(-ENOMEM);
+		if (IS_ERR(mntpath))
+			mntpath = "(unknown)";
 
 		pr_warn("%s filesystem being %s at %s supports timestamps until %ptTd (0x%llx)\n",
 			sb->s_type->name,
@@ -2622,8 +2629,9 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 			mntpath, &sb->s_time_max,
 			(unsigned long long)sb->s_time_max);
 
-		free_page((unsigned long)buf);
 		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
+		if (buf)
+			free_page((unsigned long)buf);
 	}
 }
 
-- 
2.43.0



