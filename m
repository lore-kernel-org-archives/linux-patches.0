Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC9231281E;
	Thu, 27 Nov 2025 14:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255483; cv=none; b=Cp34WD85IiUmLj5oiZqyqAlN0gvMFW2OxV/Um00yV2tZODKXx8yBjIlG/mf1ErWdaH16fweXANadJBwtrITUGCzFhg7l2rrdApcuCjBu1VdwkAUl6m6DXs3ZFl9gAjm/aJmfvgZL+CZ7tQgJxZh0y8mCyUXzmtw8IpTr2kxCgW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255483; c=relaxed/simple;
	bh=+6acFEMppyFaYD70vhZvY59hWBancP2gOFWsfZfhy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaNiuRQ8WPG+kGBlkdGCP/ihizwHKuGczNH/Qiq61vI2/BpYUWUjtoXeFwjiwTTbZYvRAex8nfrgYRg5i+zRJX9sRyJC3Lkrmo5MkEsNOaYKiPkn1yWwHpLSZbx8SuOnFUSPb14bLHp4+hFXDKqgsmEJkG6E3qxCGoZMqBN3n/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEC5esPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEC5esPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB6DC4CEF8;
	Thu, 27 Nov 2025 14:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255482;
	bh=+6acFEMppyFaYD70vhZvY59hWBancP2gOFWsfZfhy08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEC5esPI1Ogf+oOATcHhzo9dCzeqL+MatfnBGX9NlLm3I7/W7QW1qYm0px4Oiab9J
	 kUzz5cgoGYyeQ1MTVS27DvaGyQ7yaBcFBp2PZxPpMYaPYYoOIC6Yq1oSl+aPR1XOrb
	 e+AZKc3NFn5hxJROmx2h7VwbD6Eo6aTfXHJoLyXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.17 001/175] KVM: arm64: Check the untrusted offset in FF-A memory share
Date: Thu, 27 Nov 2025 15:44:14 +0100
Message-ID: <20251127144043.003509470@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ene <sebastianene@google.com>

commit 103e17aac09cdd358133f9e00998b75d6c1f1518 upstream.

Verify the offset to prevent OOB access in the hypervisor
FF-A buffer in case an untrusted large enough value
[U32_MAX - sizeof(struct ffa_composite_mem_region) + 1, U32_MAX]
is set from the host kernel.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://patch.msgid.link/20251017075710.2605118-1-sebastianene@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -437,7 +437,7 @@ static void __do_ffa_mem_xfer(const u64
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges;
+	u32 offset, nr_ranges, checked_offset;
 	int ret = 0;
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
@@ -474,7 +474,12 @@ static void __do_ffa_mem_xfer(const u64
 		goto out_unlock;
 	}
 
-	if (fraglen < offset + sizeof(struct ffa_composite_mem_region)) {
+	if (check_add_overflow(offset, sizeof(struct ffa_composite_mem_region), &checked_offset)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	if (fraglen < checked_offset) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out_unlock;
 	}


