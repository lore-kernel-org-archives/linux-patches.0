Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9209D1FBEA6;
	Sat, 12 Sep 2026 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230711; cv=none; b=gVVWw4A0RSOl7zfvITvsHDTtksdBNHGuIhe9h1l9zzL1yF7/9n3xiUR5MBE3IsD3alMmUQQ8QuG08gjDC6ZrGPkfT+nPnU4tIZiLY4MRx/6nw0RqjPVTTeXC2RtUcrfjPxa3jTesMiaMRP7gCQ5mf+reOhMpSYcYF4pjbYrOuZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230711; c=relaxed/simple;
	bh=W9OQJVgljgG9c0nDxFsgEmpO+yZ4saEWztoIwXaHwzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u8t+qCaTMbLp9fiiMMDsMmTLkohkaYM6u0mzg3Rxu5l5sGob8zZavgFhrUs2RsYDCdkSNOaGgZkc0FiPyehN5Q1TgtLGxcUJq2tiCcZhGykG+LEnuSZfyvy28fBgnlAIvi95H81+UV9HQDopKKS61C7tX4+G9uPz8V/J6nqCyEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVBi4Wh+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVBi4Wh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970E91F000FF;
	Sat, 12 Sep 2026 16:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230710;
	bh=g4CbQbc47wdydZT8mHshsVOh1hUL9zzRy3yHcsOAiKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVBi4Wh+j4BiOIjAuJQmTyj8MZLdOKgulWDPUkUlj/ip57EODp+WelZCiVlR34Xpc
	 MDHEITe/OVYtm+pfNSoCFrdvdm78pbJP659XZZBaPNmuN81zLz7TO1OCoq2t67X57T
	 zaccDboWCLiH/sqO242SZjx1BbWM8KX42DRV0QiY=
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
Subject: [PATCH 6.1 0850/1191] phonet: pep: do not write beyond optlen in getsockopt
Date: Sat, 12 Sep 2026 08:59:38 +0200
Message-ID: <20260912065607.346851439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f10979598455..bbc7ad77a5d1d 100644
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



