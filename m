Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0496413CFA4;
	Thu, 13 Jun 2024 12:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280839; cv=none; b=OFLCw1WRoYpfMxLkk06CRSNjo4LNtThMS2AbEE3ggLYnL9FKzdTGl3knX1GuoDErTeftDXPw20qlkqD3VqhMZTV4JWphPRZtqIWWsmUTL6DY+HLF3tMyp2jj5Ffs3HzqhESQB1uzdIxl3yO3wVNvP2PgxmwAiVC5sbKRQPbgAVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280839; c=relaxed/simple;
	bh=7v1g9KKA1i2Nm7xKjYMBXcYa0oRW2Fc26VhJ1OvRgwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IM/2OzaPqlvAN4hrrbYYmAMtaS9TQ7vqvOuTPd87AIOvBhdxTqUhGlZRHRcno6diOWj5fUtJlHBwflmHge4JNq3wcSlfBlQwwOiNLzWviwEHjE+Z1Q8Ir/86TbtspqR9IlfFT2Vz+QlH1WYNmorU/fl27LW+LLUe12YVWwETmSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2DJwlGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2DJwlGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA32C32786;
	Thu, 13 Jun 2024 12:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280838;
	bh=7v1g9KKA1i2Nm7xKjYMBXcYa0oRW2Fc26VhJ1OvRgwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2DJwlGv+kejoJDl5YfMnAK7ef7Ubg8z1LzULFmHZqz5AZdfP6Sl0Lnj3iQDkWXui
	 9lOTNwUI62tV8Z45zru7NplCYVcMoHZ8ksmrcPYU8NbqKjkRvXAmeAjvgirUUSD6Iv
	 fReFnucM0xntgKt0aKAxvuJlVEt1d6+in8iwHK+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/317] selftests/bpf: Fix umount cgroup2 error in test_sockmap
Date: Thu, 13 Jun 2024 13:31:09 +0200
Message-ID: <20240613113249.522986689@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 427ca00a32177..85d57633c8b65 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -2014,9 +2014,9 @@ int main(int argc, char **argv)
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



