Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A213D2E7649;
	Thu,  3 Jul 2025 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554931; cv=none; b=LXp0jEGWl3U0FhfbIU1YmA/cVSSkldiKxfert1TEp7OvOqvbnEUEFBqwMm6VVDt4R/ykRIQ6WsY9FcIisksmuAUBahuUK2jxgy7kDSywblchyByufQPC+7Oru5KS5DHL009Hb+eBgXSvi9TRdzQXk9G6s2m2xn/CXddhjMmu770=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554931; c=relaxed/simple;
	bh=Jf6n4+AZO3mYERWxWmsMPrSzOtXwx+ODykdWPOjLP9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApzDytJNdxU1YH7b/6047ipSIZre3MXe2ZOgsTvDHV2cz58f/yhCmnkrCtYn4ZkjlMzf3/ukj2H6dHJtmE3cw0Z0QKapxpB05FeurAZ8qGlsCbtarT+38Y4y4NFVstEuxvAyF8E/ch+KXKhxf9fZriEXGktlA44tBV3yyNpDnHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxE30ZpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxE30ZpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02D6C4CEEE;
	Thu,  3 Jul 2025 15:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554931;
	bh=Jf6n4+AZO3mYERWxWmsMPrSzOtXwx+ODykdWPOjLP9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxE30ZpIV3Gd2sbZ3a/p3km2Oy+PHseXPM9BFmLdtQ8xgQdcFpOkoFt00ccJaLmGZ
	 +AyJaMxPnFIcRoRsqlRIbFMIaLvmF3H6hn1n3aS3GO8YG7nVrzWtStXfiosA0xqH9K
	 gF8zY5K7QbQ+RIxNDb38mk3abXsQ7XTXxgjGeFyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	rtm@csail.mit.edu,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 6.15 122/263] Revert "riscv: Define TASK_SIZE_MAX for __access_ok()"
Date: Thu,  3 Jul 2025 16:40:42 +0200
Message-ID: <20250703144009.245056181@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 890ba5be6335dbbbc99af14ea007befb5f83f174 upstream.

This reverts commit ad5643cf2f69 ("riscv: Define TASK_SIZE_MAX for
__access_ok()").

This commit changes TASK_SIZE_MAX to be LONG_MAX to optimize access_ok(),
because the previous TASK_SIZE_MAX (default to TASK_SIZE) requires some
computation.

The reasoning was that all user addresses are less than LONG_MAX, and all
kernel addresses are greater than LONG_MAX. Therefore access_ok() can
filter kernel addresses.

Addresses between TASK_SIZE and LONG_MAX are not valid user addresses, but
access_ok() let them pass. That was thought to be okay, because they are
not valid addresses at hardware level.

Unfortunately, one case is missed: get_user_pages_fast() happily accepts
addresses between TASK_SIZE and LONG_MAX. futex(), for instance, uses
get_user_pages_fast(). This causes the problem reported by Robert [1].

Therefore, revert this commit. TASK_SIZE_MAX is changed to the default:
TASK_SIZE.

This unfortunately reduces performance, because TASK_SIZE is more expensive
to compute compared to LONG_MAX. But correctness first, we can think about
optimization later, if required.

Reported-by: <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/linux-riscv/77605.1750245028@localhost/
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Fixes: ad5643cf2f69 ("riscv: Define TASK_SIZE_MAX for __access_ok()")
Link: https://lore.kernel.org/r/20250619155858.1249789-1-namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/pgtable.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -980,7 +980,6 @@ static inline pte_t pte_swp_clear_exclus
  */
 #ifdef CONFIG_64BIT
 #define TASK_SIZE_64	(PGDIR_SIZE * PTRS_PER_PGD / 2)
-#define TASK_SIZE_MAX	LONG_MAX
 
 #ifdef CONFIG_COMPAT
 #define TASK_SIZE_32	(_AC(0x80000000, UL) - PAGE_SIZE)


