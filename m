Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD05B1A6186;
	Tue, 30 Jul 2024 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356415; cv=none; b=NUIf2xgUHW36xUIeRWS7X7Mzp8zjSDhWkMIE2YRsBir1kupavFjsmaoX4MhyFwR9R2cBAbUvSGChSz/W4DvN6qdfqaSUH/AQMwiM6OCLG/oZ1AlUfQSD1xnwg565pYb8nAVxQ76J54eRbuJ0kINIopEyXFXE/MleQc0I1DTtAYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356415; c=relaxed/simple;
	bh=ZV+PlKRw5noDHpOU4cjVcfoGeNHXlWKje1RYrWKCXuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXPfqm9eyGqtG05bOGS63et4SXEfh0fhu5bEUBXIQVhzPbs4ZHHp50TtjQs7Z5KXz9adEn/LUIiagSYJS6THGr1RF6fQCpZwobCfyIU4+Hq5lB63mZmtb/8kotw/270jNepHk1V59xWPyTOnxxVK8W/DlAIWXHir+HIg2xCAtL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jF2It86f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jF2It86f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68833C32782;
	Tue, 30 Jul 2024 16:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356414;
	bh=ZV+PlKRw5noDHpOU4cjVcfoGeNHXlWKje1RYrWKCXuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jF2It86fLC2ZzCu4ZnKAc/+mzAFWM7qGQ4RZeQZxIhNNxfRAsArS2qKLKad9t57IN
	 ToIqoP55UhejOSrAg5zXzwo9pt/9FMhhIq4o8sJHzypesJNnKf0m/9HcG3eaBDd84K
	 MjOav6NhArxzU+Oce1Oz7B5Gzkslu1a0BaMPYCP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/568] bpftool: Mount bpffs when pinmaps path not under the bpffs
Date: Tue, 30 Jul 2024 17:44:13 +0200
Message-ID: <20240730151645.584658543@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Tao Chen <chen.dylane@gmail.com>

[ Upstream commit da5f8fd1f0d393d5eaaba9ad8c22d1c26bb2bf9b ]

As Quentin said [0], BPF map pinning will fail if the pinmaps path is not
under the bpffs, like:

  libbpf: specified path /home/ubuntu/test/sock_ops_map is not on BPF FS
  Error: failed to pin all maps

  [0] https://github.com/libbpf/bpftool/issues/146

Fixes: 3767a94b3253 ("bpftool: add pinmaps argument to the load/loadall")
Signed-off-by: Tao Chen <chen.dylane@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Quentin Monnet <qmo@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20240702131150.15622-1-chen.dylane@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 086b93939ce93..e5e0fe3854a35 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1809,6 +1809,10 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 	}
 
 	if (pinmaps) {
+		err = create_and_mount_bpffs_dir(pinmaps);
+		if (err)
+			goto err_unpin;
+
 		err = bpf_object__pin_maps(obj, pinmaps);
 		if (err) {
 			p_err("failed to pin all maps");
-- 
2.43.0



