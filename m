Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D46330B05;
	Fri, 17 Oct 2025 15:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715539; cv=none; b=IFR/2C4HH9I7GzgRTyHypNIJ6t2rgmhRuEf65z6p8xweG4PxEy/B6wxMRFRwJ84j+jW1mGtf8WkDs7tmiyJAr5+CC4qlNKc5YLBzyabrL8kYNdylZy0LVjl82QgwHN+VwFrV6BVRcuGjvfNOK4NrN3Tru5XYVSIkMN4vsnasYIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715539; c=relaxed/simple;
	bh=aGsPVbV/cuikQx1NTVBPAQRASHBCW6d3XQSk50w1nAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCFwNZBAQB/RRGNjd3QZ4TQRrv6Y9XTTyUnllRmhw3n+YKQ83aIh3ntzTCR+UmtmTr6UF2nG8n74tN1sc6/owUz9OK0G5TsHlIXJVFIG4fUn3yGbBBclAm4sp5JIZtviRrMlIhTVzbJt3vIKK1ZyemiWyhsNWq4mfJOzCJPWCiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scFyxn7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scFyxn7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C03AC4CEE7;
	Fri, 17 Oct 2025 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715538;
	bh=aGsPVbV/cuikQx1NTVBPAQRASHBCW6d3XQSk50w1nAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scFyxn7xSrZnAlwABeNKP1Kh77WEWrfGqMNc7tAiA/C9eBI+2YF2zIr/obvinpGYh
	 A1dE6pJv8sIFFW6OZXrm6g/mN6Rwd366x5Osq8fgmuLwIRX+nWti0hVoUaXgnbHVLP
	 CzBMingNLn68DV4kOqYXXCmXJW0OFKIndBMn5SaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 234/371] kho: only fill kimage if KHO is finalized
Date: Fri, 17 Oct 2025 16:53:29 +0200
Message-ID: <20251017145210.548948860@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Pratyush Yadav <pratyush@kernel.org>

commit f322a97aeb2a05b6b1ee17629145eb02e1a4c6a0 upstream.

kho_fill_kimage() only checks for KHO being enabled before filling in the
FDT to the image.  KHO being enabled does not mean that the kernel has
data to hand over.  That happens when KHO is finalized.

When a kexec is done with KHO enabled but not finalized, the FDT page is
allocated but not initialized.  FDT initialization happens after finalize.
This means the KHO segment is filled in but the FDT contains garbage
data.

This leads to the below error messages in the next kernel:

    [    0.000000] KHO: setup: handover FDT (0x10116b000) is invalid: -9
    [    0.000000] KHO: disabling KHO revival: -22

There is no problem in practice, and the next kernel boots and works fine.
But this still leads to misleading error messages and garbage being
handed over.

Only fill in KHO segment when KHO is finalized.  When KHO is not enabled,
the debugfs interface is not created and there is no way to finalize it
anyway.  So the check for kho_enable is not needed, and kho_out.finalize
alone is enough.

Link: https://lkml.kernel.org/r/20250918170617.91413-1-pratyush@kernel.org
Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1233,7 +1233,7 @@ int kho_fill_kimage(struct kimage *image
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_enable)
+	if (!kho_out.finalized)
 		return 0;
 
 	image->kho.fdt = page_to_phys(kho_out.ser.fdt);


