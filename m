Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F7C352080;
	Tue, 26 Aug 2025 14:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217753; cv=none; b=IxROW6IUxlqDgTM+9YnzgE4Zc7Y+mUPlQ5Jn/TxWTOhVsBnwIE09ZmaFR9+NyzEC387PaACl0z+XhWgQ4eCRi65LpxtLrqjsprgEBw+IQvUt3vC0hL4TpBwyAgay5wrAWp/pO6aUQHUTabuyDWYTc2e5co3DmrOvTdKRUalIbmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217753; c=relaxed/simple;
	bh=nUYe9XoljcbfyH83UU6TkWVNNP6cWuDXK6IWfMU0EM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfXhrPnzLiuMA9gNPLeCO0JzqIxZibJktIlr88i7p934eOxRj2I8e6GbcBttd6JQGvmJR4v/QN0F3hwe7DRHWfKlN2CkEpYZqOO+IyEOVZLhwotKLs6E2r0PV8Qb7r9iR2FWAxq2Ouj3gu/vao5dpjoD7yjfrGhrLttHQrpg4CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJJOgBa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJJOgBa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2265C4CEF1;
	Tue, 26 Aug 2025 14:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217753;
	bh=nUYe9XoljcbfyH83UU6TkWVNNP6cWuDXK6IWfMU0EM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJJOgBa9bDgWz+rG+u67vjzpF2DOlA5Ur2QQh2x+fhP6gW+orRpLqO2mJPhMgTNNf
	 pzjzeckOKmZJtDH7kpVLTGU6HTnsin/SpoOdLdQukElmbO5eMSztzIH/cXStx7xEEJ
	 Fhq5ZnHRxvti8CdZmL3Y5hi2KFCv0xpIqp6qRags=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/523] s390/time: Use monotonic clock in get_cycles()
Date: Tue, 26 Aug 2025 13:07:51 +0200
Message-ID: <20250826110930.863753146@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 09e7e29d2b49ba84bcefb3dc1657726d2de5bb24 ]

Otherwise the code might not work correctly when the clock
is changed.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/timex.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 588aa0f2c842..d0260a1ec298 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -167,13 +167,6 @@ static inline unsigned long long get_tod_clock_fast(void)
 	return get_tod_clock();
 #endif
 }
-
-static inline cycles_t get_cycles(void)
-{
-	return (cycles_t) get_tod_clock() >> 2;
-}
-#define get_cycles get_cycles
-
 int get_phys_clock(unsigned long *clock);
 void init_cpu_timer(void);
 
@@ -196,6 +189,12 @@ static inline unsigned long long get_tod_clock_monotonic(void)
 	return tod;
 }
 
+static inline cycles_t get_cycles(void)
+{
+	return (cycles_t)get_tod_clock_monotonic() >> 2;
+}
+#define get_cycles get_cycles
+
 /**
  * tod_to_ns - convert a TOD format value to nanoseconds
  * @todval: to be converted TOD format value
-- 
2.39.5



