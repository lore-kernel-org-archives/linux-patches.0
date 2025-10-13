Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF951A9B46;
	Mon, 13 Oct 2025 15:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368618; cv=none; b=sQEaTsazBN+00yi6KaJ6yrd1soOAwbv6q+yie9Z/qMiCWB/pW1qpbM64s7tweOnEE021gohOPXUlhNqYH5owpCEaSjkndb+96fvEe1LdmZ29RADZSt7k6051wybDrdAR6kdT4o+WLe+4rLNowb/2Q33V9AK8hJe+u/FELKDGxRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368618; c=relaxed/simple;
	bh=Pi38RafzL2WE6Q5yWJEy4mqxcvbiMXRRTe7UtVsNVrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+DCcfk7So5mf6IsVb1xa2Ao4KgiDOzc/AvV7Am60k2QKWsN/jHHlDCD8LLHdlDHRNsuDy1LOjyM1EiI1Dk06k9HbeyGulCB57nKy0sJiEbWaF+5UlfQc5TYwSVlWL+mpufXlJQjJuqUUpHy8doX+/UsCI5xoTtAm/M2TExlAFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4d6kFUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4d6kFUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73DDC4CEE7;
	Mon, 13 Oct 2025 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368618;
	bh=Pi38RafzL2WE6Q5yWJEy4mqxcvbiMXRRTe7UtVsNVrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4d6kFUG4EN826iLPHmXsgLBQWAHdbVD678xdzVk3hxmA2YJIwgSK2KkGDKJf1sxz
	 zLiJJaLYbJJVOedxeDWLuQreyxWZSUFld+uGpwqzHKLo9x/IjRTn6+rkdE4na1bfyf
	 RITN50yrGRI/0P6kKDzZ9tievtd/2Cit/jL8CsgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Fenner <cfenn@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	stable@vger.kernel.or
Subject: [PATCH 6.12 224/262] tpm: Disable TPM2_TCG_HMAC by default
Date: Mon, 13 Oct 2025 16:46:06 +0200
Message-ID: <20251013144334.309607115@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 4bddf4587c131d7b8ce8952cd32b284dcda0dd1f upstream.

After reading all the feedback, right now disabling the TPM2_TCG_HMAC
is the right call.

Other views discussed:

A. Having a kernel command-line parameter or refining the feature
   otherwise. This goes to the area of improvements.  E.g., one
   example is my own idea where the null key specific code would be
   replaced with a persistent handle parameter (which can be
   *unambigously* defined as part of attestation process when
   done correctly).

B. Removing the code. I don't buy this because that is same as saying
   that HMAC encryption cannot work at all (if really nitpicking) in
   any form. Also I disagree on the view that the feature could not
   be refined to something more reasoable.

Also, both A and B are worst options in terms of backporting.

Thuss, this is the best possible choice.

Cc: stable@vger.kernel.or # v6.10+
Fixes: d2add27cf2b8 ("tpm: Add NULL primary creation")
Suggested-by: Chris Fenner <cfenn@google.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -29,7 +29,7 @@ if TCG_TPM
 
 config TCG_TPM2_HMAC
 	bool "Use HMAC and encrypted transactions on the TPM bus"
-	default X86_64
+	default n
 	select CRYPTO_ECDH
 	select CRYPTO_LIB_AESCFB
 	select CRYPTO_LIB_SHA256


