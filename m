Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795211442E8;
	Fri,  6 Dec 2024 14:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496846; cv=none; b=EoJ3yuEIgb+JwUIAQklenjI8r3zGOFXnGeH1srb1f7Nu7pQ4fy2DsvKAq3Nttd2xzhI3VJKFNb3D+loTkL5v7ghWbKmjfQaFuOn8dEhUDoHlwlD86NGFSdO/KCpD1AlI6kr8uy2kLo/ESwChzt8U3XYYa7fcDcYh/Y6GOdo1OVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496846; c=relaxed/simple;
	bh=yxWL4C1cf385/bc9LGY2CSb2M4yZ1FKvX7Hr8vN9zGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTemdV+Kz3hZ0akBLK8D4Z/iiXuhjDZ5WRN8i4cUiMexJiGqNl2rYWNGfKAAliNvfHtXcZp3UmeOCnCcJ4oXArx5ehKHe9OG+NZqq7HpoLOZRKbx2W6gNQnz3w0OgvQvXONy2ahmOSafmeg1eEwTXM1jgCgO53shCmd9JqTa8KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCsBeGDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCsBeGDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9817C4CED1;
	Fri,  6 Dec 2024 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496846;
	bh=yxWL4C1cf385/bc9LGY2CSb2M4yZ1FKvX7Hr8vN9zGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCsBeGDWrNjOVowINwQbU83LoPo9e4j55nRPvbFiUS+2x6CjAV23z1rJjK0D4bNOC
	 1wdwsPyIaRtt+0H80CuiSPDFW9qy49ncj4E3W/SzRYi9HCxmBtmx11zePva428ZXig
	 lZXOogdVb1vsUp77FCwWOUNiHDHHRQo3dzQjBR0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/676] efi/libstub: fix efi_parse_options() ignoring the default command line
Date: Fri,  6 Dec 2024 15:29:02 +0100
Message-ID: <20241206143658.160337439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit aacfa0ef247b0130b7a98bb52378f8cd727a66ca ]

efi_convert_cmdline() always returns a size of at least 1 because it
counts the NUL terminator, so the "cmdline_size == 0" condition is never
satisfied.

Change it to check if the string starts with a NUL character to get the
intended behavior: to use CONFIG_CMDLINE when load_options_size == 0.

Fixes: 60f38de7a8d4 ("efi/libstub: Unify command line param parsing")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index f9c1e8a2bd1d3..c5732fb5a5654 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -129,7 +129,7 @@ efi_status_t efi_handle_cmdline(efi_loaded_image_t *image, char **cmdline_ptr)
 
 	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) ||
 	    IS_ENABLED(CONFIG_CMDLINE_FORCE) ||
-	    cmdline_size == 0) {
+	    cmdline[0] == 0) {
 		status = efi_parse_options(CONFIG_CMDLINE);
 		if (status != EFI_SUCCESS) {
 			efi_err("Failed to parse options\n");
-- 
2.43.0



