Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39C6350831;
	Tue, 26 Aug 2025 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217611; cv=none; b=jzavssGfFKI70ngsLL+58jjRAMoaIwl08lgpWtoGaovhyyXcwCes83YSQ8Pu7SxIbiyX4C56fEjABuYYqkzaQ4NMweSX+gqLEuuxBpekRe41AO/5u7ARCXB2v+LOAdtiDd1h7gJQEYOxF/GFnNE3Uif6+iKttnvnm7o0cHMmwUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217611; c=relaxed/simple;
	bh=u4jfQ6x1qBa6MLkZM1WjAEd2lBGc+aJ6Wp5Ap5SIb0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6TGO/DA2aKuI8b5+TsMpGfNtBo+eQrzZ+OuFuQPD4jGwrFB4ktjIjXT+aOnERFZl8HXctM9lrYLBj8OVKWO4FGpM2n4V6nV6OPAgPrYPR76Kcdei38B8sEJZv2jyHO8nMoVhbG+eXrrM3IUIDFveykhSMZXmwzeoQ4q+2qePCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onaclEX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onaclEX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C0EC4CEF1;
	Tue, 26 Aug 2025 14:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217611;
	bh=u4jfQ6x1qBa6MLkZM1WjAEd2lBGc+aJ6Wp5Ap5SIb0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onaclEX1rj6xE6lRasNjOoLtWi/pJzxDFKlm+9rqh6lUSeerGgQeuEAKnIIkk3fJh
	 8KLYqRUdy2wEw0njqfl5gE7/WP4ouh/ELsPQzsFAZOu3O46yYyLksfeq9AhPho67Cs
	 G8CZ88OBlmLRwFRE4H5lnWIBVjlMFxNqcgrxwV7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 201/523] fs: Prevent file descriptor table allocations exceeding INT_MAX
Date: Tue, 26 Aug 2025 13:06:51 +0200
Message-ID: <20250826110929.406125386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sashal@kernel.org>

commit 04a2c4b4511d186b0fce685da21085a5d4acd370 upstream.

When sysctl_nr_open is set to a very high value (for example, 1073741816
as set by systemd), processes attempting to use file descriptors near
the limit can trigger massive memory allocation attempts that exceed
INT_MAX, resulting in a WARNING in mm/slub.c:

  WARNING: CPU: 0 PID: 44 at mm/slub.c:5027 __kvmalloc_node_noprof+0x21a/0x288

This happens because kvmalloc_array() and kvmalloc() check if the
requested size exceeds INT_MAX and emit a warning when the allocation is
not flagged with __GFP_NOWARN.

Specifically, when nr_open is set to 1073741816 (0x3ffffff8) and a
process calls dup2(oldfd, 1073741880), the kernel attempts to allocate:
- File descriptor array: 1073741880 * 8 bytes = 8,589,935,040 bytes
- Multiple bitmaps: ~400MB
- Total allocation size: > 8GB (exceeding INT_MAX = 2,147,483,647)

Reproducer:
1. Set /proc/sys/fs/nr_open to 1073741816:
   # echo 1073741816 > /proc/sys/fs/nr_open

2. Run a program that uses a high file descriptor:
   #include <unistd.h>
   #include <sys/resource.h>

   int main() {
       struct rlimit rlim = {1073741824, 1073741824};
       setrlimit(RLIMIT_NOFILE, &rlim);
       dup2(2, 1073741880);  // Triggers the warning
       return 0;
   }

3. Observe WARNING in dmesg at mm/slub.c:5027

systemd commit a8b627a introduced automatic bumping of fs.nr_open to the
maximum possible value. The rationale was that systems with memory
control groups (memcg) no longer need separate file descriptor limits
since memory is properly accounted. However, this change overlooked
that:

1. The kernel's allocation functions still enforce INT_MAX as a maximum
   size regardless of memcg accounting
2. Programs and tests that legitimately test file descriptor limits can
   inadvertently trigger massive allocations
3. The resulting allocations (>8GB) are impractical and will always fail

systemd's algorithm starts with INT_MAX and keeps halving the value
until the kernel accepts it. On most systems, this results in nr_open
being set to 1073741816 (0x3ffffff8), which is just under 1GB of file
descriptors.

While processes rarely use file descriptors near this limit in normal
operation, certain selftests (like
tools/testing/selftests/core/unshare_test.c) and programs that test file
descriptor limits can trigger this issue.

Fix this by adding a check in alloc_fdtable() to ensure the requested
allocation size does not exceed INT_MAX. This causes the operation to
fail with -EMFILE instead of triggering a kernel warning and avoids the
impractical >8GB memory allocation request.

Fixes: 9cfe015aa424 ("get rid of NR_OPEN and introduce a sysctl_nr_open")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/20250629074021.1038845-1-sashal@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/file.c
+++ b/fs/file.c
@@ -126,6 +126,21 @@ static struct fdtable * alloc_fdtable(un
 	if (unlikely(nr > sysctl_nr_open))
 		nr = ((sysctl_nr_open - 1) | (BITS_PER_LONG - 1)) + 1;
 
+	/*
+	 * Check if the allocation size would exceed INT_MAX. kvmalloc_array()
+	 * and kvmalloc() will warn if the allocation size is greater than
+	 * INT_MAX, as filp_cachep objects are not __GFP_NOWARN.
+	 *
+	 * This can happen when sysctl_nr_open is set to a very high value and
+	 * a process tries to use a file descriptor near that limit. For example,
+	 * if sysctl_nr_open is set to 1073741816 (0x3ffffff8) - which is what
+	 * systemd typically sets it to - then trying to use a file descriptor
+	 * close to that value will require allocating a file descriptor table
+	 * that exceeds 8GB in size.
+	 */
+	if (unlikely(nr > INT_MAX / sizeof(struct file *)))
+		return ERR_PTR(-EMFILE);
+
 	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL_ACCOUNT);
 	if (!fdt)
 		goto out;


