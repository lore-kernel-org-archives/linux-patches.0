Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C922FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D00C433A0;
	Mon, 15 May 2023 16:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169550;
	bh=LsnCDwAAkqjiswT7FWTHZmiT1xNW0eCIMtpqk1HPsiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M41IZu+N71jZzYevMQESJrupq8Brx+GkD7zX25xGXk65ZowfqfTUTR2tzHEdXuE+2
	 RsxAmAZkbPA+0PTjd+/lSBzgvywBlXMhHV2KonHVScpIwk2+lOyNPE/R704//OwoCS
	 97ThIywp0GEULQDOoQA9v7Easpbu2sFQUk94AqSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 086/246] KVM: s390: pv: fix asynchronous teardown for small VMs
Date: Mon, 15 May 2023 18:24:58 +0200
Message-Id: <20230515161725.164984224@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 292a7d6fca33df70ca4b8e9b0d0e74adf87582dc ]

On machines without the Destroy Secure Configuration Fast UVC, the
topmost level of page tables is set aside and freed asynchronously
as last step of the asynchronous teardown.

Each gmap has a host_to_guest radix tree mapping host (userspace)
addresses (with 1M granularity) to gmap segment table entries (pmds).

If a guest is smaller than 2GB, the topmost level of page tables is the
segment table (i.e. there are only 2 levels). Replacing it means that
the pointers in the host_to_guest mapping would become stale and cause
all kinds of nasty issues.

This patch fixes the issue by disallowing asynchronous teardown for
guests with only 2 levels of page tables. Userspace should (and already
does) try using the normal destroy if the asynchronous one fails.

Update s390_replace_asce so it refuses to replace segment type ASCEs.
This is still needed in case the normal destroy VM fails.

Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
Reviewed-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20230421085036.52511-2-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/pv.c  | 5 +++++
 arch/s390/mm/gmap.c | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index e032ebbf51b97..3ce5f4351156a 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -314,6 +314,11 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 	 */
 	if (kvm->arch.pv.set_aside)
 		return -EINVAL;
+
+	/* Guest with segment type ASCE, refuse to destroy asynchronously */
+	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
+		return -EINVAL;
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 5a716bdcba05b..2267cf9819b2f 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2833,6 +2833,9 @@ EXPORT_SYMBOL_GPL(s390_unlist_old_asce);
  * s390_replace_asce - Try to replace the current ASCE of a gmap with a copy
  * @gmap: the gmap whose ASCE needs to be replaced
  *
+ * If the ASCE is a SEGMENT type then this function will return -EINVAL,
+ * otherwise the pointers in the host_to_guest radix tree will keep pointing
+ * to the wrong pages, causing use-after-free and memory corruption.
  * If the allocation of the new top level page table fails, the ASCE is not
  * replaced.
  * In any case, the old ASCE is always removed from the gmap CRST list.
@@ -2847,6 +2850,10 @@ int s390_replace_asce(struct gmap *gmap)
 
 	s390_unlist_old_asce(gmap);
 
+	/* Replacing segment type ASCEs would cause serious issues */
+	if ((gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
+		return -EINVAL;
+
 	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
-- 
2.39.2



