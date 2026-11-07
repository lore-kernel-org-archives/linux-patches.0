Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062210;
	b=JSV6gtOZ+EWCL8ChYKjA48nSU4psX5dK+sXe0TI2gdr7nKHWaAAfncri86JziY5Un8Le
	 jSIBx6fdbmK9DY6VyFf7brvy0FFS0aeLib0EXR8GLbS35Kvucrkr/jjdXYKHs4Et0OkhO
	 z/D8j3vWIr32T0zCpXQ0UBB3Pgiew2L6paw/Th4f15R9nDSLr9OjU+rIhZTEVdmJbCamU
	 iIMBbY5bah6twXIfLkYpxCJRhx/L72g00Z8M7vgVoGBGqgyS1m2WKy23t1DAuBQa7T/z0
	 JvEipnztYGq6If2H/hTdUhrHGzzRgtfKzbgqvr2lh2OBM1SFgw3vhqVy2a3evBSo53g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dOR0Ep5nP+jUzokOw+2yQZdBTpUcQA3akuNFlcY2tp8=;
	b=paKkrMOU6lC9YU1MaiR54zdp1buzEsGZ8pt7jH63e7/sNI/d42dw0fHhxaI+yIK+HQo0
	 IfCuEwUEc6AKOAPHj26NIWFf1t3N1EiZELHJValk/n7YO469IOi+TqXOPTtCZr+4DJfek
	 jm5k84IwuqwMzX2MfNqsYmLhd92Tvh+RZYVS/DecuSPqLVUAfGWArbyf4Cp1AUrJMHWLs
	 qNChXv9t0s77yamohEj81pFK66EXWIbTsagbzEy34peZJ4XFlYH/y4pF4w0rm/CW0jYFW
	 P7+oZp++niMORaabYUaj9dF/jftpu5yz6Z/M4S2lm2UQagH5Dr9TARTYLVUB8xr496w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iz5VtfG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA28606A33A;
	Sat,  7 Nov 2026 14:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iz5VtfG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01E51F0089F;
	Sat,  7 Nov 2026 14:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062209;
	bh=dOR0Ep5nP+jUzokOw+2yQZdBTpUcQA3akuNFlcY2tp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1iz5VtfGs7551v9pb1CKA9Y0oxpWdbsOdteL2u0v4US+jtr6lLIeBfHBZDVJGA/tH
	 w8rcaieBVxrdQPXLeQ5r5tsqwBcQBqLLF/c8gh3gFkc6UwYVMSbKyvz/5ONWUpegpe
	 WdWsWtUH2YI8kkGoSR/4PrlibYEilnJx2g603HNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1165/1536] PCI/AER: Fix memory leak in aer_recover_queue() on kfifo buffer overflow
Date: Sat,  7 Nov 2026 08:53:01 -0500
Message-ID: <20261107135030.452123878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priyank Rathod <rathodpriyank@google.com>

[ Upstream commit 07938f8a3cbf3e9cc27553b8982e2d56c15b354a ]

When ACPI APEI/GHES processes PCIe AER error records, it allocates memory
for aer_capability_regs (aer_regs) from ghes_estatus_pool and passes it to
aer_recover_queue() to be enqueued into aer_recover_ring.

If kfifo_in_spinlocked() fails due to a buffer overflow,
aer_recover_queue() logged an error message but returned without freeing
aer_regs. Because the entry was rejected and never inserted into the queue,
aer_recover_work_func() could never dequeue or free it, leaking the
allocated ghes_estatus_pool memory.

aer_recover_queue() returns void, so the caller ghes_handle_aer() cannot
free the buffer itself: ownership is transferred to the AER code, which
until now only released it on the success path.

Free aer_regs via ghes_estatus_pool_region_free() when
kfifo_in_spinlocked() fails on buffer overflow.

Fixes: e2abc47a5a1a ("ACPI: APEI: Fix AER info corruption when error status data has multiple sections")
Signed-off-by: Priyank Rathod <rathodpriyank@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928-b4-fix-aer-memleaks-v5-1-ba6b94c9c9a6@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 592b40e51eaa2..229853e9d565e 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1196,11 +1196,14 @@ void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
 	};
 
 	if (kfifo_in_spinlocked(&aer_recover_ring, &entry, 1,
-				 &aer_recover_ring_lock))
+				 &aer_recover_ring_lock)) {
 		schedule_work(&aer_recover_work);
-	else
+	} else {
 		pr_err("buffer overflow in recovery for %04x:%02x:%02x.%x\n",
 		       domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
+		ghes_estatus_pool_region_free((unsigned long)aer_regs,
+					      sizeof(struct aer_capability_regs));
+	}
 }
 EXPORT_SYMBOL_GPL(aer_recover_queue);
 #endif
-- 
2.53.0



