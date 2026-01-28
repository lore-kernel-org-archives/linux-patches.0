Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCA036AB62;
	Wed, 28 Jan 2026 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614044; cv=none; b=NY4fvujxgFHO1Mx3yw0pHMayvB/xEF7v42aN0lzjqpjpSTB8iiNp0Ov+HYQ0NSmy9hNF9rKnCz8Yrn70qyWqMc/VWZkQ5yEmFjTHjxuna6PhI52yh1reQPz8EZkGu5QSVy/COXwst0w3eC6jk6TEHkYgXXrovihNmo4jPiWonUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614044; c=relaxed/simple;
	bh=uZnjDe43rS0MCe594Lrf736iTXZx0h2b7NWfHwkoDK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhqC1k1Ij1znZC0ff34OStaKJE0h7G4c8b70c8iRaTcIFWQXVfDIudYQmIsVXhuKpgXtgaumkwE+VLU8sjzNGZbbvgpGoPho7c6UPI2/6//WfwopF3DLKVsfKNlQIauULiXg0X7toijtCjhJKmfBg3O8TR5wryqsFMnZY6/22pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnwPD+Gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnwPD+Gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D772C4AF09;
	Wed, 28 Jan 2026 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614044;
	bh=uZnjDe43rS0MCe594Lrf736iTXZx0h2b7NWfHwkoDK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnwPD+GgHFwltLmsS/nDBHLce3XZBY8DPclDUyyeMcmjEHnkfEBMBEWLgpiUPUCQv
	 v2B6hkiEaPKLCQbJe357OhGVggXjfD3aaWG4TGzeuxCs0VZJWnPptPYQAdoNPMsxBk
	 YWl29dRW+udkiQ50SsVhDo9vdSb/ikIofXHS3moE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Morduan Zang <zhangdandan@uniontech.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 002/254] efi/cper: Fix cper_bits_to_str buffer handling and return value
Date: Wed, 28 Jan 2026 16:19:38 +0100
Message-ID: <20260128145344.791241510@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


