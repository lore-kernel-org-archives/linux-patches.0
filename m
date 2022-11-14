Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7F34C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBCDC43470;
	Mon, 14 Nov 2022 13:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430896;
	bh=G3q6fi/Gm56A5biu4lnn7SUeJiifoibO8ooL5pPtDcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyn3JzvU8RaVpr34uiUP4IduhLK+M6O9tt36byvs+5UOXoKVBqdULMKDco2JvorsT
	 2QYzjqkL+kd9ZS197qUVsuRyQOHxSXUL4a9YaQqWMxSDOyCzirvrZ3Eeq7I/X+JREL
	 oImD7BK0c6zLAZhSwxkGolUTNTkRi9z9xM5G+/IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 027/190] bpftool: Fix NULL pointer dereference when pin {PROG, MAP, LINK} without FILE
Date: Mon, 14 Nov 2022 13:44:11 +0100
Message-Id: <20221114124459.939188170@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 34de8e6e0e1f66e431abf4123934a2581cb5f133 ]

When using bpftool to pin {PROG, MAP, LINK} without FILE,
segmentation fault will occur. The reson is that the lack
of FILE will cause strlen to trigger NULL pointer dereference.
The corresponding stacktrace is shown below:

do_pin
  do_pin_any
    do_pin_fd
      mount_bpffs_for_pin
        strlen(name) <- NULL pointer dereference

Fix it by adding validation to the common process.

Fixes: 75a1e792c335 ("tools: bpftool: Allow all prog/map handles for pinning objects")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20221102084034.3342995-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 067e9ea59e3b..3bdbc0ce75b1 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -300,6 +300,9 @@ int do_pin_any(int argc, char **argv, int (*get_fd)(int *, char ***))
 	int err;
 	int fd;
 
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
 	fd = get_fd(&argc, &argv);
 	if (fd < 0)
 		return fd;
-- 
2.35.1



