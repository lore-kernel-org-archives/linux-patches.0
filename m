Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB982141A4;
	Tue, 12 Nov 2024 10:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407803; cv=none; b=kAODHQ0eMjImBm8ZgKTz8vfX6DDPgbq+iVTeTRyeCQ0iuIxxxy8F4opbTf1IsAyHswc1iNyzkA4yz1Q09CGXAsH/OeVbf/SNUGT/eP7Rnmw3HqZATkaVXOQ81+8ZVp8sIhzR8O0oRvmG6EaEbmjFV5HBJuedZUnPzTywGk8JhGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407803; c=relaxed/simple;
	bh=ZfdVV7qgQF8ByLZjtf7EavcX6CjMGFUH8Vafug4Hnek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqfxGzfQzbRWFT/jGCZrpl0w/RPzWeM0ZehpMNPQ0/9yCBRv4LeE5mEZsBxOVEOuF6IsBv2Qf8zrLdq+CeXvJB5UJozBVQEvm+t/CWKwmbTWbcTGBRmBoNdi0j4oRan9CImzu8/KAQl4UIxDTIrUDpIozbuKhoCdRZ0ZWORPPiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2iakRaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2iakRaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD91EC4CECD;
	Tue, 12 Nov 2024 10:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407803;
	bh=ZfdVV7qgQF8ByLZjtf7EavcX6CjMGFUH8Vafug4Hnek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2iakRaItsoeTRNZ8BP5BZRj86u5dHhQ25dpIdw0yKKZg6YlO4sOCbQtWY1eu7oj+
	 VEOh3uAE4pmykHGwp5EdOJF1VCn5iqnMCT4NKSozic9WTtT/hGLX9yeyQ4Z9K+90Ye
	 1DUeypiuFnt9DqnzJu+SPcTmaxoaC6Ao375SQg38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 087/119] dm-unstriped: cast an operand to sector_t to prevent potential uint32_t overflow
Date: Tue, 12 Nov 2024 11:21:35 +0100
Message-ID: <20241112101852.039983971@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

commit 5a4510c762fc04c74cff264cd4d9e9f5bf364bae upstream.

This was found by a static analyzer.
There may be a potential integer overflow issue in
unstripe_ctr(). uc->unstripe_offset and uc->unstripe_width are
defined as "sector_t"(uint64_t), while uc->unstripe,
uc->chunk_size and uc->stripes are all defined as "uint32_t".
The result of the calculation will be limited to "uint32_t"
without correct casting.
So, we recommend adding an extra cast to prevent potential
integer overflow.

Fixes: 18a5bf270532 ("dm: add unstriped target")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-unstripe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -85,8 +85,8 @@ static int unstripe_ctr(struct dm_target
 	}
 	uc->physical_start = start;
 
-	uc->unstripe_offset = uc->unstripe * uc->chunk_size;
-	uc->unstripe_width = (uc->stripes - 1) * uc->chunk_size;
+	uc->unstripe_offset = (sector_t)uc->unstripe * uc->chunk_size;
+	uc->unstripe_width = (sector_t)(uc->stripes - 1) * uc->chunk_size;
 	uc->chunk_shift = is_power_of_2(uc->chunk_size) ? fls(uc->chunk_size) - 1 : 0;
 
 	tmp_len = ti->len;


