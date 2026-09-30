Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84CB51FCA4;
	Wed, 30 Sep 2026 18:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793692; cv=none; b=pywf20xr7siY9fKUyndi+mjAhBuYV+X9Hk6SLP46TDk8RO2kds6blBk/7bdIeYUMfCVwn9qWgtxlnhUy5+z7XVYRCmobp42jzPsYwFw4tOGKn3cFQ+V46YmVmzaOKtWhf1HHRINxmr+lNHYpzBsWsIU/Y6zdLknw1b/tXFlbYH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793692; c=relaxed/simple;
	bh=bokIdTBTaKez5hrZVotkBZbamHsM1U3xw5ysgmsAOgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXZgKh+N6K09XLwpVa81Lg5ZYrEUDziXxVOW4mz3WhiY8Bi5IB3l2zIH9y32N0kq10r1dx7YP8cOSg9dTmjToBH0whnld5hl52UjmNM7IMbjHdETGc9v0qJBOXObyLtROj16Yi8UjbnlGd9+cRx2cQdu6oj55W+Azp9qeTSEQp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EpdFE6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EpdFE6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF3E1F000FF;
	Wed, 30 Sep 2026 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793690;
	bh=yhwc0dt/+MskCWT5y/cWQBfAdbDWW/xsf8NsZfr/4vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EpdFE6XbF8+C6bXHfpfesS34EYcH3w/DQnCBnuvXF+4+sTwJ2xIN/OPY0UzH+wLy
	 Yu2sEZ7XbcwDZMmICWBvldmg3QMmAG3u/ZrRJFi8gxqyFfP/eLYe/4AdZDuz58MTgB
	 kIV3Dd7NOYjPOJi+i3U+KsPH8MYuYetibZV9yPeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hiroyuki Katsura <hk590@cam.ac.uk>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Vincent Donnefort <vdonnefort@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 317/395] KVM: arm64: Transfer the hyp stack pages out of the host stage-2
Date: Wed, 30 Sep 2026 17:29:39 +0200
Message-ID: <20260930152347.536398796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


