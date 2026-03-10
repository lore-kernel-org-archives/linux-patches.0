Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A57387571;
	Tue, 10 Mar 2026 11:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141259; cv=none; b=cdrfSHr2ma9VC+WuR46zVTXg7kGLfIVf/82s1j5n4XcPcGX/6/jkct3Ktfa+uerjF+aNU6KG/esX0AipEjd6j/H0wa0XzZacmQfkKn1g6LWfikV0rPbWEh4ofXPFGyqNte7wPWv5l8IJoMTgJBAlSR+NYpFtKDSeVSZEb0maQzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141259; c=relaxed/simple;
	bh=2xp/x2edd+uKlcVu1F6ZJ0E5h7ZjvaxReS72594TdkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgPn5Ajrc0QdSm6AAN/tojBGZ6O8oKCYoDQ8i8vDUyj+fF1Zik9ZAI8qQmsYGPfmmPs46Inj7L1DJq6pq0Ie+y4XnKheXYKurUXfcQ439T1hvz5+bbKAe5elppWuxW+0uWP8fonvEk5/XL0xs4JNcibfAKJRNyIbTRPM0adbRzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcGMRF+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcGMRF+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F44C19423;
	Tue, 10 Mar 2026 11:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141259;
	bh=2xp/x2edd+uKlcVu1F6ZJ0E5h7ZjvaxReS72594TdkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcGMRF+xJZz4yDTlgPuoyYEwe1ibEd8ZwgiOwyiQLU5lZfxuyubtj8kGTQ0tK4sNb
	 jteAcnyx3/ENgsmA6q/0JP/HSE0Jm1dU+oejdrt0kbcogphjUDHQRAn5uj2frrumkN
	 bNQfZXHpErhxsYwKew2xzLTAG4Ls9En4PenxLimpg/4+/6B3p4jhbnU+9IRkJVt+p8
	 NrcBXim6/BQYQRYcxIw5BUu5JNNjQqGaqaLgeHYE8bcKwWO/s6h31ZPCDXLUJYCNFb
	 jxj7zRco4pWm3Gh2TlLgtXapJhPepb4z1jkPW0Q4hhYRAPxhB7ThN8nStjuWj4x/4c
	 VZSBvMuUUcNpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gerd Rausch <gerd.rausch@oracle.com>,
	Colm Harrington <colm.harrington@oracle.com>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 262/311] time/jiffies: Fix sysctl file error on configurations where USER_HZ < HZ
Date: Tue, 10 Mar 2026 07:05:09 -0400
Message-ID: <2f6f88eeeff8bbb04a9378d0f3696315eaaad334.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit 6932256d3a3764f3a5e06e2cb8603be45b6a9fef ]

Commit 2dc164a48e6fd ("sysctl: Create converter functions with two new
macros") incorrectly returns error to user space when jiffies sysctl
converter is used. The old overflow check got replaced with an
unconditional one:
     +    if (USER_HZ < HZ)
     +        return -EINVAL;
which will always be true on configurations with "USER_HZ < HZ".

Remove the check; it is no longer needed as clock_t_to_jiffies() returns
ULONG_MAX for the overflow case and proc_int_u2k_conv_uop() checks for
"> INT_MAX" after conversion

Fixes: 2dc164a48e6fd ("sysctl: Create converter functions with two new macros")
Reported-by: Colm Harrington <colm.harrington@oracle.com>
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/jiffies.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index d31a6d40d38dc..11d09cd8037c5 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -162,8 +162,6 @@ EXPORT_SYMBOL(proc_dointvec_jiffies);
 int proc_dointvec_userhz_jiffies(const struct ctl_table *table, int dir,
 				 void *buffer, size_t *lenp, loff_t *ppos)
 {
-	if (SYSCTL_USER_TO_KERN(dir) && USER_HZ < HZ)
-		return -EINVAL;
 	return proc_dointvec_conv(table, dir, buffer, lenp, ppos,
 				  do_proc_int_conv_userhz_jiffies);
 }
-- 
2.51.0

