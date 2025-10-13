Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE0030E0E1;
	Mon, 13 Oct 2025 15:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370330; cv=none; b=BtjBCLc500jEo2Nd6c/gljaYfTMncQbU86vbpbT2D4AL9R6bEIqwSeK2a6fwrZeMaKygwTGTe2unVJzP9KLKiDz/uO5z3f4wS+ytwITL8I3ABqf5yakrBagMVaM8lfz03ZhuhuPKgsA1W/41b4+hqEmgYWwf5wIkI2GRLZDPqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370330; c=relaxed/simple;
	bh=KsN6g5xsX+ynAC40cndoNf+n8IyCRCSa1RR1LmEuJds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBdk4hyLxuHoAGZ4RAmKIF6pvvfChOQQ/E4Whf3vxyO4ljFzAV0tdmLnQ1oqY9fdzGSQu9H355KBcAqxcb+ECSwKlgAxNay/EOKQl7/ZHvknuxrZZNTgZ/FQIdRBITU2qsE36ZlN359T/Ow4qCQ/Lmqzm4bBMTwrNbfgJtpkGbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkCYw6tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkCYw6tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34698C4CEE7;
	Mon, 13 Oct 2025 15:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370329;
	bh=KsN6g5xsX+ynAC40cndoNf+n8IyCRCSa1RR1LmEuJds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkCYw6tz/KENZrq1SBpe3ACxqk+sor1gllUYb9F2iWCIaQ1E0QJed3KbhpE48ISH0
	 cIwz2P3rrYEscUZs4IiM9UC++5Yc+VdiXmAfr13eHXVmPyJ+s4lXifZIWtae2ufjWI
	 MxnAc72Yjb93CwO+W/8vU5GcWGmREro0jemM6/Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 525/563] LoongArch: BPF: Dont align trampoline size
Date: Mon, 13 Oct 2025 16:46:26 +0200
Message-ID: <20251013144430.330398845@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

commit a04731cbee6e981afa4263289a0c0059c8b2e7b9 upstream.

Currently, arch_alloc_bpf_trampoline() use bpf_prog_pack_alloc() which
will pack multiple trampolines into a huge page. So, no need to assume
the trampoline size is page aligned.

Cc: stable@vger.kernel.org
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1785,8 +1785,7 @@ int arch_bpf_trampoline_size(const struc
 
 	ret = __arch_prepare_bpf_trampoline(&ctx, &im, m, tlinks, func_addr, flags);
 
-	/* Page align */
-	return ret < 0 ? ret : round_up(ret * LOONGARCH_INSN_SIZE, PAGE_SIZE);
+	return ret < 0 ? ret : ret * LOONGARCH_INSN_SIZE;
 }
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)


