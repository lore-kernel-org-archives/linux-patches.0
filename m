Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0B2145B08;
	Thu, 11 Apr 2024 10:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830428; cv=none; b=WIrXSd+eFrCTuPJCF9/Sl9gxN6cvQXmLtOydQxAwS+gRjCFrZ3SygGnwexKInXWXeoGOzRWUkCdcSry6crBCGuJcVFhHOqs/zYYtrGatsq1h27eTGmy9fiCHAO30eBCijMcW2Y0hG5zKgonLZArcReedJvYIesWia+i3xVVebFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830428; c=relaxed/simple;
	bh=EO0SyLXkkkfyfocn8i0FnE+gOirtqQjS7V+e1U4Wn9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9o71q9rYEcnTFIrJpfOl+2do/P+FD/X/9mkyZKeyoplQOEdaZYlmg/xrI1fAeNZld2zCvi7+iZhliLJoLiwM8k0U1gF8m2GTHlhtDFKI/jWiLTX4kdhcZnh3fDNtF1idYodVAnJk8IDMxSB/wR2VjHRnGRTXCTIEGa+sVH9rHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGYp66Wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGYp66Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14E1C433C7;
	Thu, 11 Apr 2024 10:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830428;
	bh=EO0SyLXkkkfyfocn8i0FnE+gOirtqQjS7V+e1U4Wn9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGYp66WlnPpxuyc58Qi6ldyRkGG3d02TLNnwugSm3OZlSrgAwCmnj94SznUpyLkvp
	 icgsTFbh9hKHBpoVYm8wW3ZZbVVG/FgnAEpm++BFKZUhqmT38CerxkgOEwmN7o00iH
	 T7hRB9kA677zptetHkLbnVpkG4ZD8nWjs5l55tCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 135/143] randomize_kstack: Improve entropy diffusion
Date: Thu, 11 Apr 2024 11:56:43 +0200
Message-ID: <20240411095424.966287988@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



