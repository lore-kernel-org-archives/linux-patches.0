Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650274F7CBF;
	Wed, 30 Sep 2026 17:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787901; cv=none; b=nAcKyixlfcg5Wl5WAOnCxwFIJUaNkHBG26A3Q38rDQ28QKIelk7NH9sgYo/lv1DxZF5hbuG+0yx7BXHB+ovFhZvufPZ6m+/JmPzWamt62R1yC6n2xGl/M/Wp521I6NWn5DMWNo/AwVyBh0Bfv2SxhnbyhA3lTlorIjhF6I9ovrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787901; c=relaxed/simple;
	bh=BwLzx/nwpNCknjEe/bU1zkagjjvP8eLFyhKhj+78HH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROjS+MdRvi7eBA4bH0Go2C5Ma3mn0F0H+YwTfKz12Y6lDd7aYxlTkuCoftSflizUKcFUcpOzni0T9phP1Tm5c+0V9oaZdaPihEPSBSxvMFqZ79fsyxy35/c+AUSL3HWYlj14MaqtTP/IusOZmWZr39+9IOq6e3f6QNbV6FnqRqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhnpUfeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhnpUfeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7EF1F000FF;
	Wed, 30 Sep 2026 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787899;
	bh=Af+n9ry/pkkfLv0s/wBHXx65okFYewfeaCIxYRabJPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhnpUfeo7vaYaMXqEEXC6uZc4wEG1dJmtd886SrWb+fykPp5D3O827nhmniXLx37D
	 PMDJSEB5cBIgiz7CyczP0AnS0ba8BBbK47BTA2kXd2PxfF0S9moOF/wI5I6tjwlaI7
	 TRO3DSsrBIsP79rMB/+YgP+SFL9eQfJNMRiIMogM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hiroyuki Katsura <hk590@cam.ac.uk>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Vincent Donnefort <vdonnefort@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 391/457] KVM: arm64: Transfer the hyp stack pages out of the host stage-2
Date: Wed, 30 Sep 2026 17:28:16 +0200
Message-ID: <20260930152354.434820438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

commit 3a8c562892b96f35bba1e00d5e455a15963bbb92 upstream.

fix_host_ownership() walks only the linear-map alias of each memblock
region, and the per-CPU hyp stack, mapped in the private VA range for
its guard page, has none.

Walk each stack's VA range with the same walker.

Fixes: 1a919b17ef012 ("KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack")
Reported-by: Hiroyuki Katsura <hk590@cam.ac.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260908110713.1540304-2-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -269,6 +269,16 @@ static int fix_host_ownership(void)
 			return ret;
 	}
 
+	/* The stacks sit in the private VA range, not the linear map. */
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		struct kvm_nvhe_init_params *params = per_cpu_ptr(&kvm_init_params, i);
+		u64 start = params->stack_hyp_va - NVHE_STACK_SIZE;
+
+		ret = kvm_pgtable_walk(&pkvm_pgtable, start, NVHE_STACK_SIZE, &walker);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 


