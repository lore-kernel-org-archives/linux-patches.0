Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA042E1C7C;
	Tue, 31 Mar 2026 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976724; cv=none; b=Hk/mPuvefKFE94otfq6Jb/VvlfGtZ2lDhizVLczB5wd4gOa6HpKrv+bfSdm/cHl85JAvqzNZ47FZVg7+Upj+T4P6US7mUE11YrNxu87nnc/N9YzEY9wGMt+WCS3K0F7FJHsJTKQeCzxCARdga7fyK3G23PfnYWERSHK8u4s3p3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976724; c=relaxed/simple;
	bh=dqvKDYGK3amAy0ZZvxpXPIQ/6nuLc/BNhDNwAI8kGXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0+oJMmu16N3T2dah+42dzTRJSC6wxLpa5xa2utOkhtrGMRfG3PtvqbJTdURuFcdHWh9cHC24kxAVJOm7N4sJlZmVaMpGLhMcXlVnn9Xu0miwUW0DZfakSkut065AsoDJzKwXuPcwAgBFoJFdKZaBifp7OPtFkCz8DLxYDKPGA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihjtDtHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihjtDtHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122F6C2BCB4;
	Tue, 31 Mar 2026 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976724;
	bh=dqvKDYGK3amAy0ZZvxpXPIQ/6nuLc/BNhDNwAI8kGXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihjtDtHeUuZXXCppaVJzSe2wUDMh4y3+nX10DlYeDpypNzddNZstYaH+dh0IrgjCx
	 7zHbur9ye3UUgh1MrdXYH9fS2IvITjogLa6WXRapNslx9VHPWItYkw50kPr9O6vWYT
	 Okipud6JdHa8Z5o0zkEKUhglS08JLDBQFBMt8kD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Buerg <buermarc@googlemail.com>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/309] sysctl: fix uninitialized variable in proc_do_large_bitmap
Date: Tue, 31 Mar 2026 18:21:13 +0200
Message-ID: <20260331161759.724567146@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Buerg <buermarc@googlemail.com>

[ Upstream commit f63a9df7e3f9f842945d292a19d9938924f066f9 ]

proc_do_large_bitmap() does not initialize variable c, which is expected
to be set to a trailing character by proc_get_long().

However, proc_get_long() only sets c when the input buffer contains a
trailing character after the parsed value.

If c is not initialized it may happen to contain a '-'. If this is the
case proc_do_large_bitmap() expects to be able to parse a second part of
the input buffer. If there is no second part an unjustified -EINVAL will
be returned.

Initialize c to 0 to prevent returning -EINVAL on valid input.

Fixes: 9f977fb7ae9d ("sysctl: add proc_do_large_bitmap")
Signed-off-by: Marc Buerg <buermarc@googlemail.com>
Reviewed-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index cb6196e3fa993..970525e6c76c7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1213,7 +1213,7 @@ int proc_do_large_bitmap(const struct ctl_table *table, int write,
 	unsigned long bitmap_len = table->maxlen;
 	unsigned long *bitmap = *(unsigned long **) table->data;
 	unsigned long *tmp_bitmap = NULL;
-	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c;
+	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c = 0;
 
 	if (!bitmap || !bitmap_len || !left || (*ppos && !write)) {
 		*lenp = 0;
-- 
2.53.0



