Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABA04C97;
	Tue,  8 Oct 2024 12:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390469; cv=none; b=nWVheI1NJL4LuMtKyVt6+fDEYnzxnlUkmb7Q2DrjljTgCjWwPgo+9PPlkgoP2E1pATKwHVy0YKF92HzZ+aNNwqKVbDTdVEpqSK9vSCI6yLZ6o7dFGcIMnqEpnxf4nP+2BpKSSYRIGiUUgFY/KfhkAkxcvoHPYiaC9mSLPhyj6jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390469; c=relaxed/simple;
	bh=JQn1uLVUx1DCqU83cNlp37FW/YaoEzRpcdtCa8YYhnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n05iP28R+lDfqRZA3m096wB162NTouvrQRhjyW20UNlvISceoerB039jODtSD2uPkFcOo6uVnDoDwt0I2M9UlvpaH3vOfyHRLWIn3p8JTSJ01mDNnGKJFejUWJzt6V0U5XqzXi9+sou3PLawRWupCblrz26wKi4bFgbIQw8xqRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edW/UPcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edW/UPcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A56C4CEC7;
	Tue,  8 Oct 2024 12:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390469;
	bh=JQn1uLVUx1DCqU83cNlp37FW/YaoEzRpcdtCa8YYhnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edW/UPcCrE5UAcZuKcHLhe6Mabgd2i6WDnpi+RD7rTglmwJeJlE+rQgKTMdJtrL/X
	 uUZUq+7ffOv7WKljz4KgWDnLTDltrLnHzLiKmPl9aCd1w9g5OZAnDvmF9inG/+/NfX
	 oFb2icmusePT2NE9gsa+sVwEocxCixApCSDXfyZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.10 291/482] KVM: arm64: Fix kvm_has_feat*() handling of negative features
Date: Tue,  8 Oct 2024 14:05:54 +0200
Message-ID: <20241008115659.729756131@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit a1d402abf8e3ff1d821e88993fc5331784fac0da upstream.

Oliver reports that the kvm_has_feat() helper is not behaviing as
expected for negative feature. On investigation, the main issue
seems to be caused by the following construct:

 #define get_idreg_field(kvm, id, fld)				\
 	(id##_##fld##_SIGNED ?					\
	 get_idreg_field_signed(kvm, id, fld) :			\
	 get_idreg_field_unsigned(kvm, id, fld))

where one side of the expression evaluates as something signed,
and the other as something unsigned. In retrospect, this is totally
braindead, as the compiler converts this into an unsigned expression.
When compared to something that is 0, the test is simply elided.

Epic fail. Similar issue exists in the expand_field_sign() macro.

The correct way to handle this is to chose between signed and unsigned
comparisons, so that both sides of the ternary expression are of the
same type (bool).

In order to keep the code readable (sort of), we introduce new
comparison primitives taking an operator as a parameter, and
rewrite the kvm_has_feat*() helpers in terms of these primitives.

Fixes: c62d7a23b947 ("KVM: arm64: Add feature checking helpers")
Reported-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Oliver Upton <oliver.upton@linux.dev>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241002204239.2051637-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1364,11 +1364,6 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcp
 		sign_extend64(__val, id##_##fld##_WIDTH - 1);		\
 	})
 
-#define expand_field_sign(id, fld, val)					\
-	(id##_##fld##_SIGNED ?						\
-	 __expand_field_sign_signed(id, fld, val) :			\
-	 __expand_field_sign_unsigned(id, fld, val))
-
 #define get_idreg_field_unsigned(kvm, id, fld)				\
 	({								\
 		u64 __val = IDREG((kvm), SYS_##id);			\
@@ -1384,20 +1379,26 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcp
 #define get_idreg_field_enum(kvm, id, fld)				\
 	get_idreg_field_unsigned(kvm, id, fld)
 
-#define get_idreg_field(kvm, id, fld)					\
+#define kvm_cmp_feat_signed(kvm, id, fld, op, limit)			\
+	(get_idreg_field_signed((kvm), id, fld) op __expand_field_sign_signed(id, fld, limit))
+
+#define kvm_cmp_feat_unsigned(kvm, id, fld, op, limit)			\
+	(get_idreg_field_unsigned((kvm), id, fld) op __expand_field_sign_unsigned(id, fld, limit))
+
+#define kvm_cmp_feat(kvm, id, fld, op, limit)				\
 	(id##_##fld##_SIGNED ?						\
-	 get_idreg_field_signed(kvm, id, fld) :				\
-	 get_idreg_field_unsigned(kvm, id, fld))
+	 kvm_cmp_feat_signed(kvm, id, fld, op, limit) :			\
+	 kvm_cmp_feat_unsigned(kvm, id, fld, op, limit))
 
 #define kvm_has_feat(kvm, id, fld, limit)				\
-	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, limit))
+	kvm_cmp_feat(kvm, id, fld, >=, limit)
 
 #define kvm_has_feat_enum(kvm, id, fld, val)				\
-	(get_idreg_field_unsigned((kvm), id, fld) == __expand_field_sign_unsigned(id, fld, val))
+	kvm_cmp_feat_unsigned(kvm, id, fld, ==, val)
 
 #define kvm_has_feat_range(kvm, id, fld, min, max)			\
-	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, min) && \
-	 get_idreg_field((kvm), id, fld) <= expand_field_sign(id, fld, max))
+	(kvm_cmp_feat(kvm, id, fld, >=, min) &&				\
+	kvm_cmp_feat(kvm, id, fld, <=, max))
 
 /* Check for a given level of PAuth support */
 #define kvm_has_pauth(k, l)						\


