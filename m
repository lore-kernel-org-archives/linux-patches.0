Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED343AEF51;
	Sat, 12 Sep 2026 12:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214716; cv=none; b=YdvjZDViofdW42RBTCcHq8VluKmhNM8F0HN2bN0r+5mCtPANg9TsuZ9jo9Yu3hy2i55T9mpNZGqL0XkgV+bBapV6hor7V451oYFaJIT1NErDloxXuxJrgK1Hr5TS2BIkRd6tUOyDHcRnmXfaOCkuU9EhHzz8FH2V1zRtO5zDvmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214716; c=relaxed/simple;
	bh=lE8F1+xt6g0qTt8fRVT2TpesEujAleKUHBo+mbT5DlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clXY2/T/y4sjhEF7m+J8eIr9srTKi2pFfAtbRopyH7r3y/qqUFSO+jPB2qVxJfexHbSi73LT0lSeh/GtyUmPdaCYETE3vseRyMZagJUFCj/ssVnBP+zlhjsohQ2UP+4BfRsoXMtEu6LWcz4VI3f9KpJF/QFRfcyi3pncu3/WN1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3eH6vKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3eH6vKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D861F000FF;
	Sat, 12 Sep 2026 12:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214715;
	bh=CxOlu6SYn6ipN0/LBZgL8ynbhTH6odzt2cgrn7GCb38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3eH6vKDJlp2joD13kvHAJir9zuIwptUOjoldD4MzwzDKUSiExwuG8YMRI2PAhFo+
	 EyV9pYnKaBb5N8gV9HPsOXNdOM1gUOAwlVxHmNNYmC4fxl2+H6LCxZ83gg1L6c5ygY
	 UwFJTQl89CkibEdUodrorFAcS/rbudpeRE0u5j+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0376/1376] tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands
Date: Sat, 12 Sep 2026 08:46:42 +0200
Message-ID: <20260912065615.927943042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa43dead249cb..835e5e561f7fc 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -643,6 +643,10 @@ int do_struct_ops(int argc, char **argv)
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



