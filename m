Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7402C1595;
	Sun,  7 Jun 2026 10:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828270; cv=none; b=G0mNVHIogDPlBZprW0OlkGuhxpn5AGZj7pioz8mE07FHmH291Idsn1MYkYY1kaKMjzxeH9M/t6udpg+HJc0Sicam9LRGsJIuDhv6+w/Q7EeqV1D6DxviFeTh4Qrpoz0TWKHZR32nW9QhQXgEW9tmIipEygDNfDtcRFHFABGjsqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828270; c=relaxed/simple;
	bh=Ocfd8TAq3Gr4LFAuNzxM3nGJLlziq1kC5Thq3CAYGZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmW/7sOhhz1xrlw+yVDHHQbw4ythDkTVrl1CYtaEYsaiM3wYY3myueHFWmpdu8jmNFFhiL6wMq1/ceYRLpD5Be+3kL1TRRxG6Yz7bPDMoiUpslu6UOe9d94wx8s+g6tW0CMDbxx8NsEn9Z/1SFEK3sGKQHLkxe+J58TDI/3kj5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHzINwwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHzINwwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118251F00893;
	Sun,  7 Jun 2026 10:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828269;
	bh=KyE8BDJ5llr8LhONmtA+qJqbQ62+cWqfdiJplROhqPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHzINwwtWnyibEt14gLBSFCffMOhHa86vcpqNIzsvQ2aBjjeIV20WIk1UTD2WtLlu
	 sa/IAwtVMsrHMPFnN8I1ZMLiQws7dtqFFw8sBprCRkNfOfbETJbDxUGzsHJpRi5cUH
	 YYhWpECKFeVPjTO82wI5qVhbfu056AFklNYYDtVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.0 168/332] KVM: SEV: Use READ_ONCE() when reading entries/indices from PSC buffer
Date: Sun,  7 Jun 2026 11:58:57 +0200
Message-ID: <20260607095734.236463960@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit c8cc238093ca6c99267032f6cfe78f59389f3157 upstream.

Use READ_ONCE() when reading entries/indices from the guest-accessible
Page State Change buffer to defend against TOCTOU bugs.

Don't bother with READ_ONCE()/WRITE_ONCE() for cases where KVM is writing
(and not consuming the result!), as the guest isn't supposed to touch the
buffer while it's being processed.  I.e. using READ_ONCE() is all about
protecting against misbehaving guests.

Fixes: 9b54e248d264 ("KVM: SEV: Add support to handle Page State Change VMGEXIT")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-11-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3827,9 +3827,9 @@ static void __snp_complete_one_psc(struc
 	 */
 	for (idx = svm->sev_es.psc_idx; svm->sev_es.psc_inflight;
 	     svm->sev_es.psc_inflight--, idx++) {
-		struct psc_entry *entry = &entries[idx];
+		struct psc_entry entry = READ_ONCE(entries[idx]);
 
-		entry->cur_page = entry->pagesize ? 512 : 1;
+		entries[idx].cur_page = entry.pagesize ? 512 : 1;
 	}
 
 	hdr->cur_entry = idx;
@@ -3892,8 +3892,8 @@ next_range:
 	 * validation, so take care to only use validated copies of values used
 	 * for things like array indexing.
 	 */
-	idx_start = hdr->cur_entry;
-	idx_end = hdr->end_entry;
+	idx_start = READ_ONCE(hdr->cur_entry);
+	idx_end = READ_ONCE(hdr->end_entry);
 
 	if (idx_end >= max_nr_entries) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_HDR);
@@ -3902,7 +3902,7 @@ next_range:
 
 	/* Find the start of the next range which needs processing. */
 	for (idx = idx_start; idx <= idx_end; idx++, hdr->cur_entry++) {
-		entry_start = entries[idx];
+		entry_start = READ_ONCE(entries[idx]);
 
 		gfn = entry_start.gfn;
 		huge = entry_start.pagesize;
@@ -3946,7 +3946,7 @@ next_range:
 	 * KVM_HC_MAP_GPA_RANGE exit.
 	 */
 	while (++idx <= idx_end) {
-		struct psc_entry entry = entries[idx];
+		struct psc_entry entry = READ_ONCE(entries[idx]);
 
 		if (entry.operation != entry_start.operation ||
 		    entry.gfn != entry_start.gfn + npages ||


