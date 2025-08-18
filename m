Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6612C235C;
	Mon, 18 Aug 2025 13:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523905; cv=none; b=tDLjciE3+QnsZkuC+hbqbXL1kmxyU60c/BeUgRwg6lEEJHJkBDXhZ2lkEduvqFOjlZmTr0+cMR1EQQB1Za1jLbXSPyz9JWPUHY+KAT3UAnFf89rw1QUq9w7VVrTKC2ME8On+TVvPjUXK0hVVahHZPVfH/1RhnVUZk8puMz1Mk/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523905; c=relaxed/simple;
	bh=LzBJjkWqb1j2LtrnS0f2HcIFHG9e/L/II3DIFHdlxqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOVzwNxP3n9PVjJ+DOCyb0ew+84dezCVjsckXVUF1h/iJMABw7JqGUtF9LULffXJn7DGss6xaA8OXZwoEVYQm8adj+Hqe5G38kK6tvCATocU6FngQ/TPLjECdG12thT2jULtMvsMyXduRxyfyvVLM9aeoGSKm/g7TDQgJeeXVpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnoQC+Pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnoQC+Pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9772DC2BC9E;
	Mon, 18 Aug 2025 13:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523905;
	bh=LzBJjkWqb1j2LtrnS0f2HcIFHG9e/L/II3DIFHdlxqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnoQC+PiHEtERkhqYLKdPdSEYv4uyfBEmHYehoUCj/4VlUiaohouSwR6kCVLYpIRM
	 bt07E2/vHtfccMuLKWMp/eDXUeN7H8M1vADw9Te/J/C1DKMjnJbtcdPuxCyRWadmPu
	 an76eHm80s5acLJGDGzXoItHbpfijGkHSM7fvfFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 291/515] powerpc: floppy: Add missing checks after DMA map
Date: Mon, 18 Aug 2025 14:44:37 +0200
Message-ID: <20250818124509.622047690@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit cf183c1730f2634245da35e9b5d53381b787d112 ]

The DMA map functions can fail and should be tested for errors.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250620075602.12575-1-fourier.thomas@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/floppy.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/floppy.h b/arch/powerpc/include/asm/floppy.h
index f8ce178b43b7..34abf8bea2cc 100644
--- a/arch/powerpc/include/asm/floppy.h
+++ b/arch/powerpc/include/asm/floppy.h
@@ -144,9 +144,12 @@ static int hard_dma_setup(char *addr, unsigned long size, int mode, int io)
 		bus_addr = 0;
 	}
 
-	if (!bus_addr)	/* need to map it */
+	if (!bus_addr) {	/* need to map it */
 		bus_addr = dma_map_single(&isa_bridge_pcidev->dev, addr, size,
 					  dir);
+		if (dma_mapping_error(&isa_bridge_pcidev->dev, bus_addr))
+			return -ENOMEM;
+	}
 
 	/* remember this one as prev */
 	prev_addr = addr;
-- 
2.39.5



