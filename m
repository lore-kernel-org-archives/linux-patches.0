Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2437E151CE8;
	Tue, 20 Feb 2024 21:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463618; cv=none; b=hIF3mdNnIbqDloDf1ytfkB09CVYqqcTGsbAmjM6WoSbxZcE21Z98xzfl1QCSagcrBn9Sxr0TLZv7vjHVrYD5ZoZQAve35UdJiaCgtGBRmb0Bi0aQ2yIn3F2TOKjUFSzjKMDtgjLmN/Up4APDDH1firQ63N7TBG4jf+4gaUusvu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463618; c=relaxed/simple;
	bh=FNJmbmkZABeentB1LMuka0sAUC6kJtUeR38Sk/SwGr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeGO9p1x8zA+0Auc9uURsmRDb6s8A/tZEKu1/Mn6VJuctsHfwmfrHS+/BKHJ8hF6AWfMD9VKsV6iNImrLhzyyLyBHI1TfSMRdEj+D0p8JIzwJWRtjbAO566FhwDtfxc0SZyTcrWYdvRUxbHquiHc9J/F8AFzPuRo7ExaQHZCSDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lS+ZyOZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lS+ZyOZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98183C433C7;
	Tue, 20 Feb 2024 21:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463618;
	bh=FNJmbmkZABeentB1LMuka0sAUC6kJtUeR38Sk/SwGr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lS+ZyOZJVKUkEwgdhBQHZNURc/LPwfk+gdtWHDqRbEqg0BvMxOu02vpv1Hcp815QO
	 cWz4DlQfwyu1JuTFbajcFmgnKTwOjxnlivhjOea6ZA/DFbnaZAOQAk1IAvJnNW+Wu9
	 0AnNxBbXVdrZoHWNpzQwi2ME7Ck3ROD96BozQcgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Spoorthy <spoorthy@linux.ibm.com>,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/331] powerpc/kasan: Limit KASAN thread size increase to 32KB
Date: Tue, 20 Feb 2024 21:53:36 +0100
Message-ID: <20240220205640.725006471@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit f1acb109505d983779bbb7e20a1ee6244d2b5736 ]

KASAN is seen to increase stack usage, to the point that it was reported
to lead to stack overflow on some 32-bit machines (see link).

To avoid overflows the stack size was doubled for KASAN builds in
commit 3e8635fb2e07 ("powerpc/kasan: Force thread size increase with
KASAN").

However with a 32KB stack size to begin with, the doubling leads to a
64KB stack, which causes build errors:
  arch/powerpc/kernel/switch.S:249: Error: operand out of range (0x000000000000fe50 is not between 0xffffffffffff8000 and 0x0000000000007fff)

Although the asm could be reworked, in practice a 32KB stack seems
sufficient even for KASAN builds - the additional usage seems to be in
the 2-3KB range for a 64-bit KASAN build.

So only increase the stack for KASAN if the stack size is < 32KB.

Fixes: 18f14afe2816 ("powerpc/64s: Increase default stack size to 32KB")
Reported-by: Spoorthy <spoorthy@linux.ibm.com>
Reported-by: Benjamin Gray <bgray@linux.ibm.com>
Reviewed-by: Benjamin Gray <bgray@linux.ibm.com>
Link: https://lore.kernel.org/linuxppc-dev/bug-207129-206035@https.bugzilla.kernel.org%2F/
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240212064244.3924505-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/thread_info.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index bf5dde1a4114..15c5691dd218 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -14,7 +14,7 @@
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) && CONFIG_THREAD_SHIFT < 15
 #define MIN_THREAD_SHIFT	(CONFIG_THREAD_SHIFT + 1)
 #else
 #define MIN_THREAD_SHIFT	CONFIG_THREAD_SHIFT
-- 
2.43.0



