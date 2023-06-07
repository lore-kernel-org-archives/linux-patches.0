Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632773AE54
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E06C433EF;
	Wed,  7 Jun 2023 20:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169937;
	bh=NEaROYcbIPGXtYk3F7lfPK5ONPcQHToMLeBKhLbdS08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhKWs+WeV2V0FHuMvGD7rypK3Ynx8iYE08aQ7U36uEifxmRWDBxnMTFj7yEvs5plh
	 sZUCbOgagAthqophd2TfgvZFOV36cgmg1CBPORQBZ6mQojYqC9mgbfygbAJCHOrK1L
	 hsrl3u0Cqwnjugrc9f3AVJvlYwqblI+6BTJxFc4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.3 271/286] KVM: arm64: Drop last page ref in kvm_pgtable_stage2_free_removed()
Date: Wed,  7 Jun 2023 22:16:10 +0200
Message-ID: <20230607200932.152859286@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

commit f6a27d6dc51b288106adaf053cff9c9b9cc12c4e upstream.

The reference count on page table allocations is increased for every
'counted' PTE (valid or donated) in the table in addition to the initial
reference from ->zalloc_page(). kvm_pgtable_stage2_free_removed() fails
to drop the last reference on the root of the table walk, meaning we
leak memory.

Fix it by dropping the last reference after the free walker returns,
at which point all references for 'counted' PTEs have been released.

Cc: stable@vger.kernel.org
Fixes: 5c359cca1faf ("KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make")
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230530193213.1663411-1-oliver.upton@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1333,4 +1333,7 @@ void kvm_pgtable_stage2_free_removed(str
 	};
 
 	WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level + 1));
+
+	WARN_ON(mm_ops->page_count(pgtable) != 1);
+	mm_ops->put_page(pgtable);
 }


