Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246993D9029;
	Mon,  4 May 2026 14:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903465; cv=none; b=Qn9ZycOABck65NuejWkfGsZi71nH0YUwaTROuNOT2fyyO/lrUuZcZk6KEiyp9Wb1aHMuyiEMGnn5RnHLHmeh1m7FdnnT0xrpH3aSkA2LXC5zYWj86ZRpluFLM+hiXdGwvelEZDGqshtd0H2dAg92Ap6+VK1PImVDG7LNcaNTGA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903465; c=relaxed/simple;
	bh=n71d1yCZpzWocvpPfzQmvqS5LK+evXos5jZ5QpqKa94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTbuxaP0GIa/XTfAYyC5aqPjNHynrTiVyRFXZVDavuAhEjw7BaNx6AgtoZ9pHCTjkFdH2LS8kKTmnFxSr4TXSmFFoCcq8Z2iPuen5LwDn58vgdIn0PXLQ8c8OyPjIQuddJRVf93NC6WVYKcJ+aDOXHmqtHlcvybf1gPNuAMGARU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gt2u0PPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gt2u0PPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAFAC2BCB8;
	Mon,  4 May 2026 14:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903465;
	bh=n71d1yCZpzWocvpPfzQmvqS5LK+evXos5jZ5QpqKa94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gt2u0PPIH1i8A3VcRCHqkgrZAkpCRzRWnkG8zRSORWxHmhQ3gYSPaN8cLQ7PC9ICO
	 QQywynMDqiQupKkObb6QD8EOfvjdWD79Z9DxEYokTZ3q5Buzy768jBMlvkC7IsCQ3g
	 fYhhEQiKHAU+WnSJSZyMQg949N/+sCuPZ3f/okgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 211/307] KVM: arm64: Account for RESx bits in __compute_fgt()
Date: Mon,  4 May 2026 15:51:36 +0200
Message-ID: <20260504135150.809562498@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit d70d4323dd9636e35696639f6b4c2b2735291516 upstream.

When computing Fine Grained Traps, it is preferable to account for
the reserved bits. The HW will most probably ignore them, unless the
bits have been repurposed to do something else.

Use caution, and fold our view of the reserved bits in,

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Fixes: c259d763e6b09 ("KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260401103611.357092-6-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/config.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1585,8 +1585,8 @@ static __always_inline void __compute_fg
 		clear |= ~nested & m->nmask;
 	}
 
-	val |= set;
-	val &= ~clear;
+	val |= set | m->res1;
+	val &= ~(clear | m->res0);
 	*vcpu_fgt(vcpu, reg) = val;
 }
 


