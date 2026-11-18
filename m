Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060293;
	b=azGhOfW9+qxGguDDaw2hne912Dl3wyIglvgLVb54LwNWTDNc0IY37WfOk7X5IREaudZh
	 m8grHsmrp+LJioknbeducpE7aKJTbRvFEp0Ay3dQoITfflrLxKKEBfEPq/0BS1ZZ+nZ7C
	 FLbvbE+55f8YBujZY36urhKK7qLrdWYne1hlKWquXV4evLGlDhOcNa0F0DubuAvHRj4a9
	 I3Ow/OiWUFgrMSO6b9EE4LXtxpMgyD45vXNdLfG6UeDunALtc0bsVTFuIIjUz2ULRcRTy
	 e5TcOS3S04Zttm2rox96VbyyjOeMML8z+JiZJt+ciisj/UrapegO84Zj9juVKkdWArw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8f4exJMJ1k3xJfLeN2vnmYR6wmRK0VklaehurvLYVkg=;
	b=COvpaI8bobV2B8bOq0KyyRSEKRPmMLSU3Ohe5fRIJ5l9DKFcke5rg/jvhVqRJFZEI42t
	 2gWFu5MCrJm4btFl42zqpCG0OA1Av/U/LLe8mq8mL1+JnN54Bkc42JbDq93+SXf+BZKJa
	 AkjALHT4As3X0Mjvt/uzh3s3SltCE2JyQoeTQjzT2D15GhPIMmZBmM+lyjaFAbBkyPCfi
	 AXOeuD/fe4G8SHYu3KljzEfDFdClzQnXI9yrfHo4BWswQaCH7REoVC5Q+YqYHINHTJdHa
	 RX+N6X0djjC8opcczQc5JENNusaRw9WfY3nqpsx+3/qcEARlYKgO+5hmFJtLWOEOTJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjZsC5Tu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB841606A325;
	Thu, 19 Nov 2026 03:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjZsC5Tu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A0A1F000C4;
	Thu, 19 Nov 2026 03:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060293;
	bh=8f4exJMJ1k3xJfLeN2vnmYR6wmRK0VklaehurvLYVkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjZsC5TumS9n9ApJhLn92H6DQLfe3TovJr+T9fkDOfDiBBZiKIXD8DodAzNatFB50
	 DWvEUMd157yh0vK3kqTQrjyrddwXdQKph4pXNFdRvNRWX/Bziv2pFEg4WH5/qPRZ61
	 tWgIH5cEZV6rpyL38opmiK/q1JYyW9o2mAxEXbqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1110/1848] drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at
Date: Wed, 18 Nov 2026 15:52:28 +0100
Message-ID: <20261118150005.813338404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 63a59637517682a920f86da1a189a3e639dd4fb3 ]

For rings which parse or patch the IBs on the CPU, like JPEG and VCN,
the CS looks the IB up through its VA mapping and maps the BO, but
ignores the offset in the BO the mapping starts at. It then parses
other data than the GPU executes. On navi31, an IB of JPEG NOPs in the
second page of a BO, mapped with offset_in_bo 4096, is parsed from the
zeros in the first page and rejected:

  amdgpu 0000:03:00.0: Invalid packet [0x00000000]!

while the same IB submitted through a mapping of the whole BO works.

Add the mapping offset when locating the IB in the BO.

Fixes: 4802ce117786 ("drm/amdgpu: fix UVD/VCE VM emulation")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 74ba1d87d67d0a38d8248928241c3e1c73d0d53b)
Cc: stable@vger.kernel.org
[ sashal: adapted the pointer adjustment to use the existing offset variable in amdgpu_cs_vm_handling() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 601934f93098c..6286eadc084aa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -771,7 +771,7 @@ static int amdgpu_cs_vm_handling(struct amdgpu_cs_parser *p)
 			}
 
 			offset = m->start * AMDGPU_GPU_PAGE_SIZE;
-			kptr += va_start - offset;
+			kptr += va_start - offset + m->offset;
 
 			if (ring->funcs->parse_cs) {
 				memcpy(ib->ptr, kptr, chunk_ib->ib_bytes);
-- 
2.53.0



