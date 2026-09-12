Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128BD355803;
	Sat, 12 Sep 2026 09:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206270; cv=none; b=eldHEaa44EOa+11R51R8c+QYaDXt3tMATCfUFUGHBw/oubr22SPcHLo0jCvMT8x7wdn9zwvxwjNchBUOROSimDwKJTaYIMDGyhUeqJk8STFzTR75xSG4ijuk1XJOpk5iEyQt8ofFBVavVN7LkNeKeywK9a4pIJ9Hnln4H2pnR0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206270; c=relaxed/simple;
	bh=tsZJvobcBrNatFclyb+HicglX9N9OehYvY9o6tXMqqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+/92FFMrTeBJlUt7ruk8i4LowNKZY95kOBC7izyT9gIXzsr0f34TPr0FJal95amaG+APXJxRePfQFSOGCp8GB/AntOn0CK8K9GcpXcAkzHzT5WIK0dgmYq/5R/3C1P86EkEif3/IunpG1/nkEbLP1pVeBQQdLdiX8Yedw+5QiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqUyTvAv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqUyTvAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0045A1F000FF;
	Sat, 12 Sep 2026 09:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206268;
	bh=3D17UN61xI25s3vz5M2UaOYfJprmDyx3Vuwy0F+cv84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qqUyTvAvCkLKs6PreW82S30ckZfJ6e7C8msH+TAcbrgnZ1C15gq4ZSa5MPNVDeTW+
	 DEpHidBadBbMDwDHNeniM9vqn0Y1UVM9po/hiHOhQYB+aB8xoMDTeXosSJII1DSnt5
	 T81qhxKsrH97VzPnhoztm1OrwjfLHEY5pvDK8SoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0171/1518] tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands
Date: Sat, 12 Sep 2026 08:39:00 +0200
Message-ID: <20260912065627.364906460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



