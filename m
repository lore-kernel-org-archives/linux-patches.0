Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AF5200D4;
	Mon,  4 Mar 2024 21:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589158; cv=none; b=jDYOXLdWKqO1GCzwRbDN+dbF3/hGOPN+q1mqPOcuXfcNaqzTN74f2cob67F4rfcSIN0gnNqlSCWCpTy6+3GlxyvxvjxVOSYuqpxGY3Hp92P8O64LquoFKGn+YD04tsDOaG5CryWdk2XGDjcM6ZdePoYiu92yICnbGNUdZk1hiKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589158; c=relaxed/simple;
	bh=LtqysbC8seZlfiMJLrVfwFofplIcSgb23mZV+z866os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF9DmjYnbeSE+KiOkjtdVd6S6IfKSTQl0hlnZ5pLx1CH9wNvZnEDD5Ks/jwcrMZuITB8FksrmsfG/B+Mg2tKNxLLv5LevU+SFp84pTmn3aYt0NJDUNE5jZywnP+g5XwrDRGszzvjHBBil192janmlEbDaJdNJOxJeZGdo+pV4kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOCg9k6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOCg9k6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06599C433C7;
	Mon,  4 Mar 2024 21:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589158;
	bh=LtqysbC8seZlfiMJLrVfwFofplIcSgb23mZV+z866os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOCg9k6NQfEbfh+O70WlZO8IkNHK5WFyXmlEstxc/AQ8Dj569CQfRgCBDnuM2FLFA
	 NWsgj1s3e1ddPL0Dt4GM5yIfIFs1/gtjwnpwjFcVWPwv1kPOzcL35Ae7jPPjJwvaDd
	 CxBQRGcMS7QMuNU852a7JJp3h/9JeaIFiagE+nvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ming Lei <ming.lei@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/215] block: define bvec_iter as __packed __aligned(4)
Date: Mon,  4 Mar 2024 21:24:26 +0000
Message-ID: <20240304211603.434290163@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 7838b4656110d950afdd92a081cc0f33e23e0ea8 ]

In commit 19416123ab3e ("block: define 'struct bvec_iter' as packed"),
what we need is to save the 4byte padding, and avoid `bio` to spread on
one extra cache line.

It is enough to define it as '__packed __aligned(4)', as '__packed'
alone means byte aligned, and can cause compiler to generate horrible
code on architectures that don't support unaligned access in case that
bvec_iter is embedded in other structures.

Cc: Mikulas Patocka <mpatocka@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 19416123ab3e ("block: define 'struct bvec_iter' as packed")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bvec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 9e3dac51eb26b..d4dbaae8b5218 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -59,7 +59,7 @@ struct bvec_iter {
 
 	unsigned int            bi_bvec_done;	/* number of bytes completed in
 						   current bvec */
-} __packed;
+} __packed __aligned(4);
 
 struct bvec_iter_all {
 	struct bio_vec	bv;
-- 
2.43.0



