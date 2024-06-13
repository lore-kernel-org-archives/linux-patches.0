Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C0C399;
	Thu, 13 Jun 2024 12:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281834; cv=none; b=SDaMbhQWSl+VB4W0U3HelhEh7ub5mhNg6SVOAmdYA8VZReDlFMyB13cmX0Jx8XUbV92M8UJrRuKMS8C/P6eD3gSY+hhGjKLkxtdkLQj4SiBKZVmhI33BbgyqF3rg4k0RTdwOWKDorSR6mnNOGkPSHyvrm6O6ND30UxBS7PWlfZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281834; c=relaxed/simple;
	bh=P5GkESFmeAmDEfIEUNtw6WhHPA8yeclbkzDnSNPF6Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rx/CE4DCR6gUoSJ5h9fQ/oLRyXZ9FeFWLzA5WlGYRHoztBldOrrQuvTminHGPtD8mvqeKXHLby3jTGoPPKHqKRDZBh2kY236vgCYJp+12cDiPAiMxBLxm2FaIknwkJBjh3WFeviUFL2xR6sFtsA4mDTO3RtAhwdnQPKeB7+UfrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwYVpUlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwYVpUlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9C7C2BBFC;
	Thu, 13 Jun 2024 12:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281833;
	bh=P5GkESFmeAmDEfIEUNtw6WhHPA8yeclbkzDnSNPF6Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwYVpUlb+ltdlrA7JIumvCjUAadCdl689lsw3si/AbKveeaSiIngmCMMoYMHCZX0d
	 3AHaDcyROQuRPH9kew8DVCO7NR+hsAp7Io/DUOh7ei5AC9stWhfXcHW4O5N3PGtVnP
	 +7PhOZj2vcX9C3bQgOrySmOkvJchEmlkwO3a910E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/402] selftests/bpf: Fix umount cgroup2 error in test_sockmap
Date: Thu, 13 Jun 2024 13:30:28 +0200
Message-ID: <20240613113304.907304748@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eefd445b96fc7..7465cbe19bb08 100644
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



