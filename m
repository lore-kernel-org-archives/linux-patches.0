Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4A4470459;
	Tue, 21 Jul 2026 19:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663593; cv=none; b=crRqSOFQ9s4lTsx43pKIkzTIWEUun81GZ5eySiPo/LjFZD3ei0U4cvjuukQeDZyTgvqIoffNICfzUcWdVLgyElX+PVtyoE0fdDJ392z1jcY6UTTdxxtkrjYevkYPpJfAZkh6K2m1wN/9hfBa4Nh8GpEYKGfggc2nvVor/hIqOlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663593; c=relaxed/simple;
	bh=TD7zXuk4xGQVL76na4erFi2l7TbNZWtxcmHTe5IztvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERdmPESnB0V1JkJSSeAxj3mTwS/4Xxu3MoaOX8Os3ML7e1T1FsrQO51XnW3Cy0VpqrOpE1PwkjrNwb5c7IZidtOejHlTylUh8ihKiZLTk2pyrLancfthdk7tfBUX9mu81rKnT/Ly+MRczuQPdvyRfLZ7rTqtfV3ektmxneoYwiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXpXpBVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXpXpBVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753AC1F000E9;
	Tue, 21 Jul 2026 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663592;
	bh=uOwi78d/jyA1PSDFIdBMsJmfyWFybt1F8fABoDn11Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXpXpBVI+RgxWNa/aMgw7Uvb9M2jqHNx70ZtwbBGZjRp5YEpxMuPrbX5j/mDQbjZe
	 ksNrsj2veFjWDoIZhk/5ZaHU33VoxBIp+xeiCxsIofuHdmkiG7ZHFHVqe7HnRhYi14
	 s4HqJHtEygasnDT3GCRdlGEHn3N2sY3hniPi8Elc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0828/1276] LoongArch: KVM: Check the return values for put_user()
Date: Tue, 21 Jul 2026 17:21:11 +0200
Message-ID: <20260721152504.590942977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Ma <maqianga@uniontech.com>

commit fb89e0fe2dc4246c86ad0eb0fa2b7cb2f8ba9728 upstream.

put_user() may return -EFAULT, so, when the user space address is
invalid, the caller should return -EFAULT.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1029,7 +1029,8 @@ static int kvm_loongarch_cpucfg_get_attr
 		return -ENXIO;
 	}
 
-	put_user(val, uaddr);
+	if (put_user(val, uaddr))
+		return -EFAULT;
 
 	return ret;
 }


