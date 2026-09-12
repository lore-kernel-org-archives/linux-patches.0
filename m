Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62F042CB17;
	Sat, 12 Sep 2026 10:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209631; cv=none; b=NgNl8iWf/gkqJip/WzcUU+2IK6V9+zqyVTx9x4xV2QAu2KHwPQ3Vk4byKUUqtYUJ5TVwEEhl2HJAy8yVxOLv0QDNS4byB94Zvczg5YNgUV5bQL3DhyiukJBPUp3YvC+lQPmOMnXZqlEQX9/aAZi6CWqqNfCxz4rRQeDLKvgOKxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209631; c=relaxed/simple;
	bh=ej3zmFYSgbf9akCiE6FMoMdADTtLyfzlnaMsOtiMkEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oU7sebqlob95dmfLuhH77jBLwBHRf0u9OxpFjfJRB+UVJ0C2/tqLmuJ539FqAXCZwad2BrAaq+Jw7VoakPxObJZNmieZtQ4oVRi1d7sUGA05uNEP6aU6gjRO+vzj9DBXRf68JiYLUS50Tlb2ba2J4Zcpa1mTPBNAkoAW59elzdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNUIMT6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNUIMT6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73341F00893;
	Sat, 12 Sep 2026 10:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209629;
	bh=M7+3gmbNBknqSx9l7e0D8tdNfHWY/gyR6g9LYPy056E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNUIMT6bJF9ZyPc4Y5YqGDmej1ga7G06FR+FG1a0Q2SSiATD1eEAqelsZiHWRuXVj
	 TdJeVxJsIkZg19As6KA+OuflrYZ74ILgM8LhhK1rXAZ6ponsXIK8jm54dW5PhDCsAV
	 i8RTrdNWz3EVPTtHa/PL22i27/wiREXCbxdk4EQg=
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
Subject: [PATCH 6.18 0859/1518] phonet: pep: do not write beyond optlen in getsockopt
Date: Sat, 12 Sep 2026 08:50:28 +0200
Message-ID: <20260912065642.882020037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5910dcd26555e..36c85811fd08b 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1116,7 +1116,7 @@ static int pep_getsockopt(struct sock *sk, int level, int optname,
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



