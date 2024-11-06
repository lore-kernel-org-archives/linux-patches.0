Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0DE54765;
	Wed,  6 Nov 2024 13:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898930; cv=none; b=ci5Cvd23wRzsuQ9SkSIJeg7MAnKyowKc+Bx/Yw9U7WBgKP4qPNHBfFtgDTUEKfI5GFp0BhQaw0oHB//Wwtt8bK7ZR1A4dImsiQcIGh+/25SinAvqPB9ScVCZPfYORih1tlk9AE4EuiiaR9s//y3HNterWieLuQV2i/ZLYdoCVWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898930; c=relaxed/simple;
	bh=PMy6djEGFM6wm/i9aF3cNzI7R+bsRj8IwGclrxtYtS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOO6srwb47bTQ+72zpL7nbqxsYNJfklFeZPM11Jgy82RSomjZSHMnBkM22Owl7UKqyyNrKZgg7qZvXLWoOvCpIZoepLn01BQM+zAyCy8/kDTYcIuzh00PqAebk11XDOQpTClPp6CeNv/kbgA1f+w+snlseXVywiFNGUlfnPW4KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfNNKWC3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfNNKWC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B14C4CECD;
	Wed,  6 Nov 2024 13:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898929;
	bh=PMy6djEGFM6wm/i9aF3cNzI7R+bsRj8IwGclrxtYtS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfNNKWC3ONt0Ur1cdPHBlWabgHwRGUyIzDdZMC2Tr3Dv8/HU/eZjsgLbDEvEK/Nfz
	 PEfyFOn+Jxxr59+64Ye2QYNHAN2ZDhDeuHB570TPyUVooGyj5wBX7QvgSVwoHgGAo1
	 5lMBKmeB/mMG7miw/7L+M6GGmg5kkCofTC8ZAsFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Boehr <nrb@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 403/462] KVM: s390: gaccess: Check if guest address is in memslot
Date: Wed,  6 Nov 2024 13:04:56 +0100
Message-ID: <20241106120341.475505881@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nico Boehr <nrb@linux.ibm.com>

[ Upstream commit e8061f06185be0a06a73760d6526b8b0feadfe52 ]

Previously, access_guest_page() did not check whether the given guest
address is inside of a memslot. This is not a problem, since
kvm_write_guest_page/kvm_read_guest_page return -EFAULT in this case.

However, -EFAULT is also returned when copy_to/from_user fails.

When emulating a guest instruction, the address being outside a memslot
usually means that an addressing exception should be injected into the
guest.

Failure in copy_to/from_user however indicates that something is wrong
in userspace and hence should be handled there.

To be able to distinguish these two cases, return PGM_ADDRESSING in
access_guest_page() when the guest address is outside guest memory. In
access_guest_real(), populate vcpu->arch.pgm.code such that
kvm_s390_inject_prog_cond() can be used in the caller for injecting into
the guest (if applicable).

Since this adds a new return value to access_guest_page(), we need to make
sure that other callers are not confused by the new positive return value.

There are the following users of access_guest_page():
- access_guest_with_key() does the checking itself (in
  guest_range_to_gpas()), so this case should never happen. Even if, the
  handling is set up properly.
- access_guest_real() just passes the return code to its callers, which
  are:
    - read_guest_real() - see below
    - write_guest_real() - see below

There are the following users of read_guest_real():
- ar_translation() in gaccess.c which already returns PGM_*
- setup_apcb10(), setup_apcb00(), setup_apcb11() in vsie.c which always
  return -EFAULT on read_guest_read() nonzero return - no change
- shadow_crycb(), handle_stfle() always present this as validity, this
  could be handled better but doesn't change current behaviour - no change

There are the following users of write_guest_real():
- kvm_s390_store_status_unloaded() always returns -EFAULT on
  write_guest_real() failure.

Fixes: 2293897805c2 ("KVM: s390: add architecture compliant guest access functions")
Cc: stable@vger.kernel.org
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20240917151904.74314-2-nrb@linux.ibm.com
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/gaccess.c |  4 ++++
 arch/s390/kvm/gaccess.h | 14 ++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6ba82fe0776f8..11ddac5e3e923 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -873,6 +873,8 @@ static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
 	const gfn_t gfn = gpa_to_gfn(gpa);
 	int rc;
 
+	if (!gfn_to_memslot(kvm, gfn))
+		return PGM_ADDRESSING;
 	if (mode == GACC_STORE)
 		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);
 	else
@@ -936,6 +938,8 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 		gra += fragment_len;
 		data += fragment_len;
 	}
+	if (rc > 0)
+		vcpu->arch.pgm.code = rc;
 	return rc;
 }
 
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 4c56de5429608..6c97cde8623a4 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -344,11 +344,12 @@ int read_guest_abs(struct kvm_vcpu *vcpu, unsigned long gpa, void *data,
  * @len: number of bytes to copy
  *
  * Copy @len bytes from @data (kernel space) to @gra (guest real address).
- * It is up to the caller to ensure that the entire guest memory range is
- * valid memory before calling this function.
  * Guest low address and key protection are not checked.
  *
- * Returns zero on success or -EFAULT on error.
+ * Returns zero on success, -EFAULT when copying from @data failed, or
+ * PGM_ADRESSING in case @gra is outside a memslot. In this case, pgm check info
+ * is also stored to allow injecting into the guest (if applicable) using
+ * kvm_s390_inject_prog_cond().
  *
  * If an error occurs data may have been copied partially to guest memory.
  */
@@ -367,11 +368,12 @@ int write_guest_real(struct kvm_vcpu *vcpu, unsigned long gra, void *data,
  * @len: number of bytes to copy
  *
  * Copy @len bytes from @gra (guest real address) to @data (kernel space).
- * It is up to the caller to ensure that the entire guest memory range is
- * valid memory before calling this function.
  * Guest key protection is not checked.
  *
- * Returns zero on success or -EFAULT on error.
+ * Returns zero on success, -EFAULT when copying to @data failed, or
+ * PGM_ADRESSING in case @gra is outside a memslot. In this case, pgm check info
+ * is also stored to allow injecting into the guest (if applicable) using
+ * kvm_s390_inject_prog_cond().
  *
  * If an error occurs data may have been copied partially to kernel space.
  */
-- 
2.43.0



