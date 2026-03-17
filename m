Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DECB3EFD18;
	Tue, 17 Mar 2026 16:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765966; cv=none; b=PLdVSzaYatKu5imZyXIl9FR8Pi33FcAKvgNN6TV90x8rCUPd5tFEJu8QyBOqd23pDTs0Bnuh3lfia5DB0+ZE5Fsp1qDaoQ8Po4rYHCKNUYU8kmKyS7VAEjyqEEZ9XcoaJOV5OfLFoZRFOlL9V+KSCE4wQ271zKfpGKO1lFJQwa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765966; c=relaxed/simple;
	bh=IeCCt3GEgbQZFZSaZXQtkwcOC3clHuMd1q6PRPZ3OJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm4k4Xkcq7I9y5yrHkK66J1xvwtQz8ohUnGYupAjEx3afk3V4uM9In2Jf/OyJMwsziHEjge9ZkcUBBxn6hY7jU3c1wV/n8/4hmK0vlOzPmiT+CYoY7vTWtsBIriXo/cQ6fFQBZM4237o2gtjTHE8OMNi1Hwiq11l2alUQsHNVEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXo1V6pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXo1V6pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6BBC4CEF7;
	Tue, 17 Mar 2026 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765966;
	bh=IeCCt3GEgbQZFZSaZXQtkwcOC3clHuMd1q6PRPZ3OJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXo1V6ppOh3oJP0Sv4K3ikXBU6fNM1lTmGcAdb8d63X3fbgVFbfYshel6z4V5xqgG
	 AqrPh2yxEr29orALPMft1Txfa38ALWXmMWDk1woUbN4TvSaH03ao5vvxmn+ZQWmK/l
	 eaEOxT0rhMHrJr/XqfalMdOY8mMkasGNnDm+0p/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.19 139/378] KVM: arm64: pkvm: Fallback to level-3 mapping on host stage-2 fault
Date: Tue, 17 Mar 2026 17:31:36 +0100
Message-ID: <20260317163012.126713959@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 8531d5a83d8eb8affb5c0249b466c28d94192603 upstream.

If, for any odd reason, we cannot converge to mapping size that is
completely contained in a memblock region, we fail to install a S2
mapping and go back to the faulting instruction. Rince, repeat.

This happens when faulting in regions that are smaller than a page
or that do not have PAGE_SIZE-aligned boundaries (as witnessed on
an O6 board that refuses to boot in protected mode).

In this situation, fallback to using a PAGE_SIZE mapping anyway --
it isn't like we can go any lower.

Fixes: e728e705802fe ("KVM: arm64: Adjust range correctly during host stage-2 faults")
Link: https://lore.kernel.org/r/86wlzr77cn.wl-maz@kernel.org
Cc: stable@vger.kernel.org
Cc: Quentin Perret <qperret@google.com>
Reviewed-by: Quentin Perret <qperret@google.com>
Link: https://patch.msgid.link/20260305132751.2928138-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -516,7 +516,7 @@ static int host_stage2_adjust_range(u64
 		granule = kvm_granule_size(level);
 		cur.start = ALIGN_DOWN(addr, granule);
 		cur.end = cur.start + granule;
-		if (!range_included(&cur, range))
+		if (!range_included(&cur, range) && level < KVM_PGTABLE_LAST_LEVEL)
 			continue;
 		*range = cur;
 		return 0;


