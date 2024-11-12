Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75FC21216C;
	Tue, 12 Nov 2024 10:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407091; cv=none; b=SRFWxMvw9B5OC6pfx4Kok3Qwh5vtqZHCmnGj1snTPPLPmsiUmG1p3e6/FdEEShCtXsMol18oOWfrT47h9GnDZvrTdzmhN7KWZIjNH24s/5/xj86Mvw25+GpXVFHAqS+54EOlHtToynurVr9C4lj7Y8dDmpTgxb/jrX634BtrUxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407091; c=relaxed/simple;
	bh=eyxlGe0YD21+mOgdH0hmusaUa70joerRlkC0DrwPt9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+w5Qy19WdFlEVX9xmdf0YWTV45bv0wsOY3cM2iECOw1cbo9f+0z/d/qQu6jEShN8pGCfrb83F3O09sCEI3sjR9o0NUKfOL929xqSCI5txrkl/WDs/ko1DH5R8EAjpzTFgpV7tvJE6Ua3pk7DRL3vH+o6pqV2wg6k8EeUnMcB0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04KoTXgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04KoTXgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB89C4CECD;
	Tue, 12 Nov 2024 10:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407091;
	bh=eyxlGe0YD21+mOgdH0hmusaUa70joerRlkC0DrwPt9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04KoTXgADZWk2g/Ogaj5EVK+8xqp+0dnqkHx5w0OzmI5loEQ2gXdYgxBy648O7Rba
	 wfqmMyAtITT9YZnWv5gToZM6YmWlpN6lAanTupStY4VkHV9zHG0Mk/p9D3c/LxHu1l
	 fTVX/SMbTDxFk18Vf7AFjLS7NYgHutZolFvJmyE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 47/76] dm-unstriped: cast an operand to sector_t to prevent potential uint32_t overflow
Date: Tue, 12 Nov 2024 11:21:12 +0100
Message-ID: <20241112101841.576250398@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -84,8 +84,8 @@ static int unstripe_ctr(struct dm_target
 	}
 	uc->physical_start = start;
 
-	uc->unstripe_offset = uc->unstripe * uc->chunk_size;
-	uc->unstripe_width = (uc->stripes - 1) * uc->chunk_size;
+	uc->unstripe_offset = (sector_t)uc->unstripe * uc->chunk_size;
+	uc->unstripe_width = (sector_t)(uc->stripes - 1) * uc->chunk_size;
 	uc->chunk_shift = is_power_of_2(uc->chunk_size) ? fls(uc->chunk_size) - 1 : 0;
 
 	tmp_len = ti->len;


