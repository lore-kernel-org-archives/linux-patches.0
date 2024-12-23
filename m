Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAB619E98B;
	Mon, 23 Dec 2024 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969755; cv=none; b=LgKELHCjgjAT4pnh0Q9RihqncnTkaqcv0YG6k7Lwfm9UOaAYmZmPmq47BNxLKHxRp+JPW97WLrryGctBJBAI6bBNWRnNnlBIaRqpljaYJ37UQmz7JBvQmNlLIvg2XKtommG9kqWSceJK7zSejw0h84reM4C9dyRx2DAogT49dyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969755; c=relaxed/simple;
	bh=7uWsrmpULrGPdiaLJ+ujV/GhiO6sLhI4RDvyqPFhAXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMddGEOfGMjlI1/eyuebRHsBYooFLtDvBoU0hIyMudvYAwA/sDoUmvJqjXh3KzaZC63+xU5biO/MbSVmB9gmFrJwXGKzAGJotVcBbvEQ+K4pQ1+lSQCNqOMHRSfdnMVlfzpimCm/V9DbDXML6lyvJWSSRTJ8X0B/hYvx17C4S30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRNCKHiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRNCKHiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E0DC4CED3;
	Mon, 23 Dec 2024 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969755;
	bh=7uWsrmpULrGPdiaLJ+ujV/GhiO6sLhI4RDvyqPFhAXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRNCKHiOltR1zcELaR/v6F6enFz7gVXGyZGmMiA6yleNj8ocZp5okDB6QzJ0Bgetf
	 JaH1I8cwuim6uM3r6BUEqUKejzrwpw6d6Ujh4H5bx88bF8YmCVFsnN+Ce2JJHbue12
	 gJ8av8LBYQgnDVn5vMWJk2oEEUgDVT29W8CAJnYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/160] s390/ipl: Fix never less than zero warning
Date: Mon, 23 Dec 2024 16:57:05 +0100
Message-ID: <20241223155409.198227502@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 5fa49dd8e521a42379e5e41fcf2c92edaaec0a8b ]

DEFINE_IPL_ATTR_STR_RW() macro produces "unsigned 'len' is never less
than zero." warning when sys_vmcmd_on_*_store() callbacks are defined.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412081614.5uel8F6W-lkp@intel.com/
Fixes: 247576bf624a ("s390/ipl: Do not accept z/VM CP diag X'008' cmds longer than max length")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index f17bb7bf9392..5fa203f4bc6b 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -270,7 +270,7 @@ static ssize_t sys_##_prefix##_##_name##_store(struct kobject *kobj,	\
 	if (len >= sizeof(_value))					\
 		return -E2BIG;						\
 	len = strscpy(_value, buf, sizeof(_value));			\
-	if (len < 0)							\
+	if ((ssize_t)len < 0)						\
 		return len;						\
 	strim(_value);							\
 	return len;							\
-- 
2.39.5



