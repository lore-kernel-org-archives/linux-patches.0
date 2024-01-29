Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1557115B0FF;
	Mon, 29 Jan 2024 17:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548450; cv=none; b=TPoTUnbgqg8eyzc0jxUqAcTwX03GIGEiYLfCr7LKZBtcf/RaErp6RCKmABRTM/7onUeFW0Z1eKbiacXNV1TO7NGSn7DmdUX7XxlEOXJjvedN0JpjdT0hHFeubg1irxAZPXupucZpC3Ww6J6zJHJB1gCYBjruQxpn/huz/A82mAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548450; c=relaxed/simple;
	bh=fR8+IBHldQtHLw30nJoOJO8we9U152oyKzm/hRlZh5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tp9v0s++dRpRC1v1kjXBKkfejTO1kisTTN38i9PYX5J/Gaa9pRDirBgy9Ez7xZQ6aBEMo3Aad5M+sZ+ekbTCB5zr79p1lGQC33gUhFlhF4PdkOqu7uClyutk6AFtDKVf9KOjWU8479U4Tj94/iekbUQvv28MgU2zAHPNKA82XYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sONyiod4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sONyiod4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38DFC433F1;
	Mon, 29 Jan 2024 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548449;
	bh=fR8+IBHldQtHLw30nJoOJO8we9U152oyKzm/hRlZh5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sONyiod4htvZhti3wQsmkftCyuVzMFEg/sDkBPdZ1S6ZlOBxxJImiBlnvn0qcKDuW
	 5Q1gthJEt2OWodFg6tAfB+9hyIH+zH9yiT56QWRhcKENZcGSQYMpZDkHGn9SrbCkQM
	 +SomKNnoqiAF3kLUlOAPoQ/tthvgr4fV+/jFa7pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Simon Glass <sjg@chromium.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 034/331] arm64: properly install vmlinuz.efi
Date: Mon, 29 Jan 2024 09:01:38 -0800
Message-ID: <20240129170015.944999696@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 7b21ed7d119dc06b0ed2ba3e406a02cafe3a8d03 upstream.

If you select CONFIG_EFI_ZBOOT, we will generate vmlinuz.efi, and then
when we go to install the kernel we'll install the vmlinux instead
because install.sh only recognizes Image.gz as wanting the compressed
install image.  With CONFIG_EFI_ZBOOT we don't get the proper kernel
installed, which means it doesn't boot, which makes for a very confused
and subsequently angry kernel developer.

Fix this by properly installing our compressed kernel if we've enabled
CONFIG_EFI_ZBOOT.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org> # 6.1.x
Fixes: c37b830fef13 ("arm64: efi: enable generic EFI compressed boot")
Reviewed-by: Simon Glass <sjg@chromium.org>
Link: https://lore.kernel.org/r/6edb1402769c2c14c4fbef8f7eaedb3167558789.1702570674.git.josef@toxicpanda.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/install.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/install.sh
+++ b/arch/arm64/boot/install.sh
@@ -17,7 +17,8 @@
 #   $3 - kernel map file
 #   $4 - default install path (blank if root directory)
 
-if [ "$(basename $2)" = "Image.gz" ]; then
+if [ "$(basename $2)" = "Image.gz" ] || [ "$(basename $2)" = "vmlinuz.efi" ]
+then
 # Compressed install
   echo "Installing compressed kernel"
   base=vmlinuz


