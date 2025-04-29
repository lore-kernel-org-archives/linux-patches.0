Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206792517A6;
	Tue, 29 Apr 2025 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950542; cv=none; b=Vb1t3bAX5B7g/SBAfhBASeHRbhtZuVC+AG2so2IQBd9ENyUdVsYPZJx+KNIoA+0RAvozOGOG2UrBXTcfNeNpjRVCER6wYnMqZs1T4Pe65xDVwJ4wGJVSvk7HO8WXNnlTwJ3nzl7zAeBZYWSTUCfxEk16HQb8yPp7/k6zcCgHjTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950542; c=relaxed/simple;
	bh=J6+bQxQ9oNIKufbypeAyJ2KOX4f/lBI5xyfRZS8AwPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUarzGtVOdQjXgpi15QtZHsBX3gAX5sJJNB/xnT3vh0IC/Qe4FBKwvpt4EnmNC9qbS+zBUfafTTqWYKmp+cN67UuwEahQ082yw5YT9+Lag3BR/yd9FK8GgR44jJNXL2DJrRsEKxkAAzVAScEqFp6TPUzIABjd2V/2JrPCSk0oUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+cKzse4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+cKzse4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFF0C4CEEA;
	Tue, 29 Apr 2025 18:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950542;
	bh=J6+bQxQ9oNIKufbypeAyJ2KOX4f/lBI5xyfRZS8AwPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+cKzse4j3jVxsWCQ6JTNlYnkpL53RsWXgKOHZKT8KpUXku6mgQ3kAy8zk8zH1InZ
	 HRcAXrJkOYxAzNCKCLBfULMQygSRYGdSmpS3nuA9dxjHRi4qI7g55xC/kWcGT/lDiH
	 0Cx8kdoaY2QFGAcgJsixOPDo2dWhpK9dAjVwUotA=
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
Subject: [PATCH 6.6 126/204] bpf: bpftool: Setting error code in do_loader()
Date: Tue, 29 Apr 2025 18:43:34 +0200
Message-ID: <20250429161104.586472204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 90ae2ea61324c..174e076e56af2 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1924,6 +1924,7 @@ static int do_loader(int argc, char **argv)
 
 	obj = bpf_object__open_file(file, &open_opts);
 	if (!obj) {
+		err = -1;
 		p_err("failed to open object file");
 		goto err_close_obj;
 	}
-- 
2.39.5



