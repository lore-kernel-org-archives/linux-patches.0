Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A430E158D64;
	Mon, 29 Jan 2024 17:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548230; cv=none; b=J51BS3vghouL5+t32WSivS0CHoISARB2dX/uUP3l0rtnruS+6iIPPhaWPM9KLEzBqvsc316kO+VXwC9sMDlzevjBfS7rTxTnQhKXUQ0y5o437LVk9BWxW16jJBXlqRsNd3YneoAnEWA3qkLpw5bP2cQcX0pIHojW2zzq8zATmEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548230; c=relaxed/simple;
	bh=AYCZMToLc6rLCS8gg4VuBXgXhg+qCt+1/DPBt8eUV0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcVdfYvH5MQrIlJ1sabwD2OzBihwPtLQ6aZM2Z0CgpzZMG+odSwmYraCFYj8AhroC0oWPewtWUsgDvnGISPvXwe1Dch4jfwGoIORZg9wblfm7WlSRqRd+sTXNa86xoTt1Dsma0GwfLRYoHVALSh6M/gPjqJM6BnIhSTvS/VEnTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfhpw2VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfhpw2VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A95BC433F1;
	Mon, 29 Jan 2024 17:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548230;
	bh=AYCZMToLc6rLCS8gg4VuBXgXhg+qCt+1/DPBt8eUV0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfhpw2VHoKSP9o5DPQlytFheBClN8bsux5wXmcs6xesQ3XgbC+Sic7dUIfCJBLZFP
	 goty1I8PdPQv5uq7007J/k2LUmegO5rAu7SjvHsin+WayiX9qgnEmR+TQ7o2na5Lbv
	 SQvQfrs3tqG9s99QFrNkYTmj83KdZ6J8F7+gEuKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Simon Glass <sjg@chromium.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 008/185] arm64: properly install vmlinuz.efi
Date: Mon, 29 Jan 2024 09:03:28 -0800
Message-ID: <20240129165958.859327843@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/boot/install.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/install.sh b/arch/arm64/boot/install.sh
index 7399d706967a..9b7a09808a3d 100755
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
-- 
2.43.0



