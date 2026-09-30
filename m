Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BD24CCDF1;
	Wed, 30 Sep 2026 15:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783488; cv=none; b=ELXJPSJScqgMY6LwKmCC2796mXg2qIJ1+Z9XAR5xHSXwpSAxaA3I1JSdJq4fZcpVj38x4zaW8OuzJAkO5zDPActekCgTbizHQB9VeHq1N/s7NfstsEIItbEA5/3sMc24rLUw5+fDfyaAT2uV+bY2DbriIExdgvupA7f/fzBOopE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783488; c=relaxed/simple;
	bh=0bJmCIKe/LB7n4jCerfE2vnyWGvw9Q3BW/kHvRhnfXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IrqbJXLcuWI7Ng96fOitDYYS1/xSJh5WkW+ydRapAXF2vzg2qWx0tSr19OTW/kyR6QQRlYABjveaVOksSeSLPf5Ngx+habfcCUsqH/vq2Y5sHCdvZCUCNr63qojubu6Q7p/Db3y+SmCGeEcJ4QYmjYQROhzB+kHpOo43/I6ySsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phIFtj3x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phIFtj3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2C31F00898;
	Wed, 30 Sep 2026 15:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783484;
	bh=C2pBU1GbUXL8nmhKSpvax70J6KeBhnalFzYYIkWiDtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phIFtj3x3tVE62wsLLBHixYbxdJIb4FhQhYCtBMzTPWx4tbsDcXzw1OzPlbf27yff
	 bEQmbi8LHpt+icJFizWT6Kg68e4dlX03+m47EiyPYStI/91sfe7s68v4e3+3fs5gFk
	 /Hi2RDkQiE7P4MJf9hqy8al86+FDRmQb19FTg2/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	hackyzh002 <hackyzh002@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 416/595] drm/amdgpu: Fix integer overflow in amdgpu_cs_pass1
Date: Wed, 30 Sep 2026 17:25:09 +0200
Message-ID: <20260930152356.626844618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -100,7 +100,8 @@ static int amdgpu_cs_parser_init(struct
 	struct amdgpu_vm *vm = &fpriv->vm;
 	uint64_t *chunk_array_user;
 	uint64_t *chunk_array;
-	unsigned size, num_ibs = 0;
+	size_t size;
+	unsigned int num_ibs = 0;
 	uint32_t uf_offset = 0;
 	int i;
 	int ret;


