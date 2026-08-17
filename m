Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D3A3D5C07;
	Mon, 17 Aug 2026 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980389; cv=none; b=JG5z23x+XAO6yB1z1lWJ+lUe0qUBXfVwf/8XCjB8It2/MCIbb5koL0V382SBp8p32lfPaSiRp+PvmUsDvt82i2BdMiHfjSoY2y2v/UVykL7YhF21YjYpqLZsTJHlOQDhvF3EpccVxpoSo95NgoPANFXNVm5DqpPb5Sy/YLlwM2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980389; c=relaxed/simple;
	bh=RqzIXxkjkVMircxgOHCE0aCXTlQKdHQC6iE7oxpEix4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvZR/qMMr8zVU7fVthfidN0veOkAGLLQRmlzQS3PXAErgfnW0vp/T5+kXhDS7JMpR5IeyoTb+kp25QCm18K9NL9AX2T1j8tVFAbgT7SP9kKsgXxUfFsfDjcsVm96ciIGMrN2E0uZrXbkuBr74Ci7klnx7sCFdNz/myUYaDpjqyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vkatoe3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vkatoe3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFC11F00A3A;
	Mon, 17 Aug 2026 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980388;
	bh=phouA+ugPyEa6cH2Uac3aTvRrIrF7P3xDx08cvl7bus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vkatoe3wSVJgxIz5aJhjiZMVzH4VpK4V1+jwGfVYTAkVnez1UvTUhbZNboXaWNwR+
	 RmTiYrkPYVXgWMVSX/nsi5cm+jOxUbLbf636R9o6ap1OoSWz7bsU8F/DUmaOQxf1U+
	 /kOf3Vy/apEjSOB/6cj/lfIC9z/SUpB7VG5bQ66U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+53ecc09fb81df10ef4de@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 529/609] net/atm: fix slab-out-of-bounds read in vcc_setsockopt()
Date: Mon, 17 Aug 2026 15:33:45 +0200
Message-ID: <20260817132601.496251375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d0c80dbb970439bd2eeb0e5effff8c16a5f4e1e3 ]

vcc_setsockopt() contained an ineffective optlen check:
  if (__SO_LEVEL_MATCH(optname, level) && optlen != __SO_SIZE(optname))
      return -EINVAL;

If __SO_LEVEL_MATCH(optname, level) evaluated to false (e.g. if the caller
passed a mismatched level), the length check optlen != __SO_SIZE(optname)
was short-circuited and bypassed. Execution then fell through to switch(optname),
calling copy_from_sockptr() assuming optval contained sufficient space.

Furthermore, even if level matched, a cgroup BPF setsockopt filter could shrink
optlen after entry. Because copy_from_sockptr() on kernel pointers uses memcpy(),
this leads to a KASAN slab-out-of-bounds read when optlen is smaller than the
expected structure size.

Fix this by using copy_safe_from_sockptr(), which unconditionally validates
that optlen is at least the expected size before copying. Also change the local
'value' variable type from 'unsigned long' to 'int' so that SO_SETCLP matches
its sizeof(int) ABI encoding on 64-bit systems.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+53ecc09fb81df10ef4de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=53ecc09fb81df10ef4de
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260805131508.3227331-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/common.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/atm/common.c b/net/atm/common.c
index 96f680a45e306..f3f68c231935a 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -760,7 +760,7 @@ int vcc_setsockopt(struct socket *sock, int level, int optname,
 		   sockptr_t optval, unsigned int optlen)
 {
 	struct atm_vcc *vcc;
-	unsigned long value;
+	int value;
 	int error;
 
 	if (__SO_LEVEL_MATCH(optname, level) && optlen != __SO_SIZE(optname))
@@ -772,8 +772,10 @@ int vcc_setsockopt(struct socket *sock, int level, int optname,
 	{
 		struct atm_qos qos;
 
-		if (copy_from_sockptr(&qos, optval, sizeof(qos)))
-			return -EFAULT;
+		error = copy_safe_from_sockptr(&qos, sizeof(qos), optval,
+					       optlen);
+		if (error)
+			return error;
 		error = check_qos(&qos);
 		if (error)
 			return error;
@@ -786,8 +788,10 @@ int vcc_setsockopt(struct socket *sock, int level, int optname,
 		return 0;
 	}
 	case SO_SETCLP:
-		if (copy_from_sockptr(&value, optval, sizeof(value)))
-			return -EFAULT;
+		error = copy_safe_from_sockptr(&value, sizeof(value), optval,
+					       optlen);
+		if (error)
+			return error;
 		if (value)
 			vcc->atm_options |= ATM_ATMOPT_CLP;
 		else
-- 
2.53.0



