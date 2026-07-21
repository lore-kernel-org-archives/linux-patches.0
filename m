Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427D346D0AC;
	Tue, 21 Jul 2026 17:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655302; cv=none; b=clt0rTwGW6+97xkOjDe8h2PnSt4gsyUbp4oKXz41hlV+ahBWr3Er7Rg9v3XfVOix1NCsmhEqzQ+DnXXh3KYzQQVYlk3WOXhLgdMeVj35cetZ7DZPfdWB2g0DNPNqr8wDSf9DpN8MU62YzbIZ0QO+3iWOz3V2f7qOGXCB0uJQ7UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655302; c=relaxed/simple;
	bh=aN2VIH719ISsP7C6B+yWWZn4IMR1ILQwys8d4eE0JjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGShi6bhwrOlNdJfBg57c8mLpCXsGl8p1R24x770aUlqx7H10b9Pyi4lJQnvjzmxbQjrb+PV707JoD9kSTTP19kNBc097Ylf3Y/Thi74SJydNAvSueQaMLYNmN0vL4jih3qH0n980dPlyoLr0ivwxu2kSH+SA82KxDSGaC6Vp4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3LpkCyG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3LpkCyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C4B1F000E9;
	Tue, 21 Jul 2026 17:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655301;
	bh=TarGPHJy1qiHSQYYI0WAHfYyn8vgqr6F0HdtESkTQ3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3LpkCyGVC4QQyhWTQ/W8yt5o/a5xViAOrRaGpsKJL/5O4TqPLCyruaZG8lORVoBo
	 eFm64LJC6NUWcAjoYEnZhhiIoby7YODaK4PuzOMCrMXHZ/t/i62ZkUKMCUo8ohQdqs
	 nxc3Xf7s4MbcuBplTNKmLqLEvwLpaQfKnr6GXSYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 1990/2077] s390/diag: Add missing array_index_nospec() call to memtop_get_page_count()
Date: Tue, 21 Jul 2026 17:27:43 +0200
Message-ID: <20260721152639.648405765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit b7577fe4c47a31ca7c99714c53244a44af03cdfe upstream.

'level' is user space controlled and used to read from an array. Add the
missing array_index_nospec() call to prevent speculative execution.

Cc: stable@vger.kernel.org
Fixes: 0d30871739ab ("s390/diag: Add memory topology information via diag310")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/diag/diag310.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/diag/diag310.c
+++ b/arch/s390/kernel/diag/diag310.c
@@ -190,17 +190,18 @@ static int memtop_get_stride_len(unsigne
 static int memtop_get_page_count(unsigned long *res, unsigned long level)
 {
 	static unsigned long memtop_pages[DIAG310_LEVELMAX];
-	unsigned long pages;
+	unsigned long pages, idx;
 	int rc;
 
 	if (level > DIAG310_LEVELMAX || level < DIAG310_LEVELMIN)
 		return -EINVAL;
-	pages = READ_ONCE(memtop_pages[level - 1]);
+	idx = array_index_nospec(level - 1, ARRAY_SIZE(memtop_pages));
+	pages = READ_ONCE(memtop_pages[idx]);
 	if (!pages) {
 		rc = diag310_get_memtop_size(&pages, level);
 		if (rc)
 			return rc;
-		WRITE_ONCE(memtop_pages[level - 1], pages);
+		WRITE_ONCE(memtop_pages[idx], pages);
 	}
 	*res = pages;
 	return 0;


