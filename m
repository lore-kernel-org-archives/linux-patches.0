Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5931DFE3B;
	Wed,  6 Nov 2024 12:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897982; cv=none; b=Osc77kiDhdvYzHnJVotK4RDdcUj1hge+5DtbcfJ1nZEuMmFWpykhYR0iVBsInbICnStfNQ5n1hQA3+LO1JAxjWTSc7xpmhiO+I7ra3sAnGx8W6E0//4gzhKFIGJg6XwRdKadob7gCSZ7Ia9pZxBdPWuvqTTYS8ixT9GCo5WfdEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897982; c=relaxed/simple;
	bh=RFKY2VEjZ1BJrxcO9AlslDSGs8RPFPfYEhQn0BEL/d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Evg1u2P/qvkCOHe8PGSN1wgqGAc1ChZgRluaJrGKdt91NO+Fk51OoFUBh4sSUcXD2Irxsuvh0qYSUMSMmiFn4faA5zl6WmmhpYIetzTcj4noulpU+wQym5wg6VEmx3eRuegOAcJXkFLHnwNWOWJZHRvdODUf179rjO7+O542hB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vv4Cy5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vv4Cy5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FCDC4CECD;
	Wed,  6 Nov 2024 12:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897982;
	bh=RFKY2VEjZ1BJrxcO9AlslDSGs8RPFPfYEhQn0BEL/d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vv4Cy5YyrRh9csVu6AzN0uz/KygWlGutabIC32hN4rP4UFvMoHNTmyLxZjItwju+
	 RQ1qTVdsG1/EpYIih8SABl38LP6XLsuKEAm3TpfcRz3gAKxx9QcXnulfboAoQo2gOH
	 eUzNZ624zcB9NVIbxLBkJAwZCijFNeM1R5l5C2/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/462] xen: use correct end address of kernel for conflict checking
Date: Wed,  6 Nov 2024 12:59:38 +0100
Message-ID: <20241106120333.605251124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 548d1e0a5ba10..d19fcca0b30b3 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -875,7 +875,7 @@ char * __init xen_memory_setup(void)
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



