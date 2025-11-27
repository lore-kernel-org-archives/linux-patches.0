Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9E527F18B;
	Thu, 27 Nov 2025 14:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255037; cv=none; b=m5YJX3u4aknwAX/pu2zfiMpEu7ieW+NJJvy9weDvHkDh/YoqeZbC7e6EkcvaS7JuoeL1TH1H+Q9ggY9Jf+ZmSvfW4l//x86bVKj81OnAlQMWDE618j0F6zWDKAZ6bP9D09Y+wnaejLlqyzbPzDyNJ8nlb5BpKtdsls/0i3P+dOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255037; c=relaxed/simple;
	bh=a9Z2se+k0vOpiF1aQlr98wjW2oPIRkOw+1reRfiDsxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noNNPvfsglr5KP0P+yA2bJY/MOkVoYCOhWNld99HTLQ/00zjqE8Rcg9lRrJx18f1xUaCInYxVW0DDxgsPaR5mst/0VR0BaUqtEy68lfqi8dxdw1yzUuja5SqcsdWs6beXwZWiITDO859hulBh/nLgX6wtGQ0IH6xXgYzvzm+AAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiWLJM9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiWLJM9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6921EC4CEF8;
	Thu, 27 Nov 2025 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255037;
	bh=a9Z2se+k0vOpiF1aQlr98wjW2oPIRkOw+1reRfiDsxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiWLJM9b1Xz8yqk/A7U0F5M46sEhWsGAsdq3Ujkyw3UJL0+bNCB06dQ1onjm4AeEC
	 MdzRZYyJMgx68BO4UQOJKJFJxIbk0SrGEz/NFtRdpgYuXQq4I38TEy6H7vM5Jyda8P
	 9jsNyPHBulPX6HXls/krwEywK9y3XdNiK+5Jc41A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 73/86] KVM: arm64: Check the untrusted offset in FF-A memory share
Date: Thu, 27 Nov 2025 15:46:29 +0100
Message-ID: <20251127144030.497315157@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -425,7 +425,7 @@ static void __do_ffa_mem_xfer(const u64
 	DECLARE_REG(u32, npages_mbz, ctxt, 4);
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges;
+	u32 offset, nr_ranges, checked_offset;
 	int ret = 0;
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
@@ -460,7 +460,12 @@ static void __do_ffa_mem_xfer(const u64
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


