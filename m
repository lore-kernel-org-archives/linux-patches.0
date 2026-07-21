Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE45233AD8A;
	Tue, 21 Jul 2026 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658911; cv=none; b=kJ9uRHxKj0LcNLCpnKx7zMytMD32LrKAct7rMvcO3vhB8coGfGI3m2WanDDgTC2q4lVFtB0GTfcDWRvhMgoUP1ab/ftVGdpd0R9pQsRiyp/oooJ9e+rWdv3rRYew6QQkLeD/MrFh9gK0lpe8wJnuWuyP/k48y+LeFLD6OcwNqHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658911; c=relaxed/simple;
	bh=QsZkjPTXgyLR9GKfZ9b7WuyrdJnYrDKYwJJllifwBds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7G+79J22OvLbboB/l8rum7rTvsuUyqpjz9udesxswZuoVe2PZ/lw/ZUhC9Fa+TsaE+twjLSdQ6IovWzr00TNaC75Ay+47U8JfAbaNJw2Y/sl6ZFyk54XRWFvM+u//lR3Z5IOW/6iIs5LY3/DlC7WkQO7LpreebaIHiBythOJEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcp/cvTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcp/cvTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDA41F000E9;
	Tue, 21 Jul 2026 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658909;
	bh=CwF9uSTPrzV/Pjnr/coW6lj0tjEDh6DGFHS8r50lmqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcp/cvTIylGYOF1MR7kecTgieo4AUXrVqdBi8nN4TdG0QqFOArGphboivWqbfZ7Kn
	 jLCBFrgc1UzFLuink1xJMZujZc3KJReChdx+7Lj8o7ddSqhRsrRG0Nhmv+3vPoAUBD
	 LmxngL+wtBAWD+rsMadYG1ftDnxk2Jh3J2vfQzvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.18 1322/1611] time: Fix off-by-one in compat settimeofday() usec validation
Date: Tue, 21 Jul 2026 17:23:58 +0200
Message-ID: <20260721152545.192628619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Wang Yan <wangyan01@kylinos.cn>

commit 269f2b43fae692d1f3988c9f888a6301aa537b82 upstream.

The compat version of settimeofday() uses '>' instead of '>=' when
validating tv_usec against USEC_PER_SEC, allowing the value 1000000 to pass
the check. After the subsequent conversion to nanoseconds (tv_nsec *=
NSEC_PER_USEC), this results in tv_nsec == NSEC_PER_SEC, which violates the
timespec invariant that tv_nsec must be strictly less than NSEC_PER_SEC.

The native settimeofday() was already fixed in commit ce4abda5e126 ("time:
Fix off-by-one in settimeofday() usec validation"), but the compat
counterpart was missed.

Fix it by using '>=' to reject tv_usec values outside the valid range [0,
USEC_PER_SEC - 1].

Fixes: 5e0fb1b57bea ("y2038: time: avoid timespec usage in settimeofday()")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260622103348.120255-1-wangyan01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -251,7 +251,7 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, str
 		    get_user(new_ts.tv_nsec, &tv->tv_usec))
 			return -EFAULT;
 
-		if (new_ts.tv_nsec > USEC_PER_SEC || new_ts.tv_nsec < 0)
+		if (new_ts.tv_nsec >= USEC_PER_SEC || new_ts.tv_nsec < 0)
 			return -EINVAL;
 
 		new_ts.tv_nsec *= NSEC_PER_USEC;


