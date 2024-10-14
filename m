Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7AB75809;
	Mon, 14 Oct 2024 14:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917811; cv=none; b=KYMc9S4Fgrn6whrYvJTBv9XS3XwFqXbKxG3gnQD8UpRBalBx4FjrWhUIGFqQylsL2J1d+XQRjtVNgfifrwg49gPqkwzKbO54Vxq+3FGH7NZWE2cKBCiwOi7fgvtKw2pzgeHvmbCxpc7VySOh6ox4EoN/Kdq5DTKPmcymmwL9mlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917811; c=relaxed/simple;
	bh=GLBMDeOzdOYWZ2ecoEWUs3MsPuF95jvEI3yGQQfRvYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cc9+4BSK6c3YApzEwJTkRk6951C8Ri8PmOwnWspoeyVAU9EUDpZ6r9/PMoqEhOU+10wyItak+vz0octp2w6r4j279aqG1Tt1HA1MjvLrAVNGXcym1SCnRGoO7Ah5MGtzprVkqXkHqCju3UrhSTAN7/3FD/zZsmOyT0xiNv/TCzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqZufTU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqZufTU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB419C4CEC3;
	Mon, 14 Oct 2024 14:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917811;
	bh=GLBMDeOzdOYWZ2ecoEWUs3MsPuF95jvEI3yGQQfRvYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqZufTU61DFz9ku32oLJyXfEjdm+yQtGjz3EAbdFN8/gXPgq4iBTwHE+WytNGn2Oo
	 dbo8SqypqIV54+2jmwirbCe3g305IbCKTlae7g13lPbfW3hvd5oueBAoUVLYJi89Jd
	 QI0tzlrbsaULHcqK8WUk0aZi6FSOtl4rFIRdE5GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/798] selftests/bpf: Use pid_t consistently in test_progs.c
Date: Mon, 14 Oct 2024 16:11:35 +0200
Message-ID: <20241014141223.458498462@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit ec4fe2f0fa12fd2d0115df7e58414dc26899cc5e ]

Use pid_t rather than __pid_t when allocating memory for 'worker_pids' in
'struct test_env', as this is its declared type and also avoids compile
errors seen building against musl libc on mipsel64:

  test_progs.c:1738:49: error: '__pid_t' undeclared (first use in this function); did you mean 'pid_t'?
   1738 |                 env.worker_pids = calloc(sizeof(__pid_t), env.workers);
        |                                                 ^~~~~~~
        |                                                 pid_t
  test_progs.c:1738:49: note: each undeclared identifier is reported only once for each function it appears in

Fixes: 91b2c0afd00c ("selftests/bpf: Add parallelism to test_progs")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Geliang Tang <geliang@kernel.org>
Link: https://lore.kernel.org/bpf/c6447da51a94babc1931711a43e2ceecb135c93d.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 3fef451d88313..a952d614ffbbd 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1639,7 +1639,7 @@ int main(int argc, char **argv)
 	/* launch workers if requested */
 	env.worker_id = -1; /* main process */
 	if (env.workers) {
-		env.worker_pids = calloc(sizeof(__pid_t), env.workers);
+		env.worker_pids = calloc(sizeof(pid_t), env.workers);
 		env.worker_socks = calloc(sizeof(int), env.workers);
 		if (env.debug)
 			fprintf(stdout, "Launching %d workers.\n", env.workers);
-- 
2.43.0



