Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4331037F8C2;
	Wed,  8 Apr 2026 18:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671941; cv=none; b=QyC6YqJwHnCrca6L8wxtEM6E5ZKYMxzc5UT244TG2xzug767x/kmUutF+XevT59JVl/plVjZE/PuhniNUeyy5Jger82OAt7bdG9pEyXQR+crj8/K1tTc4AfRelw5cf6/ORuz30lFclSlJoRuWRyJuMttpzklwmRnFAAL2ZEfjjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671941; c=relaxed/simple;
	bh=etKYE3H1lAeK+Oofau7btOMdt8TomGZxWdar9lP7UT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7+Nw8+4NR2gEfn9r/QxB30kCzgpPAULrQ3L8Vz8nU4PHhv8xV1qH7q4XgBxsBdm6YokMHXozgDGW5W+ehRaMGKpvDwuxK0QDfiSU13TZadg7A5/ipa8FmhGwm6tid/SibGMZABovE/1PTL+3NnCi5G/H4Y6/BuzOKEv9U+ChWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1w7kHPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1w7kHPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD37C19421;
	Wed,  8 Apr 2026 18:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671941;
	bh=etKYE3H1lAeK+Oofau7btOMdt8TomGZxWdar9lP7UT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1w7kHPUk64HumdpVCaK6W6FKBjJQqE9qd+cPwVmmuB2vEwD++pBZ8FKFR/xXjKPG
	 pV+rJwOzxk62vk9A55bdOEVAI+XYT4z86wjTErjsrdeaHqYT3vnSFdGkuP1Nm0tkPn
	 VO0xgzNdXSGmFtSyAKNbgGwzGQ6JjVOM4SdSVmW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Buerg <buermarc@googlemail.com>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/312] sysctl: fix uninitialized variable in proc_do_large_bitmap
Date: Wed,  8 Apr 2026 20:00:02 +0200
Message-ID: <20260408175936.920353298@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c6d9dec11b749..eaa2691caf492 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1391,7 +1391,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 	unsigned long bitmap_len = table->maxlen;
 	unsigned long *bitmap = *(unsigned long **) table->data;
 	unsigned long *tmp_bitmap = NULL;
-	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c;
+	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c = 0;
 
 	if (!bitmap || !bitmap_len || !left || (*ppos && !write)) {
 		*lenp = 0;
-- 
2.53.0



