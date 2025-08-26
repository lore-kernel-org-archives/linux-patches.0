Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46012264A3;
	Tue, 26 Aug 2025 11:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207351; cv=none; b=CoG9S4jWz3Tsz2mt3gXiO0TZQJOXJP+wEIA1dZlXG8dw4oJ/enBm5kl46+0/fDnYOlyWMYfShvO4t3fYqtzRAJlFB5gLw+ZxIoNYJ6IKdHGhhYv9cZXeN+nptS+dnClrZBqdd4RUq3lpeHQSad/MQIgCRL6NuBnRA5yOeNl0h0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207351; c=relaxed/simple;
	bh=1dI8eJoX9bMq3N2uBWHEJu1Ic4Uiuo4Rt7nGfoU4SeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJhdYaCX9u6CGX4iWcQIZi6O6x4+OyB1jIC61PP5496EpB4H7gA5qJxOal0mB4Cm/J2S61q74LSKX/RJTHDT7ljK8EMCPXDQZPv3LKSSk93PdDHZryyVyz0PcW1at9sTX3+BgyL4tMVwnBlZy/Wgd2n9QKw50bP8mXBVIaM4tLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXWG+2Ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXWG+2Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392BEC4CEF1;
	Tue, 26 Aug 2025 11:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207351;
	bh=1dI8eJoX9bMq3N2uBWHEJu1Ic4Uiuo4Rt7nGfoU4SeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXWG+2Ur83Kcjle3OC95GEPSbm8TAH84Oda8l/6Z4EeL4SVoPmhERIcemn6W+/CWE
	 X+2ZO7DhLUqy70oag2/c+7Z1MfA80aWVuTNV9rUFAqUiurj5m8ngG8WoiV8oZzPAUF
	 7A+rXsDaZxl9ZyqBEtZgOCi5sV9VibJ0uL+tLGr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.16 118/457] open_tree_attr: do not allow id-mapping changes without OPEN_TREE_CLONE
Date: Tue, 26 Aug 2025 13:06:42 +0200
Message-ID: <20250826110940.290389338@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Aleksa Sarai <cyphar@cyphar.com>

commit 9308366f062129d52e0ee3f7a019f7dd41db33df upstream.

As described in commit 7a54947e727b ('Merge patch series "fs: allow
changing idmappings"'), open_tree_attr(2) was necessary in order to
allow for a detached mount to be created and have its idmappings changed
without the risk of any racing threads operating on it. For this reason,
mount_setattr(2) still does not allow for id-mappings to be changed.

However, there was a bug in commit 2462651ffa76 ("fs: allow changing
idmappings") which allowed users to bypass this restriction by calling
open_tree_attr(2) *without* OPEN_TREE_CLONE.

can_idmap_mount() prevented this bug from allowing an attached
mountpoint's id-mapping from being modified (thanks to an is_anon_ns()
check), but this still allows for detached (but visible) mounts to have
their be id-mapping changed. This risks the same UAF and locking issues
as described in the merge commit, and was likely unintentional.

Fixes: 2462651ffa76 ("fs: allow changing idmappings")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Link: https://lore.kernel.org/20250808-open_tree_attr-bugfix-idmap-v1-1-0ec7bc05646c@cyphar.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5302,7 +5302,8 @@ SYSCALL_DEFINE5(open_tree_attr, int, dfd
 		int ret;
 		struct mount_kattr kattr = {};
 
-		kattr.kflags = MOUNT_KATTR_IDMAP_REPLACE;
+		if (flags & OPEN_TREE_CLONE)
+			kattr.kflags = MOUNT_KATTR_IDMAP_REPLACE;
 		if (flags & AT_RECURSIVE)
 			kattr.kflags |= MOUNT_KATTR_RECURSE;
 


