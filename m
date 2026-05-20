Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E2636CE19;
	Wed, 20 May 2026 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297819; cv=none; b=tzj/0yoxL+Ntn0mxpR9Gv7Qo3PeF3TbBDUrIC+eIQSVVSiv9abCMVvlppMSsvdiuKI3pjuudBchDbPZpj1Wjw2/s3YllIIlnWU6XsSqabky6wXdHVfi3ANZ0hGzs6TGQKjHyztDK/EUWBCOKxCP/L0myRpYasb5hcfsQNEZ8BJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297819; c=relaxed/simple;
	bh=66gvRAfxRjzHRd8COlWS6CZgu8sMhJiuMeGDnhDvYHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCvgdBCFJ2JIJvxVCfRMzRQ731NvbdBRqL6/wx/Qg+P+llo+x8dhmsMblBS3YwiTTzNs4kSARDyXerprXRng/pQEi73YbDy3Txkq4VCGTFCTZpiOATzsYXptkUyk7aMr8m+S6cM8E4GWdKFpY0v8v3E+nC277WVikv5qacH5WlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0gdGU8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0gdGU8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55811F000E9;
	Wed, 20 May 2026 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297817;
	bh=lihQgoqAeEow+Y4zF06nSAmeihD1o6MwEGR5pAVkPaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0gdGU8jJeBmkSg9k3LO341jSZNQNnRyYBxfDSZXdf8dd9m9M7sGALAGhx4ByP5Ts
	 V54Rl+Tm/DXORjZEs9n7lVgfoD0CLfggpd6hpI50uMLvvvvSKJcgX6t+coJ5qq2UOn
	 fbQG7KKPpq0HGJ6RE8RbR1Zw7znazLwKaoK0mo7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Wensheng <wsw9603@163.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/957] arm64: kexec: Remove duplicate allocation for trans_pgd
Date: Wed, 20 May 2026 18:10:17 +0200
Message-ID: <20260520162137.461052324@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Wensheng <wsw9603@163.com>

[ Upstream commit ee020bf6f14094c9ae434bb37e6957a1fdad513c ]

trans_pgd would be allocated in trans_pgd_create_copy(), so remove the
duplicate allocation before calling trans_pgd_create_copy().

Fixes: 3744b5280e67 ("arm64: kexec: install a copy of the linear-map")
Signed-off-by: Wang Wensheng <wsw9603@163.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 6f121a0164a48..28df62051cc97 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -129,9 +129,6 @@ int machine_kexec_post_load(struct kimage *kimage)
 	}
 
 	/* Create a copy of the linear map */
-	trans_pgd = kexec_page_alloc(kimage);
-	if (!trans_pgd)
-		return -ENOMEM;
 	rc = trans_pgd_create_copy(&info, &trans_pgd, PAGE_OFFSET, PAGE_END);
 	if (rc)
 		return rc;
-- 
2.53.0



