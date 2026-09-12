Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F382D0C94;
	Sat, 12 Sep 2026 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212848; cv=none; b=br999LDyKF4l2qXi7L/Ihr6eEYTJFHwJWiEpO5tcFCIs7aiivUZE3kTSmstk50QMZweWx7yhbc/q19lf2VnNoIDnuXUCSJ1snLfgWzdUjoercBCXKjLbVhfSBeF0ZX7+OHHZLx4KPkKpn68dV2jDTX+K26OAzGndlSArmrzKugo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212848; c=relaxed/simple;
	bh=jF+On38/eBpCFTGLYZh6car61Yx9zld45rv9mAhZ+8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSIzFsQpgB3Wu6pptSpjGeAukhpornqwLLUfIw7SeXjXoL1FFk+zENrc5z1irhXFq7lBqeNm681AOZ4b0+HtiNZre3yQXeOBbXy0xCOnMwWKhT0GWAZetWsoPj4Uz/c6Ddiaw018HZE+za8l9/mzKURXNfvV+SPw4qgmm52UT1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHWkz97O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHWkz97O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F5C1F000FF;
	Sat, 12 Sep 2026 11:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212847;
	bh=kdjQjOSiMaG1mi62zd/EA2UmUPll7jSPwMC9vkcxNYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHWkz97Omd5ZHVKjqqaxa1aSdZ2lBJTmnwGFOS7TnkKNE3AKyi1DFd1xm+picJ41P
	 6u0AqxyTtrGLEv1RR6bvE9L4+urisuZsFEq8HL4jloX1JlCnByhBls38NIDPixIPzU
	 jj3ja6xROxA6cZgRGzXqq+/LHQttQ9OaGq6ZM76s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Dubrovskii <nikita@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1476/1518] s390/kexec: Disable stack protector in s390_reset_system()
Date: Sat, 12 Sep 2026 09:00:45 +0200
Message-ID: <20260912065656.946328044@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 1623a554c68f352c17d0a358bc62580dc187f06b ]

s390_reset_system() calls set_prefix(0), which switches back to the
absolute lowcore. At that point the stack protector canary no longer
matches the canary from the lowcore the function was entered with, so
the stack check fails.

Mark s390_reset_system() __no_stack_protector. This is safe here since
its callers (__do_machine_kdump() and __do_machine_kexec()) are
effectively no-return and fall back to disabled_wait() on failure.

Fixes: f5730d44e05e ("s390: Add stackprotector support")
Reported-by: Nikita Dubrovskii <nikita@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 0068d824306f6..2d01a17139387 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -2378,7 +2378,7 @@ void __init setup_ipl(void)
 	atomic_notifier_chain_register(&panic_notifier_list, &on_panic_nb);
 }
 
-void s390_reset_system(void)
+void __no_stack_protector s390_reset_system(void)
 {
 	/* Disable prefixing */
 	set_prefix(0);
-- 
2.53.0



