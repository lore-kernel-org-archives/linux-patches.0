Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5037A1F4FC1;
	Wed,  6 Nov 2024 12:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896640; cv=none; b=LyI82NtJPQnZhhp5bPHGB+9u3z6fixNQqBEKa/TLnKsJI4dR58NZjV8XLp7P9ey9O+ygWFDB2c0f14qUNxPmthIN813AumKop0XHExDPtZ35j02l/qd7r31KnRrZc4T+WmqrTNrB07KxY5cDCtew8fJ1TgZ9oA0NEqciKew/W1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896640; c=relaxed/simple;
	bh=VucHVD9rMEvQG0+MSBVQcc3i0BNyUvOktS67JdgMe5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ial3aQmTRKRRggxhr6eyk5KuGZMwMCMstvWDFw26GZSHHblIpTXi0vDyO3F3XcMuXQPxROtFEDVyFhmzFaH+qUIUAcjJy8jUSXLkuFOxzWWbswn3V5U9bhfAKuDMY+T6pZLr62Pl8Jd8zGokmo6NDSJkiGywQrU7NvZMobPbHLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGSttAfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGSttAfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731EEC4CED4;
	Wed,  6 Nov 2024 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896639;
	bh=VucHVD9rMEvQG0+MSBVQcc3i0BNyUvOktS67JdgMe5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGSttAfDGx/e3HqY3ILzXJbdfhgKzipY5jOpXtJD4O8Ib1R3qwVacjioPn0oSJDX2
	 O2ut47OAExFYPvNrh3Mtty3/gtwE/xQz5114hpJkivsltFmOLjL4hghemy+HXAL28H
	 rNQA1NwhjuN7IptZVADZt6CmexTTvVhZxZ240xkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/110] KVM: s390: gaccess: Cleanup access to guest pages
Date: Wed,  6 Nov 2024 13:03:49 +0100
Message-ID: <20241106120303.804178738@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

[ Upstream commit bad13799e0305deb258372b7298a86be4c78aaba ]

Introduce a helper function for guest frame access.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20211126164549.7046-4-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Stable-dep-of: e8061f06185b ("KVM: s390: gaccess: Check if guest address is in memslot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/gaccess.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 9b9bfc333e62d..164f96ba61dd2 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -866,6 +866,20 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	return 0;
 }
 
+static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+			     void *data, unsigned int len)
+{
+	const unsigned int offset = offset_in_page(gpa);
+	const gfn_t gfn = gpa_to_gfn(gpa);
+	int rc;
+
+	if (mode == GACC_STORE)
+		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);
+	else
+		rc = kvm_read_guest_page(kvm, gfn, data, offset, len);
+	return rc;
+}
+
 int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		 unsigned long len, enum gacc_mode mode)
 {
@@ -896,10 +910,7 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
 	for (idx = 0; idx < nr_pages && !rc; idx++) {
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
-		if (mode == GACC_STORE)
-			rc = kvm_write_guest(vcpu->kvm, gpas[idx], data, fragment_len);
-		else
-			rc = kvm_read_guest(vcpu->kvm, gpas[idx], data, fragment_len);
+		rc = access_guest_page(vcpu->kvm, mode, gpas[idx], data, fragment_len);
 		len -= fragment_len;
 		data += fragment_len;
 	}
@@ -920,10 +931,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 	while (len && !rc) {
 		gpa = kvm_s390_real_to_abs(vcpu, gra);
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
-		if (mode)
-			rc = write_guest_abs(vcpu, gpa, data, fragment_len);
-		else
-			rc = read_guest_abs(vcpu, gpa, data, fragment_len);
+		rc = access_guest_page(vcpu->kvm, mode, gpa, data, fragment_len);
 		len -= fragment_len;
 		gra += fragment_len;
 		data += fragment_len;
-- 
2.43.0



