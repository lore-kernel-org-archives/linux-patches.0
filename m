Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F36392807;
	Sat, 12 Sep 2026 19:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242984; cv=none; b=LM57fpIPIo/np+LR3QkFXP+qpCIK5UZZZCI8YOpDIMeB8IbT5MAA3/K+7uTfh9pTy2aSi3UWF+jWOvfaXjZmKUJ5trdHH0TDTkxYZuQTTlBqqJmBWMIAmJgdsvDexH/B9KYZK2+XbQjnHiyvB0x4a/aEB70DGe6LKlucdED41vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242984; c=relaxed/simple;
	bh=x3eCD5WtD3fhhBVvH7hhLVeoy4yL784+OZXJqpJ7THE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dY/begPVBwuJQGuHHrSwoAHVL0H9MLTpzt2jOfKadEWLYQqlC72gv8msmiRFWSHwu0ka50g6ZwjayRrHiFYT2sve1XwGHkKHunyCr7spPy7D6jl5x7i3i706ASAm/lxJlRMYBUIgagVvXNm2MbMEJV75u0nBNukv7q445DEBfHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJQ4ArWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJQ4ArWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AB11F00893;
	Sat, 12 Sep 2026 19:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242978;
	bh=SO0hK9T1JGZR4YuXbN4xqLbGB5t9kaOcKIwxgfokaOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJQ4ArWGSfcVmIE1rSL8Okk7GMTExnC2p4E/YH4xzhoxAZNlK+up7pPeHoS1Iezui
	 lG0roR/O0qCjeRnMNI0CpV75WV+c9S5ufunefG5YnqXExi9TY9b+UHhlL/5TxmLN5d
	 YeA2YqLpZXDNLJyIT0RuCgGsffrs5J9D5f4upUsA=
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
Subject: [PATCH 5.10 593/798] phonet: pep: do not write beyond optlen in getsockopt
Date: Sat, 12 Sep 2026 09:03:41 +0200
Message-ID: <20260912065530.717418567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cac9631bd84ac..17f12911dba35 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1093,7 +1093,7 @@ static int pep_getsockopt(struct sock *sk, int level, int optname,
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



