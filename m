Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E291A1D048B;
	Wed,  2 Oct 2024 13:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875215; cv=none; b=a41vPMHTIeJ+xw8Id2P9klxiN1+LsQMuFR9Kxy5EJnhcJo8W+YU+1u2QnMfGzgVJxdC19XDmSFDScS8FBlaFDIUGhoYjJ/ww6/1T7/ykhyoc1dDbCxaUxGVmjM4r/1Ejh0N7VywDxcbbRqJUzezYA0+mKX+hjGbV/Dl+QuWp4Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875215; c=relaxed/simple;
	bh=upw4Rtc1CJW2wmksu6iWnfuxJRxxjKEjUeVfP/NhcuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGivbQh0jAMLLZJC7/dtyIKEW4z1Az2XUcXPdbPMUMjtfk6GR2yommBvVWDeoJ4mXrtj7TQzalYoxLi5Sau1OpbNsHyL3hnojSDqj2AXenCyBn/ahZqD+0NjJoM7/XTPR0HmbfnCLIc3o1MOyvkXodMDb/q3zG3SFvZEHHh83g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlPBJj5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlPBJj5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C5EC4CEC5;
	Wed,  2 Oct 2024 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875214;
	bh=upw4Rtc1CJW2wmksu6iWnfuxJRxxjKEjUeVfP/NhcuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlPBJj5Mo3CUEXa8IJ4rZUSC9gqoc/Xa2/S060j37EUWCs5QsJj+bZeF5iZMRrK+6
	 g4LxbZ/zvOyJCrWBcO/nulu7flauUGmWPD/a88+CsA+ekSAsYYWBl1TV3CVsQcX1bq
	 Z4tzQLVu+Q52ELj8YFfjMbOIUHjwFLRJQlVhp2Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Hering <olaf@aepfle.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 030/695] mount: handle OOM on mnt_warn_timestamp_expiry
Date: Wed,  2 Oct 2024 14:50:28 +0200
Message-ID: <20241002125823.695561529@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 328087a4df8a6..155c6abda71da 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2921,8 +2921,15 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
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
@@ -2930,8 +2937,9 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
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



