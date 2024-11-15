Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E511187848;
	Fri, 15 Nov 2024 06:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653799; cv=none; b=G4tmOa+VjrjVXFWZr8MnhgWkJs8PQGnoFcmKN14Ep6Lpoqp0+ce2nRIvguVm9TG9fz1xiChvkZW7pn45cWLHMS0uvWie7n5MSCnjKZuT9GD3zDFK7biu3BPOKUn0TbmpjhjpXzxIMVcwPDhjn9mZoC893y/AAGndGENoDrEqV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653799; c=relaxed/simple;
	bh=4mIY4vrzvplSx0u41L2N6wA7XVvApybPk+vy6/LhkFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPw/regAvAOwrIM18n7pyoKjT/AO5lIIqt8sU7IqhMra0bfVRxP9lDt0r9uG/kZssdEhaizn65VpIlvR7wZaeMp/VQXmVVNPQTH6nal0Xu+OfqJ27TA/O6F4gtv80Ot3as3fxIXd2/XMUn+H1bZrYM9pW4u/FWo5MkwvKtzJK1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrMcavnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrMcavnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496D8C4CECF;
	Fri, 15 Nov 2024 06:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653798;
	bh=4mIY4vrzvplSx0u41L2N6wA7XVvApybPk+vy6/LhkFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrMcavnCcPQ4IarKvNFh647VbBAOWEgSfrjAWyB6+O1lUB0vlzMAtVT7VHsxtSS2N
	 s7JyS8fDlNLUtqOKi14pz2mqZM4Py6XAc16lQvqlJTgRv0KHYB9ZLOLkQ3BHTL55lI
	 FUzai8vNBbNjYLEuchEebRgpZNiaV42E2VU/qmuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 40/82] dm-unstriped: cast an operand to sector_t to prevent potential uint32_t overflow
Date: Fri, 15 Nov 2024 07:38:17 +0100
Message-ID: <20241115063727.004769567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


