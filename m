Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34947612D7;
	Tue, 20 Feb 2024 21:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465272; cv=none; b=I5AmRA4i/ehcXNOEjUAT81Nm0UwribKXdsawNKFRJK1XDaedp2Jk+/kdPd2ooALQ7yeDzCsYmXWkYq6QCERePr/d5lN2hjX/CyHnqb1W9krNjkbEqdxOx3+0lgcOvNq//XHVRVBOL3jPvmVv61Yn1YOYdDh4GiWwhSAiIbdwTLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465272; c=relaxed/simple;
	bh=hGajCZqqR228CAASAg4Zm37B+/+XWjvVGSDieQ+FlA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3o+D7b5Qf7US7kIeHZ6KH/XADy4pVT0LHv8NhIflG3Q6iFQY8kw6VAnuFtSyXHSs59+xWbpxxgUjR18Mvx97C7E2zINXANB1WHE1hIAbBK8fIcLkigX/Y9tuTnSDEWDczudTusPFETgzjpNGOoHZFJSPgAWAjAaxfDl/NvE0lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t60ZEa9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t60ZEa9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2569C433C7;
	Tue, 20 Feb 2024 21:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465272;
	bh=hGajCZqqR228CAASAg4Zm37B+/+XWjvVGSDieQ+FlA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t60ZEa9PbwoMjVzKiidDHuMTQQCTlSPRXoIjBER6iC4kb2imqWpU0Fggtn8r9mYbC
	 vdQ/wLTSPPKy0vG/wUmPcdpx23G23mvuuDyBedJy+U3euHp7XdDq2uR2rQ4qa+nSM6
	 UGFsevBE+14CCNVMr5OU101Fhj86Ykfj4bUeUR+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.7 261/309] KVM: s390: vsie: fix race during shadow creation
Date: Tue, 20 Feb 2024 21:57:00 +0100
Message-ID: <20240220205641.323792723@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit fe752331d4b361d43cfd0b89534b4b2176057c32 upstream.

Right now it is possible to see gmap->private being zero in
kvm_s390_vsie_gmap_notifier resulting in a crash.  This is due to the
fact that we add gmap->private == kvm after creation:

static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
                               struct vsie_page *vsie_page)
{
[...]
        gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
        if (IS_ERR(gmap))
                return PTR_ERR(gmap);
        gmap->private = vcpu->kvm;

Let children inherit the private field of the parent.

Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtualization")
Cc: <stable@vger.kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20231220125317.4258-1-borntraeger@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/vsie.c |    1 -
 arch/s390/mm/gmap.c  |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1220,7 +1220,6 @@ static int acquire_gmap_shadow(struct kv
 	gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
 	if (IS_ERR(gmap))
 		return PTR_ERR(gmap);
-	gmap->private = vcpu->kvm;
 	vcpu->kvm->stat.gmap_shadow_create++;
 	WRITE_ONCE(vsie_page->gmap, gmap);
 	return 0;
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1691,6 +1691,7 @@ struct gmap *gmap_shadow(struct gmap *pa
 		return ERR_PTR(-ENOMEM);
 	new->mm = parent->mm;
 	new->parent = gmap_get(parent);
+	new->private = parent->private;
 	new->orig_asce = asce;
 	new->edat_level = edat_level;
 	new->initialized = false;


