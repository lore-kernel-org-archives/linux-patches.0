Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178562BD036;
	Wed,  4 Feb 2026 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217422; cv=none; b=UE6fO/jHqshTLX+IhOdzIi9PIiNQet9heCsADZqI1p7ZbdAhKaZBFUdfs9OJwFlR3cAJA4kk9XJEZ2Hdv8pMGkd+fiMqhssZhzbs6oMjSh1qAi3X40hUhRm1bFdUEwCqihnHjwbNxmhzWiEAY6cwmwc1LhY/CRXsU+I9366dcvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217422; c=relaxed/simple;
	bh=T/udowldE5CHtOMfAUpKPUT0AEPDJOy9nBM0MXh9lOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjonXMbVLDFhekIT/lgrEzTGWg02sNJSJJkHixngVZDY0KsYNZ2oM0lFn+Hh22M7JG9xHam65vsQjY/HqZauiykSvRHoZO/baraIPeOWIg5uyf7d7ueLNWDoRZbI2HYvETJnmp3Pw0Ucy/qXSBYnH8wVQaCYO3YkSHFmcJyp4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndcgYg2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndcgYg2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB78C4CEF7;
	Wed,  4 Feb 2026 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217421;
	bh=T/udowldE5CHtOMfAUpKPUT0AEPDJOy9nBM0MXh9lOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndcgYg2kJBbJs/e7VW9mddKFcab41UKpKkF/l7DvvsSYUzWzydXNuhb1aB+H8PT7R
	 1IEzwaRCeNOkN4rlRIrSli4BLfJzk0UqzIRUdcZxxUFFLqRyuq6Q/uHfMDMJ83d8hF
	 w5ClZC1Y0ZBug54c9avfprMWlyZfNvZvwoeRBxXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Morduan Zang <zhangdandan@uniontech.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 002/280] efi/cper: Fix cper_bits_to_str buffer handling and return value
Date: Wed,  4 Feb 2026 15:36:16 +0100
Message-ID: <20260204143909.709622026@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -161,7 +161,7 @@ int cper_bits_to_str(char *buf, int buf_
 		len -= size;
 		str += size;
 	}
-	return len - buf_size;
+	return buf_size - len;
 }
 EXPORT_SYMBOL_GPL(cper_bits_to_str);
 


