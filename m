Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4DF3C1F46;
	Sat, 12 Sep 2026 07:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197321; cv=none; b=Gkg0gzCb6F4JapcF+lyRvXccN+bOkSHg5OVTHZmrfXwQbyUeYEFMGiHzw62N0y/c39WPU+YjoMEmU0id3NzMli+WQzromVGSuOp/beq3m7wvS+s3ssWTNwjyqSwohf9AZZnLOA4t6mTiBRz3NO+nT/ERXbbx4ihr7Rkizx8DZ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197321; c=relaxed/simple;
	bh=ZTmDr3BC3f94lwraJyPcYWhm5XXvC6wnm1DcgZUeUC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpQGIKq5BWLfZfrSm61k+tZFWoZOhMt9ZohYZgq1tmrPByASGr1zmX3CxCU3el7KO0EgxV12GSq1hAaDLNwzbi2kNeIdCArMpYQJsXvTAo6aOMOPpFw9S/igZoV30RAiIIR9n5awKeEwkx60C+djsGqJnN5MW41449raOPBQRaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLrxU5kB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLrxU5kB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AB41F000FF;
	Sat, 12 Sep 2026 07:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197320;
	bh=B4re2oJqVnacuAw79ABZuigI1NnRTKuUofdIGNE5nEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLrxU5kBjDcCRMBeQ7h6hGKs1ZaOVmhit8R5+nLxvVx3g6HUVH0hNWkl+1T12O53Q
	 2o6kJ9UoLm/ssXYzXsjUG/qSDLkSHqkl8FAOZauhK9OXXNvR8CmnM1toHLIeer8mCj
	 8cPWen/QYyrT0bMdPr8ZEV8kMYF9pYFYYYAGxIzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0151/1815] tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands
Date: Sat, 12 Sep 2026 08:31:41 +0200
Message-ID: <20260912065652.559288273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



