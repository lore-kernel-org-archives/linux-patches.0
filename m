Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED47F3DE45C;
	Mon,  4 May 2026 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904196; cv=none; b=vFbMo+oU/ZwRKhZCoMvR39XBIIaxaVLi8pYNr5YccXQT/fTUoXuY0g3yXCo2sdvcrEEN8YL7P4xkmJqnXT+9y7yODCSKgTlw2Rh7Vu1bAVU7xFwwhmTfe3Gh57rj8re3AouQ1cVGIp+mh4tIhtd0Qo8iqmEHrtDnw3bIlVBYvPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904196; c=relaxed/simple;
	bh=5zkwftGacq1wsJJ9lSiqP0zg1VlBujx0MSp5Z91rz2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LopvHPk/r2+Us54Pq43dtsSNRUVOKI4cyL6MeJQhtrYAhmoY8gm9dflgfZe6eauXQH5d6XL0yjHVaTo/dKc6Vmz25fqWRtQD2ZlJx39My1Ki6fOt72YThXhDnoITsHAd4JSMxW/HG5MWJuKZM76yFroSu4yJq6C5RcRXTRCPaxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dals6PTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dals6PTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2FDC2BCC4;
	Mon,  4 May 2026 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904195;
	bh=5zkwftGacq1wsJJ9lSiqP0zg1VlBujx0MSp5Z91rz2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dals6PTtoLaFKFUzK/9mWpLzfb72Xwsd/87livYa7VrtYAq2bvljl/VloKY5sHXvD
	 /CUbCdHk2IsVY1ivC2Yug/VyMufmxDffhF0F3tDnIvAWE1ynXgSuxg81s3jl8SVtNP
	 7OmHosDk522HfJLXodD4FNC8AeCOPAVDXPjcWRoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 220/275] crypto: acomp - fix wrong pointer stored by acomp_save_req()
Date: Mon,  4 May 2026 15:52:40 +0200
Message-ID: <20260504135151.244474970@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit d7e20b9bd6c990773cf0c09e2642250b8a70263d upstream.

acomp_save_req() stores &req->chain in req->base.data. When
acomp_reqchain_done() is invoked on asynchronous completion, it receives
&req->chain as the data argument but casts it directly to struct
acomp_req. Since data points to the chain member, all subsequent field
accesses are at a wrong offset, resulting in memory corruption.

The issue occurs when an asynchronous hardware implementation, such as
the QAT driver, completes a request that uses the DMA virtual address
interface (e.g. acomp_request_set_src_dma()). This combination causes
crypto_acomp_compress() to enter the acomp_do_req_chain() path, which
sets acomp_reqchain_done() as the completion callback via
acomp_save_req().

With KASAN enabled, this manifests as a general protection fault in
acomp_reqchain_done():

  general protection fault, probably for non-canonical address 0xe000040000000000
  KASAN: probably user-memory-access in range [0x0000400000000000-0x0000400000000007]
  RIP: 0010:acomp_reqchain_done+0x15b/0x4e0
  Call Trace:
   <IRQ>
   qat_comp_alg_callback+0x5d/0xa0 [intel_qat]
   adf_ring_response_handler+0x376/0x8b0 [intel_qat]
   adf_response_handler+0x60/0x170 [intel_qat]
   tasklet_action_common+0x223/0x820
   handle_softirqs+0x1ab/0x640
   </IRQ>

Fix this by storing the request itself in req->base.data instead of
&req->chain, so that acomp_reqchain_done() receives the correct pointer.
Simplify acomp_restore_req() accordingly to access req->chain directly.

Fixes: 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/acompress.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -171,15 +171,13 @@ static void acomp_save_req(struct acomp_
 	state->compl = req->base.complete;
 	state->data = req->base.data;
 	req->base.complete = cplt;
-	req->base.data = state;
+	req->base.data = req;
 }
 
 static void acomp_restore_req(struct acomp_req *req)
 {
-	struct acomp_req_chain *state = req->base.data;
-
-	req->base.complete = state->compl;
-	req->base.data = state->data;
+	req->base.complete = req->chain.compl;
+	req->base.data = req->chain.data;
 }
 
 static void acomp_reqchain_virt(struct acomp_req *req)


