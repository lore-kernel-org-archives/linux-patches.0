Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6E6140E3D;
	Thu, 11 Apr 2024 10:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830871; cv=none; b=Wrg1jLEPn4aeS8I6oVgWeSeV1xhWnvQSdVgUTJyuepUjXc2/Rh+MuX9CFhpUs/3dwYZJvhqfZnoGFXShCmueJVCkydawWuTMmRSa1CwTVwgBHS3ezNdUPbw9hnmoa8Ig6O4SrEc8NV4QRq4iSiJ6p+3/ZFJHPyE/Ynola0FTWJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830871; c=relaxed/simple;
	bh=a+KAwO2c0oblO03QyxcYcF4reJ9IrvQLQf0o4XNpQCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbZxKNYoreCEpbh1XxJaD26TlzoLsroIYkNiS6R2cH+W7XJJP2WKsLa1rIIpaJ2Ab3iM7I7bxT2/teDZX9c1k++M7DPM/29/i1r+83lR2EE+78Hjv9UY8VjW/8CruAlGFMa2zaz2oR5ogxQUbUIcKMF7ipOQJ0l90cr5Xf0gu7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=db97o5s5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="db97o5s5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4593C433F1;
	Thu, 11 Apr 2024 10:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830871;
	bh=a+KAwO2c0oblO03QyxcYcF4reJ9IrvQLQf0o4XNpQCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=db97o5s5gH9ldEVDcmESkiK1H54fzKmD0sg4/K+HSKKwksZzuSm1Wa/QuzWyElTu6
	 1LEnfVEscmDEJc6HPLhPc35CZUZFPw8bFB6VggJTH0cyb9TNTaqdMETe76AVA8Cgzf
	 oPRoWru+yiRvp6DiCUfdsaMAnOKCyQx+H1c7eaDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 109/215] bounds: support non-power-of-two CONFIG_NR_CPUS
Date: Thu, 11 Apr 2024 11:55:18 +0200
Message-ID: <20240411095428.185358693@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit f2d5dcb48f7ba9e3ff249d58fc1fa963d374e66a upstream.

ilog2() rounds down, so for example when PowerPC 85xx sets CONFIG_NR_CPUS
to 24, we will only allocate 4 bits to store the number of CPUs instead of
5.  Use bits_per() instead, which rounds up.  Found by code inspection.
The effect of this would probably be a misaccounting when doing NUMA
balancing, so to a user, it would only be a performance penalty.  The
effects may be more wide-spread; it's hard to tell.

Link: https://lkml.kernel.org/r/20231010145549.1244748-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 90572890d202 ("mm: numa: Change page last {nid,pid} into {cpu,pid}")
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bounds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -19,7 +19,7 @@ int main(void)
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 #ifdef CONFIG_SMP
-	DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
+	DEFINE(NR_CPUS_BITS, bits_per(CONFIG_NR_CPUS));
 #endif
 	DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
 	/* End of constants */


