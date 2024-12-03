Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8912E1F4283;
	Tue,  3 Dec 2024 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240388; cv=none; b=Als/Qx9vHnxjCS36wiVb74QS6Lf0OJSg6YqHLJZXerN7tNPNRbqnfxDryRqDH+PJtmVVT2KnZoBl2Cum9LxTW6oOCBNcyKvfkuR4aN184NuPBPeCwUH54wO9ZbG1u/2SKjExl+YH4JHGhSAxrK4lowsy6u7+f4cXmFKWEPku9QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240388; c=relaxed/simple;
	bh=LgIu/8dOZJOvUOfyCwYaV2sgLa9iCY8KtqQc3rYKkQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riFzRmrpFWCOrICM+bDk0P30twhMOyVtKca3zAPxF31gEIcT9T/mqofX+Uwns0hRsL0MaE3Z+2H5COEGT3JBMhgYxcR/1elS5AyKoxTfR2nUTVGTgL3B8XmXJ0iXe+nS9xGkSudmw2iHUWptXYxLh9o+0aKcjZGStwITsTUuVyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbSC/Ryw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbSC/Ryw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104E9C4CECF;
	Tue,  3 Dec 2024 15:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240388;
	bh=LgIu/8dOZJOvUOfyCwYaV2sgLa9iCY8KtqQc3rYKkQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbSC/RywZzXzEDnYnaTURfHCyC4PVHuCxw9wG8QYu4m4xgUtBmePFJYXvCL52j+FD
	 LZHvN4p2WHBb6XPeBKt+BYqA+3ZzDuhgjGFlO+4HYJ/vuISjVoWPwjV3qTyr94aToO
	 p9LtJpryv9bDj0WuudalYRreUQXw33JVldf7MKHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/826] efi/libstub: fix efi_parse_options() ignoring the default command line
Date: Tue,  3 Dec 2024 15:37:28 +0100
Message-ID: <20241203144748.465088249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 958a680e0660d..2a1b43f9e0fa2 100644
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



