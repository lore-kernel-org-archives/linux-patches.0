Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1B94C3A0;
	Mon,  8 Jan 2024 15:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZGOT/3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD35C433CB;
	Mon,  8 Jan 2024 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726926;
	bh=T1wUFqNeZbuSbwW4jXuIq48xUusz1s6py17BngTN3k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZGOT/3YpAdZV1trUfR6Hrim60RdtZ27nRtnc9lNULUQH1DDSnoiPJaHY7GUn3Cd2
	 p0726J5JwcZ95t6bCCaGm0+6LAWPnE1ZjfoliBeMGG1F4lygZ3Su1yFbrTvaIl6EHU
	 2XlNLg3bYbqyIgIKUV/9mtOkGLaOCFAP/Q0557Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Boehr <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/124] KVM: s390: vsie: fix wrong VIR 37 when MSO is used
Date: Mon,  8 Jan 2024 16:08:29 +0100
Message-ID: <20240108150606.800950316@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 80aea01c48971a1fffc0252d036995572d84950d ]

When the host invalidates a guest page, it will also check if the page
was used to map the prefix of any guest CPUs, in which case they are
stopped and marked as needing a prefix refresh. Upon starting the
affected CPUs again, their prefix pages are explicitly faulted in and
revalidated if they had been invalidated. A bit in the PGSTEs indicates
whether or not a page might contain a prefix. The bit is allowed to
overindicate. Pages above 2G are skipped, because they cannot be
prefixes, since KVM runs all guests with MSO = 0.

The same applies for nested guests (VSIE). When the host invalidates a
guest page that maps the prefix of the nested guest, it has to stop the
affected nested guest CPUs and mark them as needing a prefix refresh.
The same PGSTE bit used for the guest prefix is also used for the
nested guest. Pages above 2G are skipped like for normal guests, which
is the source of the bug.

The nested guest runs is the guest primary address space. The guest
could be running the nested guest using MSO != 0. If the MSO + prefix
for the nested guest is above 2G, the check for nested prefix will skip
it. This will cause the invalidation notifier to not stop the CPUs of
the nested guest and not mark them as needing refresh. When the nested
guest is run again, its prefix will not be refreshed, since it has not
been marked for refresh. This will cause a fatal validity intercept
with VIR code 37.

Fix this by removing the check for 2G for nested guests. Now all
invalidations of pages with the notify bit set will always scan the
existing VSIE shadow state descriptors.

This allows to catch invalidations of nested guest prefix mappings even
when the prefix is above 2G in the guest virtual address space.

Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtualization")
Tested-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Message-ID: <20231102153549.53984-1-imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/vsie.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 61499293c2ac3..e55f489e1fb79 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -587,10 +587,6 @@ void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
 
 	if (!gmap_is_shadow(gmap))
 		return;
-	if (start >= 1UL << 31)
-		/* We are only interested in prefix pages */
-		return;
-
 	/*
 	 * Only new shadow blocks are added to the list during runtime,
 	 * therefore we can safely reference them all the time.
-- 
2.43.0



