Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5571827AC21;
	Mon, 13 Oct 2025 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368782; cv=none; b=CYUD6Ja3z/ifVTIgeqgpK5XS6kICH5wJ6ISVgC9Xt9u9EDLOdKcYGEKiQo3Jfwrv3PlT7SeVLxUHOp89rtaMxI8O8aAXI88kU18bi9l103W59mfY67qNdYtrJi6UxhhlY5dAJprMbwD9jWzn1KwpyJa7qWiM52R8Jo/oKuF0Il8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368782; c=relaxed/simple;
	bh=+sokjWHrUFW/G1IvLS4BmnZOY5IFip6bDrwuVIv9eu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKAODEbjVZBwhhhutkPNTNsAoPKOjE2cB235To+xfkbtYdKDotYjvTAs178nnbnMe0Syxt+6wKTg/+dHa98iK1uk5ymsgvQ4CRVsL9gU6mUZc/NFL0D4dWofWKpQE/L8xOOrWiSIkWNy2wkX3NS9LJM649MT3bkA/QrjNMG24Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKOyu6WV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKOyu6WV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD163C4CEE7;
	Mon, 13 Oct 2025 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368782;
	bh=+sokjWHrUFW/G1IvLS4BmnZOY5IFip6bDrwuVIv9eu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKOyu6WVOcquG0iHcS23VAKm/kPAaBT3+kZvnOhtXK90A83cZQEZ9ujGGYITeXFjw
	 lulRrfNTLCHWWOtr6AqemeXJWQjcvdr/4X/URhkeNaBMv83DuW+PKx6LcUfRyZOyM0
	 GGKBKeE6jDN/YkPVyEblQOWgPuUWmX2iyf8AjSQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Serge Hallyn <serge@hallyn.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 004/563] pid: use ns_capable_noaudit() when determining net sysctl permissions
Date: Mon, 13 Oct 2025 16:37:45 +0200
Message-ID: <20251013144411.446175051@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit b9cb7e59ac4ae68940347ebfc41e0436d32d3c6e ]

The capability check should not be audited since it is only being used
to determine the inode permissions. A failed check does not indicate a
violation of security policy but, when an LSM is enabled, a denial audit
message was being generated.

The denial audit message can either lead to the capability being
unnecessarily allowed in a security policy, or being silenced potentially
masking a legitimate capability check at a later point in time.

Similar to commit d6169b0206db ("net: Use ns_capable_noaudit() when
determining net sysctl permissions")

Fixes: 7863dcc72d0f ("pid: allow pid_max to be set per pid namespace")
CC: Christian Brauner <brauner@kernel.org>
CC: linux-security-module@vger.kernel.org
CC: selinux@vger.kernel.org
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/pid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index c45a28c16cd25..d94ce02505012 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -680,7 +680,7 @@ static int pid_table_root_permissions(struct ctl_table_header *head,
 		container_of(head->set, struct pid_namespace, set);
 	int mode = table->mode;
 
-	if (ns_capable(pidns->user_ns, CAP_SYS_ADMIN) ||
+	if (ns_capable_noaudit(pidns->user_ns, CAP_SYS_ADMIN) ||
 	    uid_eq(current_euid(), make_kuid(pidns->user_ns, 0)))
 		mode = (mode & S_IRWXU) >> 6;
 	else if (in_egroup_p(make_kgid(pidns->user_ns, 0)))
-- 
2.51.0



