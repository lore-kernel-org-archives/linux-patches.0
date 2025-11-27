Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4870E25BEE8;
	Thu, 27 Nov 2025 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255103; cv=none; b=dWVuGwXeMI0EPUv270f40lcu0cU12bdB/aM9ZvrgzpGQbP7M5kXokmxsHIBvIiXvcDWW10o2xOB3TCFUWDpOe6SFAFlMW2zmOBAJR6cp2BVzR8ExQQzx8ji4wU6v/rK5J56Otyq+qAQoAIDAExL00i8wjPNtaJwvbyw6K6VnDFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255103; c=relaxed/simple;
	bh=ZuGltzw6uJOuiwZaTL35h17XTFzLk28SEPNS6zHpmoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTNY0lLee8oNx4KCGPaQBYVrKxdtUph2kUlEURL5O/4+LRF3BTlSeC2JIIYyqiEizKH5jL3TTXb5ZezxG3YhvVU3HcGG5B0Hh3+HsmA9qU1I3wkrF9f3fVpBnBLPcRq8wosxfCwwX7xyx5UW0f0CA60ngBbmmNt9+cTbajZjL0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQkz7OzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQkz7OzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0D8C4CEF8;
	Thu, 27 Nov 2025 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255103;
	bh=ZuGltzw6uJOuiwZaTL35h17XTFzLk28SEPNS6zHpmoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQkz7OzChtSz8tBRoOB1v1+f+81QXy7lPFkqTTDsSp2tj9g/KN5hAbqGJ5YDQnU4g
	 mgeS64hlxX/dEQw1bBLEIVkBDLhQMphk2bWlE4h2KLtn4dNokhdpwXgYCf/W46aAIO
	 UOBWlBCctwE7c4fZQZB1rG05Z/h3Pp4gzBUz4n3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 001/112] KVM: arm64: Check the untrusted offset in FF-A memory share
Date: Thu, 27 Nov 2025 15:45:03 +0100
Message-ID: <20251127144032.763524853@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


