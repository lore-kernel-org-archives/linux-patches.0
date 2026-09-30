Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D69E3B1016;
	Wed, 30 Sep 2026 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792170; cv=none; b=dM8dH1J7dNoWddQJ6utTX/0sWRxOZrP/H4Cfq9086/LUY5vjANKiCdddS67kbX/bZ5ux5d3B7yg2Ps+WGbYnE2GhDJV+02hcYlp60Khbc59ZL/89xT90x+Lcj2ERIoJNc2tHEUZSso4c7mPN6XaYKBHZY2xZJdBqBY5I61Crf6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792170; c=relaxed/simple;
	bh=2ScBfSRW9ScsUt1ZEAAXLup7laOvoTAcrDsExyYOQKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D98mWRE16LZizofGoR5EwCMdfkVa80LVUayBdEUh13g+ixi6SGMKAD6cdvz/481TNuTgMdZ3vysv7QLwoilO2wZ7QKvdxm+aGM7FQDzYLzPa28PgVg8GR/zgJzB1WNHw5pI/GIhDPRSbzqk6gcl0zVDT3bCBZUqeir20YF6Wkgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAHtAWFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAHtAWFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882BF1F000FF;
	Wed, 30 Sep 2026 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792169;
	bh=sXy82vMHLTGjPumUW4U66s21b8UVG+OUHL5HYOB1FMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAHtAWFgWM9OFQrtwyKH2vmNmyobgVe7EP3Mw42NFPcT9ZHWQf2MLg2KN/hQyeCyE
	 5bN12SC5CnfN7edsfgkvrUgYhdea3mHV/gifXvMTVBWsNDpruF87kd6QwUca70hAo7
	 xO75t1lqvBe//OeU48ki+iUNpHHhQoj2l1jext0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	hackyzh002 <hackyzh002@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 515/752] drm/amdgpu: Fix integer overflow in amdgpu_cs_pass1
Date: Wed, 30 Sep 2026 17:26:25 +0200
Message-ID: <20260930152409.401020954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: hackyzh002 <hackyzh002@gmail.com>

commit 87c2213e85bd81e4a9a4d0880c256568794ae388 upstream.

The type of size is unsigned int, if size is 0x40000000, there will
be an integer overflow, size will be zero after size *= sizeof(uint32_t),
will cause uninitialized memory to be referenced later.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: hackyzh002 <hackyzh002@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -99,7 +99,8 @@ static int amdgpu_cs_parser_init(struct
 	struct amdgpu_vm *vm = &fpriv->vm;
 	uint64_t *chunk_array_user;
 	uint64_t *chunk_array;
-	unsigned size, num_ibs = 0;
+	size_t size;
+	unsigned int num_ibs = 0;
 	uint32_t uf_offset = 0;
 	int i;
 	int ret;


