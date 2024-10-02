Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9229B1D0798;
	Wed,  2 Oct 2024 14:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879641; cv=none; b=LdxG1ghrCc5SNhyCMEPPaMdTsDnCgsYhP6i9T3WUBIBRVo7JaJq9QsLgtE+NAZu2iT5mVoH7dgUntezLg70frNDPK341w/izDmtrxCtj3RiU23lNeMRH90b2LQ5tnRaw6pIAy0Cbt0iHch/7KyVtl6yOOknzyOoF9ZqPV874ds4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879641; c=relaxed/simple;
	bh=RnvFokTWw7OYiloyRaDgnV0Sd7zk5i/6k9TFy5hg6ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAJNCEaNf3PajBsdpw7KaCAOcfAcR2ynnTKaStms3P21RSvjZi0+AbhQ3fnJwiGkiqn6QOS5SnrBmao8ul0hyfX16C+fi7UGc+o2GPc7aZDMLSIECNn7eDnBu2XnzTOhcDL/uXBM5GpqqbyFZd4aa7ILMYNoToT/gWXN37jHKiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQYgMScv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQYgMScv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF49C4CEC2;
	Wed,  2 Oct 2024 14:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879641;
	bh=RnvFokTWw7OYiloyRaDgnV0Sd7zk5i/6k9TFy5hg6ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQYgMScvSN4il66syQD7cEc7KCK2ZvPxom2hgfDhMDsiNvC70PpPn0n+Zefuh7HyP
	 7tIzelY+DW3EWcuwL8I7f0kyR4pE0/F935kPZ3ap6KSPsqPXV0pv4iTBvHEvvjBZj7
	 eH9iYcY6Rw8yLgwp2Jj281lnRUHYsWsLePNIFeCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/538] selftests/bpf: Use pid_t consistently in test_progs.c
Date: Wed,  2 Oct 2024 14:57:07 +0200
Message-ID: <20241002125759.679639813@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 4d582cac2c09e..eed0e4fcf42ef 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1690,7 +1690,7 @@ int main(int argc, char **argv)
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



