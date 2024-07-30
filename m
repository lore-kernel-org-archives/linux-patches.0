Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB9D1A6190;
	Tue, 30 Jul 2024 16:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356739; cv=none; b=HCabPsrY7/mJKFzC6m0vhA93esFPJmed2feNbksKgTx+XrPtlzBRTAghng4fpyQCw4RYWkKf10gp7GENwztPijbhMl7stztKmpMnuN4us+JOkDqKMBFbzaUY8+H/eVtqC6LYmWjPuJ5iETtLxK9I8II/e5zK/N6H/zPs1Pq8boE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356739; c=relaxed/simple;
	bh=hiPbXNUBqI+sZPWZ2r0Xfmhm198jhKnyFamvjVtXrHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxOcv/ugnYImN/TdAEBXp3yQeEnNSkVCDLqXRDTImEhlEt7hSxGPzs5GvhKQUxl2WOPjTlb95amGkTpPZZd8CzDmaFJGBkU2HxGSgNn1Yltf/mRGnxb7tE7kas680/0Zj4qzot397J6DSx+6DfVURjq/hyRI2WQhxwP5YzEgFs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDMnQFON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDMnQFON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149F6C32782;
	Tue, 30 Jul 2024 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356739;
	bh=hiPbXNUBqI+sZPWZ2r0Xfmhm198jhKnyFamvjVtXrHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDMnQFON8UQ7aqOFM8HKqfou0+5Yp3XlM6yhsbyiagPI1AtlQKP7H0NmYRnKHIW29
	 7qCipypb8CkOizOOKbZW4edinZB/U4LBpey4BK7aNLdjw1He9lJBGGWSjwpcn2fHOM
	 r08PrDRk+cM6UjiRmtPMdOm2fZAqTYBGc0IN6SyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lennart Poettering <lennart@poettering.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 178/809] libbpf: keep FD_CLOEXEC flag when dup()ing FD
Date: Tue, 30 Jul 2024 17:40:54 +0200
Message-ID: <20240730151731.643294331@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 531876c80004ecff7bfdbd8ba6c6b48835ef5e22 ]

Make sure to preserve and/or enforce FD_CLOEXEC flag on duped FDs.
Use dup3() with O_CLOEXEC flag for that.

Without this fix libbpf effectively clears FD_CLOEXEC flag on each of BPF
map/prog FD, which is definitely not the right or expected behavior.

Reported-by: Lennart Poettering <lennart@poettering.net>
Fixes: bc308d011ab8 ("libbpf: call dup2() syscall directly")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20240529223239.504241-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf_internal.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index a0dcfb82e455d..7e7e686008c62 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -597,13 +597,9 @@ static inline int ensure_good_fd(int fd)
 	return fd;
 }
 
-static inline int sys_dup2(int oldfd, int newfd)
+static inline int sys_dup3(int oldfd, int newfd, int flags)
 {
-#ifdef __NR_dup2
-	return syscall(__NR_dup2, oldfd, newfd);
-#else
-	return syscall(__NR_dup3, oldfd, newfd, 0);
-#endif
+	return syscall(__NR_dup3, oldfd, newfd, flags);
 }
 
 /* Point *fixed_fd* to the same file that *tmp_fd* points to.
@@ -614,7 +610,7 @@ static inline int reuse_fd(int fixed_fd, int tmp_fd)
 {
 	int err;
 
-	err = sys_dup2(tmp_fd, fixed_fd);
+	err = sys_dup3(tmp_fd, fixed_fd, O_CLOEXEC);
 	err = err < 0 ? -errno : 0;
 	close(tmp_fd); /* clean up temporary FD */
 	return err;
-- 
2.43.0



