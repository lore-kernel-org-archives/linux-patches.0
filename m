Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E74BA96;
	Mon,  8 Jan 2024 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kc6or96B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A710DC433B6;
	Mon,  8 Jan 2024 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726729;
	bh=PK9HPrxedxVK0DSErA4LenJMVxwKHl2qWdh4cGSBR0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kc6or96B1Vtagz0JVYPpIjFt2kj3eRWMSX/gC7kR4nHdQFEjLMsR/3IMeebo/OnCO
	 ab1UnQYaySalKTSyoGoiZB7QBokJ28RiGwRuoO1dUu/vbLErFahfj2tDGhBQ7+zqLj
	 61+xVeERRBnsM9g+nDbaqmke0HdQHDf1bREqcNPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/124] apparmor: Fix move_mount mediation by detecting if source is detached
Date: Mon,  8 Jan 2024 16:07:58 +0100
Message-ID: <20240108150605.354496819@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 8026e40608b4d552216d2a818ca7080a4264bb44 ]

Prevent move_mount from applying the attach_disconnected flag
to move_mount(). This prevents detached mounts from appearing
as / when applying mount mediation, which is not only incorrect
but could result in bad policy being generated.

Basic mount rules like
  allow mount,
  allow mount options=(move) -> /target/,

will allow detached mounts, allowing older policy to continue
to function. New policy gains the ability to specify `detached` as
a source option
  allow mount detached -> /target/,

In addition make sure support of move_mount is advertised as
a feature to userspace so that applications that generate policy
can respond to the addition.

Note: this fixes mediation of move_mount when a detached mount is used,
      it does not fix the broader regression of apparmor mediation of
      mounts under the new mount api.

Link: https://lore.kernel.org/all/68c166b8-5b4d-4612-8042-1dee3334385b@leemhuis.info/T/#mb35fdde37f999f08f0b02d58dc1bf4e6b65b8da2
Fixes: 157a3537d6bc ("apparmor: Fix regression in mount mediation")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 1 +
 security/apparmor/mount.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 261cef4c622fb..63ddefb6ddd1c 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -2364,6 +2364,7 @@ static struct aa_sfs_entry aa_sfs_entry_policy[] = {
 
 static struct aa_sfs_entry aa_sfs_entry_mount[] = {
 	AA_SFS_FILE_STRING("mask", "mount umount pivot_root"),
+	AA_SFS_FILE_STRING("move_mount", "detached"),
 	{ }
 };
 
diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index f2a114e540079..cb0fdbdb82d94 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -499,6 +499,10 @@ int aa_move_mount(const struct cred *subj_cred,
 	error = -ENOMEM;
 	if (!to_buffer || !from_buffer)
 		goto out;
+
+	if (!our_mnt(from_path->mnt))
+		/* moving a mount detached from the namespace */
+		from_path = NULL;
 	error = fn_for_each_confined(label, profile,
 			match_mnt(subj_cred, profile, to_path, to_buffer,
 				  from_path, from_buffer,
-- 
2.43.0



