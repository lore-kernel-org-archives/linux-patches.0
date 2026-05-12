Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE18B37F012;
	Tue, 12 May 2026 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609671; cv=none; b=qqMwfEU86vUyHRhKgfmS8sy3ZivIPDPA9mr5ns6bQZzAzkY7SPB3jPVtPGJHaLdw2K5xP2/Me3LUUxy4r6YJgcSE/OEnxLDAR+Z/RJ/F79VU6qBjkbOIRHVnYV09bhmVT8/HmJU5IuaJDI4PKjbl/3IjKVKr33pLRBVIrdQae3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609671; c=relaxed/simple;
	bh=vJ8Pd+nZngrjR99dA9bl3KVZ859gAWgLki0NhCyIndg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfZANtVRZ3k9rFaaQkfCFEyTP8GoRxK93QtEjlORuJaEuamDuM63f0eqQAfz+2B2I5XkApTIID/QIcRwmjloZRmThWHKlfbKXeRSn89ihgFSt5VZVjXoKMtd1LGCt3dfJD406AYELsyzuCwe0hRVpOoCui4KGkpN0rAWGxzrMl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIiYEaCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIiYEaCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676CFC2BCC7;
	Tue, 12 May 2026 18:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609671;
	bh=vJ8Pd+nZngrjR99dA9bl3KVZ859gAWgLki0NhCyIndg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIiYEaCvWH6JyZGkakHafv7S5JBVJg1x+R7dVYyHb7LP6thaWbA5N1jZzApkjIOaP
	 eGInRZnWp0nWD872jSdkay0s1aoDneIiZlT9LKOx2FFuzHRB180RdLlqHIFDlsbnGN
	 32CDoApFowFSRodDQMKLQg7AqIov+IC9V2dJ2BQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 285/307] LoongArch: KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date: Tue, 12 May 2026 19:41:20 +0200
Message-ID: <20260512173946.140559613@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

commit b3e31a6650d4cab63f0814c37c0b360372c6ee9e upstream.

It doesn't make sense to return the recommended maximum number of vCPUs
which exceeds the maximum possible number of vCPUs.

Other architectures have already done this, such as commit 57a2e13ebdda
("KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS")

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -125,7 +125,7 @@ int kvm_vm_ioctl_check_extension(struct
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;


