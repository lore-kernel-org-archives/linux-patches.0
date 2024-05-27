Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AC31078F;
	Mon, 27 May 2024 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836783; cv=none; b=AirlgNrEFn9opQGoThDaC1YceNFFDD0qya4i0sZgaDQ/zGK/y/JeBaY0zaX9DkCmgFKspan3pm8hbhXtqhe9aOcB6zVy762Pxg0ZE+LaBaJKxxqvOktmd5zRlprMv4b/qHEtneKIxU2BIA3GXws4XpS3oUnDPtERTUJyshYRILc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836783; c=relaxed/simple;
	bh=+t4hf7s5EpjtKIwjRlL/eladGeSn2UByBeNhSDC4vF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvGGyP7f53z0iElR5g9fyqCiDjmwKYvxVjB4k4pCvSeq6TqszFYFtpCIk+rGx6pDbK9hU2uk15FTpMTbQfJRqX6I0yrq0NPDBDbsMropFvU9J+9KfXLUwA/IJ1cjTEUVJY/Z+W82Gy+idicy2wj9CT9Z6BX0+yYLALIDnhzN9Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwhY4zJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwhY4zJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4813CC2BBFC;
	Mon, 27 May 2024 19:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836783;
	bh=+t4hf7s5EpjtKIwjRlL/eladGeSn2UByBeNhSDC4vF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwhY4zJppuSny2NI3bjSJQ7DEX3MJYqm/Wr1VRws/W/ILiFOicfVSC9FLs4p0GJxl
	 d2qilQ6nTM6Gkghi/XKwEJJlieuWaXsSIGM6MnzBuUbr2n7S+ysOFg54/GSiFpcPRu
	 WeRiB2eWA9rng4n7mbFEuRcweVwZ8cT8PEUurn/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 144/427] selftests/bpf: Fix umount cgroup2 error in test_sockmap
Date: Mon, 27 May 2024 20:53:11 +0200
Message-ID: <20240527185615.306745242@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit d75142dbeb2bd1587b9cc19f841578f541275a64 ]

This patch fixes the following "umount cgroup2" error in test_sockmap.c:

 (cgroup_helpers.c:353: errno: Device or resource busy) umount cgroup2

Cgroup fd cg_fd should be closed before cleanup_cgroup_environment().

Fixes: 13a5f3ffd202 ("bpf: Selftests, sockmap test prog run without setting cgroup")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/0399983bde729708773416b8488bac2cd5e022b8.1712639568.git.tanggeliang@kylinos.cn
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 024a0faafb3be..43612de44fbf5 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -2104,9 +2104,9 @@ int main(int argc, char **argv)
 		free(options.whitelist);
 	if (options.blacklist)
 		free(options.blacklist);
+	close(cg_fd);
 	if (cg_created)
 		cleanup_cgroup_environment();
-	close(cg_fd);
 	return err;
 }
 
-- 
2.43.0



