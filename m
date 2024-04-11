Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2C213FD7F;
	Thu, 11 Apr 2024 10:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831424; cv=none; b=d9GjOncon8a8Ng4BJQEOaDO3ePH9Z1FzhMBkvyKUnWQH7RIml+VbLt1z++ls9dbVmU1FK3b+wiWWMcentqrBDF/JZpeceaZP6lu7DWhly1mM63T0Ecrb8jxGSZO2+Ul0oRN2Ic5hb0ZQYTR22xdleWzTpTOsICuhBeWEctLvCuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831424; c=relaxed/simple;
	bh=nG6Gy1Vg+MuVt4oWp7gpB+/hrBGNBPY/TdnqBmaHpbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oi4ah9N8+1USiW0U5IiXyUN0PhiS1PfwvAcZTKp7lrVdj9Zp5CxEwT6coJ8q2GNgDDneZH0+/cwfFeK/plvt8Mk/ogPQim2YebQHAYX4BSHyddA9doYhny7HZ+MNKdRYEqwdrzpP2Medv2cfDf6O2Yyfu5mTh+FqgDJImbjh7c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsgHGDUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsgHGDUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D67C43390;
	Thu, 11 Apr 2024 10:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831424;
	bh=nG6Gy1Vg+MuVt4oWp7gpB+/hrBGNBPY/TdnqBmaHpbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsgHGDUVlzB1o0nI0HEdRmxnJmxxaPzocbdPC3Hg/buGSGAHUmmtXpaO4sf0O+jxP
	 6ePyG8avccy95px31loyKnrbUNFzQn5+bbyueh06xhbwFwO2mUfaKdVEddRczPgHsO
	 TtCfLf6hT3rJCcefYkgcmiQFI56B+3IdncCuDWfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/114] randomize_kstack: Improve entropy diffusion
Date: Thu, 11 Apr 2024 11:57:16 +0200
Message-ID: <20240411095420.183089021@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 9c573cd313433f6c1f7236fe64b9b743500c1628 ]

The kstack_offset variable was really only ever using the low bits for
kernel stack offset entropy. Add a ror32() to increase bit diffusion.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 39218ff4c625 ("stack: Optionally randomize kernel stack offset each syscall")
Link: https://lore.kernel.org/r/20240309202445.work.165-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/randomize_kstack.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/randomize_kstack.h b/include/linux/randomize_kstack.h
index 5d868505a94e4..6d92b68efbf6c 100644
--- a/include/linux/randomize_kstack.h
+++ b/include/linux/randomize_kstack.h
@@ -80,7 +80,7 @@ DECLARE_PER_CPU(u32, kstack_offset);
 	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
 				&randomize_kstack_offset)) {		\
 		u32 offset = raw_cpu_read(kstack_offset);		\
-		offset ^= (rand);					\
+		offset = ror32(offset, 5) ^ (rand);			\
 		raw_cpu_write(kstack_offset, offset);			\
 	}								\
 } while (0)
-- 
2.43.0



