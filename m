Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF3033F8A1;
	Thu, 12 Mar 2026 20:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346775; cv=none; b=Utl2AASADBn9MYXRcYSwpd+kjze9AgWdUfpSIHuIOqYVjHYGVO1LWWUEqtWAe/XsJeXvEKiUH7S0wwApXVqprgIJ2mskZuGLSa7kNu2CFRyR0toOrl7BBXQQthXfCPpKQHc38wMasJgwa7dVh0NYjNBg9BtnbVo4g5j8DeAqOI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346775; c=relaxed/simple;
	bh=6aSl9qaR0U5BpAh58lRyk87ACIiyTZVLArmZoMyZTrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGoApCPcKhSljJhDfZ/aS0lujcbPwDOaxdYA+m3a2adnq5befHtqD01h8b+sohbJPpYHX+jrypvnKogUM6lyoMYNIz1rIH4BU1FAN2LKDOS8peH9faSnYG/FQ24Uto0kJvHzo7U5oTw1y7s/3dLMOpGGnhQdHGNzhbsNJFQFXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXHa1JOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXHa1JOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5088EC4CEF7;
	Thu, 12 Mar 2026 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346774;
	bh=6aSl9qaR0U5BpAh58lRyk87ACIiyTZVLArmZoMyZTrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXHa1JOEeJMQMJUKa3RtsuyU2QIybUBLU9TweON1MaS6HTPrVzVgAnuJPwvooOpNO
	 y8P90AIfZWRRAwdxuTg0s/8ApTJI7NyoJatm+QHlTEy3vIycyIB2tjbo67fTir5Mfe
	 KmQ3dDwM9x2FfJgka+HddSwOW2659wbGrVAxpebo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/265] ima: kexec: silence RCU list traversal warning
Date: Thu, 12 Mar 2026 21:07:55 +0100
Message-ID: <20260312201021.399423918@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 68af44a71975688b881ea524e2526bb7c7ad0e9a ]

The ima_measurements list is append-only and doesn't require
rcu_read_lock() protection. However, lockdep issues a warning when
traversing RCU lists without the read lock:

  security/integrity/ima/ima_kexec.c:40 RCU-list traversed in non-reader section!!

Fix this by using the variant of list_for_each_entry_rcu() with the last
argument set to true. This tells the RCU subsystem that traversing this
append-only list without the read lock is intentional and safe.

This change silences the lockdep warning while maintaining the correct
semantics for the append-only list traversal.

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Stable-dep-of: 10d1c75ed438 ("ima: verify the previous kernel's IMA buffer lies in addressable RAM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_kexec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index 52e00332defed..9d45f4d26f731 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -37,7 +37,8 @@ static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
 
 	memset(&khdr, 0, sizeof(khdr));
 	khdr.version = 1;
-	list_for_each_entry_rcu(qe, &ima_measurements, later) {
+	/* This is an append-only list, no need to hold the RCU read lock */
+	list_for_each_entry_rcu(qe, &ima_measurements, later, true) {
 		if (file.count < file.size) {
 			khdr.count++;
 			ima_measurements_show(&file, qe);
-- 
2.51.0



