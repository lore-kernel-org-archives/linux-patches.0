Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE071D04A8;
	Wed,  2 Oct 2024 14:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879670; cv=none; b=ng9PoknPR00cs/m6liJ227y6pwiCXYmr/ijxl9JRp67hUHmlxtmgDISXJc5r+DSxK1MS9GITexT62eFjh1v/KhxYRIgZUL2OKv3RiZAALOzALBmNiMyf7R/Bux8fQBNp1BoO5uMGU+bN2sy3WAbHUgj+rTyGqGU3FkAikWdQm2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879670; c=relaxed/simple;
	bh=RdCMmyztdzX6N+fzCe2Xsb1Fllykddb07v4aKGiP21k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEWBf2Bi8GYizUVmOv8KRLwBq05Q5JsaPfbpNbcr7M6USuu25Wfkbw0nf2MMyJ4eQ1b8WIlajUoh3+a+r1SMJsAUhgmOuS1WbJwWuh1FxuWh3SuSa07nQwtKapCs6n5X116rmrZ4RaealmL3nx5DO9HzwcezT4qFcGdnikl+3bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSEjaREP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSEjaREP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E15C4CEC2;
	Wed,  2 Oct 2024 14:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879670;
	bh=RdCMmyztdzX6N+fzCe2Xsb1Fllykddb07v4aKGiP21k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSEjaREPXHoIcgYKP+ppbDWw4R/Qnzir0jGf2z37kL+M2J7jd0UvDYxYong48zYra
	 sfdpDZ3Te2HEpkoxupWM6udO8DBleSP6iQQlygJMmTTndivUsNrZoirp9mxiYBldsX
	 F0jGc39u0bFR5rBwqjtZb/lwey2tpBaYvAo1yLNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/538] xen: use correct end address of kernel for conflict checking
Date: Wed,  2 Oct 2024 14:56:46 +0200
Message-ID: <20241002125758.845690281@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit fac1bceeeb04886fc2ee952672e6e6c85ce41dca ]

When running as a Xen PV dom0 the kernel is loaded by the hypervisor
using a different memory map than that of the host. In order to
minimize the required changes in the kernel, the kernel adapts its
memory map to that of the host. In order to do that it is checking
for conflicts of its load address with the host memory map.

Unfortunately the tested memory range does not include the .brk
area, which might result in crashes or memory corruption when this
area does conflict with the memory map of the host.

Fix the test by using the _end label instead of __bss_stop.

Fixes: 808fdb71936c ("xen: check for kernel memory conflicting with memory layout")

Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 380591028cb8f..d44d6d8b33195 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -825,7 +825,7 @@ char * __init xen_memory_setup(void)
 	 * to relocating (and even reusing) pages with kernel text or data.
 	 */
 	if (xen_is_e820_reserved(__pa_symbol(_text),
-			__pa_symbol(__bss_stop) - __pa_symbol(_text))) {
+				 __pa_symbol(_end) - __pa_symbol(_text))) {
 		xen_raw_console_write("Xen hypervisor allocated kernel memory conflicts with E820 map\n");
 		BUG();
 	}
-- 
2.43.0



