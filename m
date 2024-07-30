Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062FE1A6195;
	Tue, 30 Jul 2024 16:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357334; cv=none; b=s/UI/aiTzLG/yMcY32p/mQfNTt+LoWLYKlrSVAAJCErQgU33owuzz3fl2gY14O9A6syt0yWZzjfy/otG+tA3E/sBw0UpALHCc1Xtl0zcNoMPTdGTRruXLqKadJio+o5HOvinVDzIoVnta6lLqec3/hrOFSe3f3Af/EQfyd0VZNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357334; c=relaxed/simple;
	bh=7Dk1ZVtzuJA7ihXRJB1nCrGdpY5KGDYSdxMxb3Hpgng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dllswSd9x0IJAmJZyFsnjH1wLIfWryx7HX3mKb+VTLfIJMnOL0CdfJQ51PbNZhaM0En63hWxOFBgrqL9n+UbIgAqaSytiqWjDcIfkZqrgp9RGWjhrLAGcD1kVhGR/YgjBGTdPuxnvxmtWmSOGYmZ6pvoL+CxG7tzA981tTfq0EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eU2wZKWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eU2wZKWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E28C4AF0A;
	Tue, 30 Jul 2024 16:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357333;
	bh=7Dk1ZVtzuJA7ihXRJB1nCrGdpY5KGDYSdxMxb3Hpgng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eU2wZKWWNLVUsppYbGsiWU+7uBBWweRx9sDfLgJzG1VIZu02KP5KBYa7vzH7RNMS8
	 LOjd7sW10YhERfWQy7CMjsQ5gq8dYrmxPf4v+ufItcrB0bfwpXvlQil0p3t7aylCDA
	 DDKixfAwOzMe5hbTLnju4yR3NvuGvt1j9GzkcaXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 220/809] bpftool: Mount bpffs when pinmaps path not under the bpffs
Date: Tue, 30 Jul 2024 17:41:36 +0200
Message-ID: <20240730151733.298502008@linuxfoundation.org>
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
index 1a501cf09e782..40ea743d139fd 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1813,6 +1813,10 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
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



