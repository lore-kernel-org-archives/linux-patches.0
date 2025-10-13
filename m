Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8513148C2;
	Mon, 13 Oct 2025 15:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370140; cv=none; b=Ak8xQU+dZYH+0tONtscGFR3gA7l4uXAPUkDVc2wXMp9fj/J0jgFFq0APvseXoo0hmPfEF1oOG2Iu2YMJLjI9f/3A7TGCzfkhBTDBX2tV1MMfQVTFMBwHr9CMk1CzdyE5JXpo2OTetosTZuIqZJzFSsM1BkOvxEMNMReccjOhEAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370140; c=relaxed/simple;
	bh=Hom9tn8NgRZspiTioJrxeCD0f/oU2g6MhZSLzOJrjwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHljghcPwsbniW+vNpJhSwdUrWm6OlDx/mTbMdbrHaY+PlVDjeDn29hciCx0NhigFfCKDKkBcYWpP2ku00NFrhzk+4zq2DWptgRUfansi9pgOQxYhf9XrSSBO6VuS8hnZ1emF+MeVD1r+NoseyToO6EbiP7LjCDB5kqOSfavUUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsP523OI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsP523OI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75743C4CEE7;
	Mon, 13 Oct 2025 15:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370139;
	bh=Hom9tn8NgRZspiTioJrxeCD0f/oU2g6MhZSLzOJrjwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsP523OIWMJUgY6MmOdjQTFZRlxegmLKxomLAWtvCVNvc0nECMRzQpQaySnfjjwb3
	 US+hMMdEwhj7o2OzCWHP0ECxxbrno2IzROB3WhVpeEZJu1CSYUKaT2gDPflXdYGzdQ
	 mvHZABpIok+BxCVOVm8GahFPNThC8efa9RfSSeqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Fenner <cfenn@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	stable@vger.kernel.or
Subject: [PATCH 6.17 493/563] tpm: Disable TPM2_TCG_HMAC by default
Date: Mon, 13 Oct 2025 16:45:54 +0200
Message-ID: <20251013144429.152278910@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


