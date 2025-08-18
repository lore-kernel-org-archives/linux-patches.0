Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08084315781;
	Mon, 18 Aug 2025 14:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525991; cv=none; b=bkqjrgZ5AppO3ltW2N7w81bT7EGSOdBW0pB8O6pTYzGZIX1EFwxTYA2baDaSs7qTGsvADSlOY1UYTLuckGiTuK7wiD2Vn4JQmXkUgK5b/fUuTK1xCaKR47SQf3qatCSeqyxfkjoWkJJNyo0Yy4O9zWI5VUQS6HCEtHqUHcPXk10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525991; c=relaxed/simple;
	bh=zygzqwO6moJwEXFWUmPAfSsCgxrKWfTNkIY+6C2S4+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wy2lapAau2WRWORRVUAmLojywHwXlqULH/OwVYJVGUqQ/T3HnHKAV8YE8cXHhteshAYfDHZxiRnq/6YdPAU0aEQpENXDhgBDuG/yfhnNqztZwLdKXu6J6BhABsprDDk5h8HfVLOLtCqcJfWq19ILNz06eFQ6/gIDRfhVaZWoo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiNWi6dE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiNWi6dE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A999C4CEEB;
	Mon, 18 Aug 2025 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525990;
	bh=zygzqwO6moJwEXFWUmPAfSsCgxrKWfTNkIY+6C2S4+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiNWi6dEfyr4Vg8DKcwiswsWwyigQwimSBrbkQDB5HEQvro4yrhwnb3apJ+m+I0CY
	 wex9hYvbkbHumK//Jdd/1VZCGGaD7qS7bqmqh+cf/k6g+4UyvgEFQeSMeW/+gxgOEF
	 wdNJmwkNYibIWq1mZ+qXM64GRalWXAte3H2G1tsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Totev <gabriel.totev@zetier.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 427/570] apparmor: shift ouid when mediating hard links in userns
Date: Mon, 18 Aug 2025 14:46:54 +0200
Message-ID: <20250818124522.285483570@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Totev <gabriel.totev@zetier.com>

[ Upstream commit c5bf96d20fd787e4909b755de4705d52f3458836 ]

When using AppArmor profiles inside an unprivileged container,
the link operation observes an unshifted ouid.
(tested with LXD and Incus)

For example, root inside container and uid 1000000 outside, with
`owner /root/link l,` profile entry for ln:

/root$ touch chain && ln chain link
==> dmesg
apparmor="DENIED" operation="link" class="file"
namespace="root//lxd-feet_<var-snap-lxd-common-lxd>" profile="linkit"
name="/root/link" pid=1655 comm="ln" requested_mask="l" denied_mask="l"
fsuid=1000000 ouid=0 [<== should be 1000000] target="/root/chain"

Fix by mapping inode uid of old_dentry in aa_path_link() rather than
using it directly, similarly to how it's mapped in __file_path_perm()
later in the file.

Signed-off-by: Gabriel Totev <gabriel.totev@zetier.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index d52a5b14dad4..62bc46e03758 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -423,9 +423,11 @@ int aa_path_link(const struct cred *subj_cred,
 {
 	struct path link = { .mnt = new_dir->mnt, .dentry = new_dentry };
 	struct path target = { .mnt = new_dir->mnt, .dentry = old_dentry };
+	struct inode *inode = d_backing_inode(old_dentry);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(mnt_idmap(target.mnt), inode);
 	struct path_cond cond = {
-		d_backing_inode(old_dentry)->i_uid,
-		d_backing_inode(old_dentry)->i_mode
+		.uid = vfsuid_into_kuid(vfsuid),
+		.mode = inode->i_mode,
 	};
 	char *buffer = NULL, *buffer2 = NULL;
 	struct aa_profile *profile;
-- 
2.39.5



