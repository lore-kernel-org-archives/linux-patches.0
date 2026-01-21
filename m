Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EB53002D8;
	Wed, 21 Jan 2026 18:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019965; cv=none; b=aLRqIJnu24Stf2l3+8LDHJBvWSyeqgIfMJ0Z9yr9FdZbOkWtnJbFSuJOpWreU+Ui79qAWuyswgyFnCYRhj+1VN8fKYK83vwYWDOC9Z3O9GE4sNnjZs7GMEQsh6l/XF8XnXU8RqQjwGx1vR4SAK1YoCJUs96R8vXbM82PeTsBXOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019965; c=relaxed/simple;
	bh=ie6fcHXGld+/BCnLkpt+B3WEE9KW0gzv9++sxepXiGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9huz/FU2vAMpRyHPtmCM+cCR6BmhWBcqYzXVW3fmtLQ5oBjKymCc/Fys8LaEQ5sHQFvSq00g3SD3oH+TDyokj2ME74b9NYsQcF7Dnrao1Tj8xLXWzXEwt6ZEw/eTXwnjw0/YxLZyEy2kH4wOGTkkalOWg1ZQk7B45qJ6sW5TWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxWGO3ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxWGO3ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02F1C4CEF1;
	Wed, 21 Jan 2026 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019964;
	bh=ie6fcHXGld+/BCnLkpt+B3WEE9KW0gzv9++sxepXiGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxWGO3mlgdeTDaEjP1J7ParKzVF4+ACm4dRp1J5A3muFoVcpRjw310fRnDc63Zz0/
	 lTpEdy/UYcvi9AhJHykU6vruv7Ktoj4ww+/f5FAHvvngSIWz7HHvd8ZhwZAQFvcYq/
	 eMHHLgV23/HW0SOGnig5tjqeHuKSJ4UhpOoOEniM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Morduan Zang <zhangdandan@uniontech.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18 002/198] efi/cper: Fix cper_bits_to_str buffer handling and return value
Date: Wed, 21 Jan 2026 19:13:50 +0100
Message-ID: <20260121181418.631028777@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Morduan Zang <zhangdandan@uniontech.com>

commit d7f1b4bdc7108be1b178e1617b5f45c8918e88d7 upstream.

The return value calculation was incorrect: `return len - buf_size;`
Initially `len = buf_size`, then `len` decreases with each operation.
This results in a negative return value on success.

Fix by returning `buf_size - len` which correctly calculates the actual
number of bytes written.

Fixes: a976d790f494 ("efi/cper: Add a new helper function to print bitmasks")
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/cper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -162,7 +162,7 @@ int cper_bits_to_str(char *buf, int buf_
 		len -= size;
 		str += size;
 	}
-	return len - buf_size;
+	return buf_size - len;
 }
 EXPORT_SYMBOL_GPL(cper_bits_to_str);
 


