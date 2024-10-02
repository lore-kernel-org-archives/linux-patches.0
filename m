Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A31429CE7;
	Wed,  2 Oct 2024 13:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875850; cv=none; b=NFI+CHEMYJDB3qrwOzg8JKf3Xu9O5yJ3wE0N5Jv0PPSQLtizb0uKuFYaXFDoKxMdxJOOMj60Ry1h4LIQX9LDu5yzN2qdvL35zNXR6s+0tks30DExfKjGlK1M2D2b3GbMvYpmVxvgHu3pgGuHqpLSBEQhkmhgpAdK3SParTXh02g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875850; c=relaxed/simple;
	bh=ZbcTdAlR8Bo8uYj9fDmB+OOO5XalK7yr6j5P0XB2m7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DQIVDxecWOMHo0Ek6YuZqpvuK8JUN6tn+QKg6UJyBUBgBZSm6Fm2ecZ7UmW70l6bcr4TRZlhX9tP7q4Czdh9uV7s9BEuLT9Y9VL1k2lOzfp+6vkGggaKMkrb/wfaYgNouFTzst7gUNtHJWW0ziGwqdcVsJXwV/WILzOkxzJVniY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yODv759X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yODv759X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98C6C4CEC5;
	Wed,  2 Oct 2024 13:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875850;
	bh=ZbcTdAlR8Bo8uYj9fDmB+OOO5XalK7yr6j5P0XB2m7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yODv759XeJfslcWqZ9U9BozvmGSz/pc75+iTJinyfGFNI6nG0gUYbcDAie/2Jkwcm
	 4r30EEnRShi5rKZstwAolPeAqApho63Ng1SFxu5vEUY+4GQD4XwlRoKI65WzvOXeet
	 liv59DrEErVPd22buoosFhCswUGl4LsYwFxuAcIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 242/695] xen: use correct end address of kernel for conflict checking
Date: Wed,  2 Oct 2024 14:54:00 +0200
Message-ID: <20241002125832.113058258@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 806ddb2391d9b..4bcc70a71b7d4 100644
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



