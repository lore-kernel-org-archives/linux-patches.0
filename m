Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC62755E5E;
	Wed, 21 Feb 2024 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523905; cv=none; b=MUQGJI6nieKw/WoiZ7c9tBgYQ+lTybds0eN3OWWjB2XBar6TyomTyqdjRv9YCzBsuFAXQZGY39Gr85f4ivf0bbb7Yymu+PaYlrXaaphxOYMML3wM9oukOB3Bv00z1nfZQk2fBwJ8DzUb3oePlNRQxcmn/4VGTApQrDA4k+5+5pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523905; c=relaxed/simple;
	bh=2y+12xqCjiw6o6wuaek9GrcRHTljtq+HmzFWu/F5Z38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aieNiGhF6XfCLoKTXXp9qKyR/SgHyanFX407nSBFfU6pHZCzjLn10hHBZ7Ws0fWXJLRRer+VuSI4RLP4w/fytOZcyaN9jLSfjwY2NnyhAVbEHsqhWlkp5eNstTnc4IVU5zTxdT8oLZIefZpM2fY3RV6ZJtypYBYKSnCkxAjYtI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uc1sun3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uc1sun3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C16C433F1;
	Wed, 21 Feb 2024 13:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523905;
	bh=2y+12xqCjiw6o6wuaek9GrcRHTljtq+HmzFWu/F5Z38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uc1sun3pxPE6tIBtnPN6ewMWpoWScrJYQDkC8cUJCjjW51cqlvitkOGaVxYJ5LJdg
	 WHx3V0yuwmc6yv6V9kLkIQ2iHr/Qp012LVlMyTMxcsAbTpLzoVqryyN4TWaz24NvhZ
	 ku2L73m51aYmHH2eqM1EZzWrDeXb9279m7nG9Shc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rolf Eike Beer <eb@emlix.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/379] mm: use __pfn_to_section() instead of open coding it
Date: Wed, 21 Feb 2024 14:04:26 +0100
Message-ID: <20240221125957.480778415@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rolf Eike Beer <eb@emlix.com>

[ Upstream commit f1dc0db296bd25960273649fc6ef2ecbf5aaa0e0 ]

It is defined in the same file just a few lines above.

Link: https://lkml.kernel.org/r/4598487.Rc0NezkW7i@mobilepool36.emlix.com
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmzone.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b2e4599b8883..11fa11c31fda 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1369,7 +1369,7 @@ static inline int pfn_valid(unsigned long pfn)
 
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
-	ms = __nr_to_section(pfn_to_section_nr(pfn));
+	ms = __pfn_to_section(pfn);
 	if (!valid_section(ms))
 		return 0;
 	/*
@@ -1384,7 +1384,7 @@ static inline int pfn_in_present_section(unsigned long pfn)
 {
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
-	return present_section(__nr_to_section(pfn_to_section_nr(pfn)));
+	return present_section(__pfn_to_section(pfn));
 }
 
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
-- 
2.43.0



