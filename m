Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C3147C107;
	Sat, 12 Sep 2026 16:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229034; cv=none; b=HCNVwUBDXNbOk/xJuAckOhU+WFbGcD3g31CAHqA7DDk28lCYFiRwdshN92r1VwtQD5XWNwQefzNnkSlHuH97JAErBIgfGPDuup8Dsfo+Cz4ZhVCFDEW/8ZFA3JlqMjRZou95g0i5+wha3iT7rkHZS+LEQkTB2sTHFulLd2FMUCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229034; c=relaxed/simple;
	bh=S22AeWYcS0YPIoeEr4qE6yu7kuDrOg74wl8lbWcxugg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLi7IOCw9O4LgUCxecX2qp7lzgjzc163OUbHHhH/++sZ6c2+wOYf/10pxLMLc7Iw0y4lJUJ4azQpSr19/aQnemmapFwjTGyk8EHO+NCMayzQwZ7jEArWpxzI6LbnBrVYd4Vcp7o6NlCul6ysl/tG6K8vgD6mAfwlz7zfCNTaTEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0WrQRht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0WrQRht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE601F000FF;
	Sat, 12 Sep 2026 16:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229031;
	bh=ahrER97oEWNYm+EYVq4fnd2MNkqKMf+VQmctKz5eZJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0WrQRhtvoBFKPhY8FBs+fMS0W3gN6Ci+5mzMjcbDXQVhyIofN3QUJ9EFzUZzmCEQ
	 t+D0WpBdxiE9boqGwEhrmFEjN/afoulhYLhxMSxG6tBXVpn9/POJ/VjlYDj2XW6Tzv
	 +meWRJMYmATBJHMaoP9nPHGNao/d90PMXasqR5FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0505/1191] tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands
Date: Sat, 12 Sep 2026 08:53:53 +0200
Message-ID: <20260912065559.582038418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1106970f63dc8..4048226ce110f 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -594,6 +594,10 @@ int do_struct_ops(int argc, char **argv)
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



