Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF423A0B36;
	Sat, 12 Sep 2026 08:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201594; cv=none; b=j7oKxuZESnHQbjOJz6IvbYbb05jf4eLFxf60K413Jmpf7XLc9+2YJM3bzv4KYGlte+OBpkHk+sHIBdVv+orXzqTq60AU0ioLEY1oO6jKe5ep1OBuDQokipwImTILDmTYNtMeBAAm/wSSoNqACLSUQmdBgeHKYF+76qMVHOXaLmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201594; c=relaxed/simple;
	bh=hJJGvgy/ds3BVHYOh6utN7Q6mpgsUBdnSz2s/9NJ/1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ig4/NBtOiXZ1o6LqK4Z/P6MEaWnNATbtZ+/y/AnrLWuQM8bcV4eVx40x3gSTNY7QL+MQ8xnPx+oS9JHhILW/dqJa52gFoP/PzG5RuMYPnYrv9JuQu+gGKoEdHmZZ2KkSG7/o4El8bIiNmUwhILpHPIyXDJs2KPeyLhgqinoc3/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMaBXz15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMaBXz15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D02E1F000FF;
	Sat, 12 Sep 2026 08:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201591;
	bh=pIhSujPUkoANVkKRKlmCIWWPEX33cK+Ci58wf6B9zKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMaBXz15qMMkLY3VEEoYsf0xhptwxndb5DtoOEMrjY25KfGhRAVkpGuCj4oI3zuY/
	 fhNpdz3fhxi+1ELELU96rgPFz6ji/L/P5KFT2CjmV5ZdOOo47OufuQNvd6QkhNAFE1
	 zKh5nr8ucDRbc27LAhPuPq8t8W32BHPdz3Zv6JUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
	Joe Damato <joe@dama.to>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1027/1815] phonet: pep: do not write beyond optlen in getsockopt
Date: Sat, 12 Sep 2026 08:46:17 +0200
Message-ID: <20260912065713.128857897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 77e5eb0e192aec6710c03ca8144582fd2af36ca4 ]

pep_getsockopt() clamps the reported length to the caller's buffer with
min_t(), but then stores the value with put_user(val, (int __user *)
optval), which always writes sizeof(int) bytes. A getsockopt() call with
an optlen smaller than sizeof(int) thus reports the clamped length yet
writes a full int, one to three bytes past the user buffer.

Write the value with copy_to_user() bounded by len, so at most optlen
bytes are copied, matching the length reported back to userspace.

Fixes: 02a47617cdce ("Phonet: implement GPRS virtual interface over PEP socket")
Acked-by: Rémi Denis-Courmont <remi@remlab.net>
Reviewed-by: Joe Damato <joe@dama.to>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260729-getsockopt_phase4-v4-4-c44576757c17@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 31b29e3ca7bc6..e188c563ee5b0 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1117,7 +1117,7 @@ static int pep_getsockopt(struct sock *sk, int level, int optname,
 	len = min_t(unsigned int, sizeof(int), len);
 	if (put_user(len, optlen))
 		return -EFAULT;
-	if (put_user(val, (int __user *) optval))
+	if (copy_to_user(optval, &val, len))
 		return -EFAULT;
 	return 0;
 }
-- 
2.53.0



