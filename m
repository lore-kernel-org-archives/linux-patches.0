Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86361DDCE;
	Tue, 16 Jul 2024 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145817; cv=none; b=sj9oJBfTB/90qv1a2w4C/juTFD5WM0Z2ix6J43WpgNeB/aK1nZeoLVZ1fo4JShPTgKZQvnkZnsiHfVepyV8v0dQf5saBZr0X0gppSYRwEQ3CqlKGm1U462XEYqy/Z6+glhqzTgiy2SbYVJ308WRXSgeq5kJOH1/I0o+qf9iOO+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145817; c=relaxed/simple;
	bh=Esz6IPIZ/coz5SCNHGUR/3/OsH0yH/p6z/ncCfC0nGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuGtY8jQm6lmQX0tc2mU5RZa+QFSGsFi/vkqowgIrCt9NhDz+2VXP8XwI83lcRPKh5PAY9NrQOeMl1x0BiuoKC9kH0S3XOsAYw9afjnuhcAS+mxfgZh74XdRzw7XuqE/WhxzYrbRfR6ngVTqe3oXuOHlDTxPb9+Jor6OiXvnV+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nO1gSG4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nO1gSG4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16D2C116B1;
	Tue, 16 Jul 2024 16:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145817;
	bh=Esz6IPIZ/coz5SCNHGUR/3/OsH0yH/p6z/ncCfC0nGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nO1gSG4ynV7NAx4Rk/PMYisDCVKJE/WgwUo15jjFtBgUdfRaGSnm58U4a8hIrOHy8
	 6N1z5eb2UHKInUnHeN9Wj51QGkxonM6PSc82h8oTke2LLgndIXuCmSp0oCIOERxjLX
	 RYG0nieMJJFZQipq71l8Iw8oo1tzbiPdxFhBs3g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Audra Mitchell <audra@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@linux.vnet.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Rafael Aquini <raquini@redhat.com>,
	Shaohua Li <shli@fb.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 087/121] Fix userfaultfd_api to return EINVAL as expected
Date: Tue, 16 Jul 2024 17:32:29 +0200
Message-ID: <20240716152754.674526437@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Audra Mitchell <audra@redhat.com>

commit 1723f04caacb32cadc4e063725d836a0c4450694 upstream.

Currently if we request a feature that is not set in the Kernel config we
fail silently and return all the available features.  However, the man
page indicates we should return an EINVAL.

We need to fix this issue since we can end up with a Kernel warning should
a program request the feature UFFD_FEATURE_WP_UNPOPULATED on a kernel with
the config not set with this feature.

 [  200.812896] WARNING: CPU: 91 PID: 13634 at mm/memory.c:1660 zap_pte_range+0x43d/0x660
 [  200.820738] Modules linked in:
 [  200.869387] CPU: 91 PID: 13634 Comm: userfaultfd Kdump: loaded Not tainted 6.9.0-rc5+ #8
 [  200.877477] Hardware name: Dell Inc. PowerEdge R6525/0N7YGH, BIOS 2.7.3 03/30/2022
 [  200.885052] RIP: 0010:zap_pte_range+0x43d/0x660

Link: https://lkml.kernel.org/r/20240626130513.120193-1-audra@redhat.com
Fixes: e06f1e1dd499 ("userfaultfd: wp: enabled write protection in userfaultfd API")
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -2050,7 +2050,7 @@ static int userfaultfd_api(struct userfa
 		goto out;
 	features = uffdio_api.features;
 	ret = -EINVAL;
-	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
+	if (uffdio_api.api != UFFD_API)
 		goto err_out;
 	ret = -EPERM;
 	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
@@ -2068,6 +2068,11 @@ static int userfaultfd_api(struct userfa
 	uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
 	uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
 #endif
+
+	ret = -EINVAL;
+	if (features & ~uffdio_api.features)
+		goto err_out;
+
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))


