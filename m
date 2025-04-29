Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1309A238C21;
	Tue, 29 Apr 2025 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948004; cv=none; b=Dc+oPwRBapVcvYytuYONBQASKHHXtT0ocSkhTakl7fXbEdM5ooFmQH2QY/GCYU+lYovoRuK4eJVMlJrjYmOStejF3OLeKJ1rz2KFscxAlYuDRQRElXip21mBg26//Vp/d2H6SRwwUZhn8abxEHuoPhWO50XeF9mRGeS15FW5/u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948004; c=relaxed/simple;
	bh=yHW4AQEp6AvrNc7Zn9TICUwOmnyHI1uMSri9Po9WmO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+r0X1OrP7/7LDJGaXASpAeRYoeb7oBdjAB1Dw4TK2oJgbfNUOYWTbvXhCLg/5UKz+r5kPfMUTs3pZ4UASJgjjSs9FadS4j4DcX1ZqcV4euNceYNvc+JqvRLs/bvwfYlzf5DpcRuePlFOBSUelqqiskW5LzECy7k12bXB4F08KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrFSzDhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrFSzDhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97384C4CEE3;
	Tue, 29 Apr 2025 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948003;
	bh=yHW4AQEp6AvrNc7Zn9TICUwOmnyHI1uMSri9Po9WmO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrFSzDhKok0mYJtBwwhcClEVrN006Fgy8E7ncyghuoqQwP+8xgR4+IfgRh9FnBOAp
	 et7GsvCSuK4xp3L63Z+USGGFkz8FApiaRE3DZP/Z01n1WEOOb0GbVwOpNpSuVKzEfN
	 B7OyLDyHeeQ/eUAmVCF4/cWwQMVPlmquRNkY9Gr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sewon Nam <swnam0729@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/280] bpf: bpftool: Setting error code in do_loader()
Date: Tue, 29 Apr 2025 18:41:46 +0200
Message-ID: <20250429161121.863276093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sewon Nam <swnam0729@gmail.com>

[ Upstream commit 02a4694107b4c830d4bd6d194e98b3ac0bc86f29 ]

We are missing setting error code in do_loader() when
bpf_object__open_file() fails. This means the command's exit status code
will be successful, even though the operation failed. So make sure to
return the correct error code. To maintain consistency with other
locations where bpf_object__open_file() is called, return -1.

  [0] Closes: https://github.com/libbpf/bpftool/issues/156

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sewon Nam <swnam0729@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Quentin Monnet <qmo@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/d3b5b4b4-19bb-4619-b4dd-86c958c4a367@stanley.mountain/t/#u
Link: https://lore.kernel.org/bpf/20250311031238.14865-1-swnam0729@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index e71be67f1d865..52ffb74ae4e89 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1928,6 +1928,7 @@ static int do_loader(int argc, char **argv)
 
 	obj = bpf_object__open_file(file, &open_opts);
 	if (!obj) {
+		err = -1;
 		p_err("failed to open object file");
 		goto err_close_obj;
 	}
-- 
2.39.5



