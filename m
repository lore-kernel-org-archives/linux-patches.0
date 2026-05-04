Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC552315785;
	Mon,  4 May 2026 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904241; cv=none; b=E8Oj4+b2/ecKmdmzroGGyiDYGu7YaQQl7k/pEXlNhK2YrWP5SnRqqn00NTIkPZUEF6Ez/eSVcDpIoCkeMxpWZQglqV1NU9hWaQ7SR6/yZUwJi5tssTT3c5ZrvcHlnwWJ4nQrzo9G9936LFUVAUNh9ZSCjjh698coqgO3MEQcOY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904241; c=relaxed/simple;
	bh=D0jlf9kFz2+eJv4RIOtlC7NL4O+nQkLgUqhn0ohIkCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p34MU3OMvtnEG6kG4wEwoF4VK0pjmlDx5TsZEqpFBNsK+AFu4oVq8uMcyaeFWG2vAdkH5U29d9YvTu9ONLip0vD+9aYRiXr0vGj5ZT0ElEzJaoEmDRpCqYY8VCzbLUpdOxyITzGvQna5mbF+YapIdmK3fJLebwrv8Xwv6QLcnyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=allggIX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="allggIX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62639C2BCB8;
	Mon,  4 May 2026 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904241;
	bh=D0jlf9kFz2+eJv4RIOtlC7NL4O+nQkLgUqhn0ohIkCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=allggIX5+QDxPG9jSMOGLogGMZJhGSd7PK8DfrE5koi3gPD44hhxdM/RjfLlQ8GVh
	 L/dmIgY1vob/BAzz6S18IfEj1oERQf+O7TATIf5InjrhFtlBE7dJVMedGj5NRkoHaz
	 Kpxj+ja76X1j1jhnfI4dBQhJbku2ONrG4ArUy0XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.18 239/275] ntfs3: add buffer boundary checks to run_unpack()
Date: Mon,  4 May 2026 15:52:59 +0200
Message-ID: <20260504135151.924399287@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Gaertner <tob.gaertner@me.com>

commit b62567bca47408e6739dee75f02a2113548af875 upstream.

run_unpack() checks `run_buf < run_last` at the top of the while loop
but then reads size_size and offset_size bytes via run_unpack_s64()
without verifying they fit within the remaining buffer.  A crafted NTFS
image with truncated run data in an MFT attribute triggers an OOB heap
read of up to 15 bytes when the filesystem is mounted.

Add boundary checks before each run_unpack_s64() call to ensure the
declared field size does not exceed the remaining buffer.

Found by fuzzing with a source-patched harness (LibAFL + QEMU).

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Cc: stable@vger.kernel.org
Signed-off-by: Tobias Gaertner <tob.gaertner@me.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/run.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -963,6 +963,9 @@ int run_unpack(struct runs_tree *run, st
 		if (size_size > sizeof(len))
 			return -EINVAL;
 
+		if (run_buf + size_size > run_last)
+			return -EINVAL;
+
 		len = run_unpack_s64(run_buf, size_size, 0);
 		/* Skip size_size. */
 		run_buf += size_size;
@@ -975,6 +978,9 @@ int run_unpack(struct runs_tree *run, st
 		else if (offset_size <= sizeof(s64)) {
 			s64 dlcn;
 
+			if (run_buf + offset_size > run_last)
+				return -EINVAL;
+
 			/* Initial value of dlcn is -1 or 0. */
 			dlcn = (run_buf[offset_size - 1] & 0x80) ? (s64)-1 : 0;
 			dlcn = run_unpack_s64(run_buf, offset_size, dlcn);


