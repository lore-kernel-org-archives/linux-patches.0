Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C4E1C7274;
	Tue, 15 Oct 2024 11:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992681; cv=none; b=hgxWND5Z5phXBkmKIGhKgITb8jwSSkIYSxd2wzSCwDFDtRoO2uD5ZeTEBTMx239lvAXAHvQUDoY1jbugFvT6R2R97BBeKdUpc2uO3roaXeOSKWVuvMYhDhGvcG2P+DDxm6jlhy6g0exjCssw3lJ2xwQBBb9wmGBssixZb3JqdqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992681; c=relaxed/simple;
	bh=BHlBbTg/2cb7BTbLijRbHjl2+GPAuU51WqW6ZcpBrnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Si2XhtPLiftA+rP36lX5D6w0+ZP1H2FVTkOABptEcGvRBk+fvxKBuz+NppXJ9IlU3cImO4WUiVxNdgaBzqXPirDV1fheYOmeaK+VBpAMiT4PbQp6jcFY8hMe5yjzW6hu9uV4dV82z7lYnZtO5VHZ7uUNBKZ4E+tTlWg7p/XDDFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZH9BMlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZH9BMlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BA2C4CEC6;
	Tue, 15 Oct 2024 11:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992681;
	bh=BHlBbTg/2cb7BTbLijRbHjl2+GPAuU51WqW6ZcpBrnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZH9BMlUwzsFKhHahKG4uECSpd8WezfET4gHNO31hHJFSGYXTcF2B8B7aDBc3szzt
	 Ux1Q4qbNMO+aAf+Rind0YScVCyJCYnFoiOLpmKRxBqKwHj/9qzxe08N+bE1F5WpVps
	 7Zvyz3AwSWzuOBqQ1VNGVvLnoTvaDQStx2CoE1q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/691] xen: use correct end address of kernel for conflict checking
Date: Tue, 15 Oct 2024 13:22:16 +0200
Message-ID: <20241015112447.821200239@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1f80dd3a2dd4a..629c94d1ab24c 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -856,7 +856,7 @@ char * __init xen_memory_setup(void)
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



