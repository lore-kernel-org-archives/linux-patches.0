Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9DD1E86F;
	Tue, 30 Jul 2024 17:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359105; cv=none; b=kV7aen95ra/7KNAwhq8wBZy4Oyry29Rnb5sACH3KxjLgR5q5kv2T+uM3/d9eejBWUu52/uHV/8Yado2uuR/o6Pes+xCQyGkZWci1IVqGpN/vUMwrtnsjSkCx/pFvjxjDHJkJKEIOekifo2n2UsAfJUG0INYmHs4dh9TPExfEOcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359105; c=relaxed/simple;
	bh=x93FIBFFlyTx6hsCgiqtJ+NHzashEu5HsErzhVGgpxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7MebZdXBCDBL4vHeofEYVSwYOqgcwm9oyQfzwXcZIggrLSgNDEWEUbeTM1aZSHCFMuEU+o/fIoiJuGH920RDUtxut23Urlsnt3eGrwUs96Jefp3I4MWOZptoCZYROo1YKt4yz/s4GCwDy+hSDOnwu8o/hsm9e8Q8xRVqZ3k8Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNjbVBfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNjbVBfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77857C4AF17;
	Tue, 30 Jul 2024 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359105;
	bh=x93FIBFFlyTx6hsCgiqtJ+NHzashEu5HsErzhVGgpxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNjbVBfrDgEPzfFpDTgNwK+EjLuTzQIfa5hAQ0EjEJswkGgVsE1TDMNDHhZVOOM9B
	 wnbeQt5lLeZXZ6E+KWbbth0mGK28NMJliN3U9GXQpoY1F7UK3jRmvzAfLPydp/H/99
	 waFwT7A03cKGjAZoOTE4StmcAYPzilElidQZEda4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 432/568] efi/libstub: Zero initialize heap allocated struct screen_info
Date: Tue, 30 Jul 2024 17:48:59 +0200
Message-ID: <20240730151656.753869427@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

commit ee8b8f5d83eb2c9caaebcf633310905ee76856e9 upstream.

After calling uefi interface allocate_pool to apply for memory, we
should clear 0 to prevent the possibility of using random values.

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: <stable@vger.kernel.org> # v6.6+
Fixes: 732ea9db9d8a ("efi: libstub: Move screen_info handling to common code")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/screen_info.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/firmware/efi/libstub/screen_info.c
+++ b/drivers/firmware/efi/libstub/screen_info.c
@@ -32,6 +32,8 @@ struct screen_info *__alloc_screen_info(
 	if (status != EFI_SUCCESS)
 		return NULL;
 
+	memset(si, 0, sizeof(*si));
+
 	status = efi_bs_call(install_configuration_table,
 			     &screen_info_guid, si);
 	if (status == EFI_SUCCESS)


