Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3ED521203;
	Mon, 31 Aug 2026 13:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183864; cv=none; b=QZRcWQTWtdFGEVkY8ZUUp7ivwrfHOQmeL73YysZCEp6SirYJvbfBTvvULta+DLPf3/JMBTVRENmhuoLEgT3ObYMr+2rGnxuu8h3thR4U3NrGnE3307uju3/Mq2Zl+UdXvJzq3i6GpueIjVkDddteiVH/n3VUhhHHe22xQb6yunY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183864; c=relaxed/simple;
	bh=gY9qiiZ0DygCqwMsI7deCcWIQ/MdZFctMMe2a41XXUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M36bOQRmN+8MsbTSGFBoQmWS1EyzLCKg2E3iHQs/Wuc1WvOYAKKRCQLKbPTVgVIXXOF6ZSSJh3nKUjadA9sF4HD/ICUAV3W+iVOWrZujNcNQYO0Te7V/vWf3YJIyZHAzEuSkf5eHNNJmcKhx867H/G8FcC//QqJuwregLiSh88Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHpEpgtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHpEpgtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11801F00ACA;
	Mon, 31 Aug 2026 13:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183862;
	bh=ucOyDi17XZlmdjLUQY5tVX0eCHR7wuvmK+qyyamSdEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xHpEpgtlXw5N5rN+k6ZhPxvd5+o6GTYR+pxhehxj440ZOrc/6i2lWkb9pyiBQxl/N
	 7QmjrxTWFsGlsziEpWzPRlpZhLd5O8lYROTiyptLtjhoJ7Z6ONEr/NhtcCV2jR2nXF
	 5bZ8sXR9XzbGbyRrWsteblJZtDEByoT21ybz5ww8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.1 66/76] KVM: s390: vsie: zero stale crypto bits
Date: Mon, 31 Aug 2026 15:34:38 +0200
Message-ID: <20260831133402.841603046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 34d5b5b646c91cfb9338d7a12c955a70ffb8c66b upstream.

When shadowing crypto access bits from a format0 apcb (crycb 0 or 1),
the bits 64..255 are unchanged from whatever is in the vsie page in the
crycb and thus in the apcb. This gives a nested guest potential access
to a device no longer available. Zero out the remaining bits.

Fixes: 6b79de4b056e ("KVM: s390: vsie: allow guest FORMAT-1 CRYCB on host FORMAT-2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260811153738.206885-3-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/vsie.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -170,6 +170,7 @@ static int setup_apcb10(struct kvm_vcpu
 			    sizeof(struct kvm_s390_apcb0)))
 		return -EFAULT;
 
+	memset(apcb_s, 0, sizeof(*apcb_s));
 	apcb_s->apm[0] = apcb_h->apm[0] & tmp.apm[0];
 	apcb_s->aqm[0] = apcb_h->aqm[0] & tmp.aqm[0] & 0xffff000000000000UL;
 	apcb_s->adm[0] = apcb_h->adm[0] & tmp.adm[0] & 0xffff000000000000UL;


