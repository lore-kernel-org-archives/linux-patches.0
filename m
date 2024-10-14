Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5AD1AB6FC;
	Mon, 14 Oct 2024 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917347; cv=none; b=E83Ty715Ah7qhUSfiXalRhhyFv5EiObw7Ivu7MpG9f9y/XXqXXDxfNItWu0NqbWliazZMEkk5VX71mSeFFlMWxlYPsXAvI+EstrK5p7JiNm5sHdnJbLjh3RGuyOFpkBbfOzgUc4Q5l8DzEERBGBH+h8x9UDiD0O8w/dowXy8Bak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917347; c=relaxed/simple;
	bh=boIRmUTcy2zStXUta1tK7hyJT88W2e6rykJDAL8ol2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYNJm2hPmm3Kr+vlUxydV9eUAlqo19XQJuzso1uNYC0y+22XkOdzGNav/lEoK5OG7eSZZonOlOqqlYwSrRdPx08vhUAMTx3MpJ1VyXvy4SU3e/VLPyC7V5qbqczU/99Nv0YDr2oZ0AThusjFd7qEPq9Ixfi9+r0Xphl8GGUS550=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qjHdxEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qjHdxEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A9FC4CEC3;
	Mon, 14 Oct 2024 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917347;
	bh=boIRmUTcy2zStXUta1tK7hyJT88W2e6rykJDAL8ol2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qjHdxExFw04oZjqmM1V+sn0tTZNyAMlhcnn1J+MPYjzbpdqwyn80RwIcUukQCa2P
	 QMldjimDwbjnlV5D3VUscUhDy5dGTgGltw30PPScfTj2ZlZxP8rp3kMqWmydFnwNCb
	 E9mwD/ahGOmsTChHWjXhipmjdWoAoFnMvOWWVh18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/798] fs/namespace: fnic: Switch to use %ptTd
Date: Mon, 14 Oct 2024 16:09:25 +0200
Message-ID: <20241014141218.393980147@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 74e60b8b2f0fe3702710e648a31725ee8224dbdf ]

Use %ptTd instead of open-coded variant to print contents
of time64_t type in human readable form.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Stable-dep-of: 4bcda1eaf184 ("mount: handle OOM on mnt_warn_timestamp_expiry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1533550f73567..2b934ade9e70d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2615,15 +2615,12 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
-		struct tm tm;
 
-		time64_to_tm(sb->s_time_max, 0, &tm);
-
-		pr_warn("%s filesystem being %s at %s supports timestamps until %04ld (0x%llx)\n",
+		pr_warn("%s filesystem being %s at %s supports timestamps until %ptTd (0x%llx)\n",
 			sb->s_type->name,
 			is_mounted(mnt) ? "remounted" : "mounted",
-			mntpath,
-			tm.tm_year+1900, (unsigned long long)sb->s_time_max);
+			mntpath, &sb->s_time_max,
+			(unsigned long long)sb->s_time_max);
 
 		free_page((unsigned long)buf);
 		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
-- 
2.43.0



