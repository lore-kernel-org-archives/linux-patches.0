Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5871D3043CF;
	Sat, 12 Sep 2026 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222610; cv=none; b=IneMru/7YmR3J9Msfy+9jT1v08hYZXjiqMMNSxCqS9g76ptwH6DwUw+I9Dgto6rd/Zs75f7vC4Y+3mkONZt7UoltMrS9qKcPeEGFvnFIG6Ka51JhFR7e0simwxuRFTUvmJElB4JGnPsPE6EuJGBjS60d/+ZXFRO31aYtc37SpYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222610; c=relaxed/simple;
	bh=05R8Uza+BgtCeS0CXzdmcoA6QDhxdWUD9RHVxC5NDrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvOlmRyk86CZ0LUWQmZju6T8zBwrahlatlrIwFiMnwZb/ztIiMqbYPb6ICy2FhysYskfNQwxOEBfPX6n+FUfncX0m90bu5M8f885RobsNLAs6iZ4upBgdVvKASgJ4IoVAHBhEZvOqG0VGuMc5UzwOcVuZOnH7JHvJYePdSBWDJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TZBpbvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TZBpbvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159111F000FF;
	Sat, 12 Sep 2026 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222609;
	bh=h3pcQvfK4MbryZrXUzI0Fqnxr0Q8whhvWDt7oU0mXE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2TZBpbvduvr6OzAsC8pBulrT0WEh+31I/FofvmS53jDuhea1Pr/4XQIqjz6ujAouF
	 QNi/6joFxrYRMht+HMnhHZQyr4NeFBrrQpkUMoswBks6kk/hAsks6g2q0gRcOEzMcY
	 qsY9MCFIlT51OTHg/yTEjKzINYg1bZHn/gc/7ezY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0620/1424] tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands
Date: Sat, 12 Sep 2026 08:50:52 +0200
Message-ID: <20260912065621.176360198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit f7f540e19751face50c68bb9ce58460fcb46c293 ]

struct_ops frees the global btf_vmlinux object.

In batch mode, a later struct_ops command can reuse stale state.

Reset the BTF pointer and cached map info state.

Fixes: 65c93628599d ("bpftool: Add struct_ops support")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/9F9017160ABE125F+20260624025055.1574875-3-chenyichong@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/struct_ops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index d110c6ad8175c..05f08dae661e4 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -637,6 +637,10 @@ int do_struct_ops(int argc, char **argv)
 	err = cmd_select(cmds, argc, argv, do_help);
 
 	btf__free(btf_vmlinux);
+	btf_vmlinux = NULL;
+	map_info_type = NULL;
+	map_info_alloc_len = 0;
+	map_info_type_id = 0;
 
 	return err;
 }
-- 
2.53.0



