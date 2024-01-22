Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3F433097;
	Tue, 23 Jan 2024 00:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969664; cv=none; b=Y2LpzLSu0MqVCpZncq5I0K8NSjcND1Z/O0FiDxQW5oqJrsSPEDoHI9qIRCCQrrGzoxx4f/m09/D3uUHf1h0cLLBkQ2AV/sduWqvEGX4sNXu71BAxDvpoNXgs2yydS2Xq8Ekrb1qAaWCs6jXrlYkA48JfInrLSt9q8czIqt+dnEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969664; c=relaxed/simple;
	bh=LIhKsIEPMYh0Dsya1G0UyxzeSyuz6vgb817Zehf854E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTG0hufFzq9tZaqeE8/NY5knkhPIDOIFtSqlCWEqXKYmhhsB4jrNWrBGJWhKOCG46bXqoh2OOlTl2K8v+fnQjRG0BahR+XzKuBLhFt0D50uXL5firZxsjSrI4basht0oiNZPWVARKg36O6wMA3nQ36HG5fzLM887VzxSbolp9kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0YnZOVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0YnZOVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5048DC433C7;
	Tue, 23 Jan 2024 00:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969664;
	bh=LIhKsIEPMYh0Dsya1G0UyxzeSyuz6vgb817Zehf854E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0YnZOVq6LFSTFJ9n8Wq4Jul50P1rhHXZXij5sy9xwTqoFtKJG/U77/d4NtU46FNL
	 eliXQO8wimPa9FHDn5TuCN5+TbrZAWBhDjcQQFTfSOtVn6DF9lbgI2IdrD0KlG3kHB
	 Znn/+tAgrKkU29Qh0V9Sg/+9Ids8qOBNJb8jp+DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Subject: [PATCH 6.7 391/641] powerpc/64s: Increase default stack size to 32KB
Date: Mon, 22 Jan 2024 15:54:55 -0800
Message-ID: <20240122235830.184819507@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

commit 18f14afe281648e31ed35c9ad2fcb724c4838ad9 upstream.

There are reports of kernels crashing due to stack overflow while
running OpenShift (Kubernetes). The primary contributor to the stack
usage seems to be openvswitch, which is used by OVN-Kubernetes (based on
OVN (Open Virtual Network)), but NFS also contributes in some stack
traces.

There may be some opportunities to reduce stack usage in the openvswitch
code, but doing so potentially require tradeoffs vs performance, and
also requires testing across architectures.

Looking at stack usage across the kernel (using -fstack-usage), shows
that ppc64le stack frames are on average 50-100% larger than the
equivalent function built for x86-64. Which is not surprising given the
minimum stack frame size is 32 bytes on ppc64le vs 16 bytes on x86-64.

So increase the default stack size to 32KB for the modern 64-bit Book3S
platforms, ie. pseries (virtualised) and powernv (bare metal). That
leaves the older systems like G5s, and the AmigaOne (pasemi) with a 16KB
stack which should be sufficient on those machines.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Link: https://msgid.link/20231215124449.317597-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -858,6 +858,7 @@ config THREAD_SHIFT
 	int "Thread shift" if EXPERT
 	range 13 15
 	default "15" if PPC_256K_PAGES
+	default "15" if PPC_PSERIES || PPC_POWERNV
 	default "14" if PPC64
 	default "13"
 	help


