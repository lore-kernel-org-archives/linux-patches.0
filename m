Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9614219ED;
	Wed,  4 Feb 2026 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218730; cv=none; b=XewyoP+TsHbB6eyrR7jBdYN7zP9/1lwYpgF2T5qBUoSNJ2zUZyGiFKqDqAwa1d4RWFoQActiIkO0zOLg7WemDKlkkyB6RoLj3EChIF5S34ZkPvpPn/k77MUvOoM2D6tg3a02vCvqC3kpj1WfkcEDJrWS5RpWSZpmaiwLaqQebg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218730; c=relaxed/simple;
	bh=F2dU3F+38QM3h4vLyS8f4Nyvn/HLPgXu8d8pAegrKuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAniFZGrcSBtY37UaO3PODmSvQOPduzMwLa3Jtm3ZJ7sqrn5kcfazByp06fO4ROS6U7/tQU92P0scxgnRf81WzDgwS9dZu+h1y7pk8RAbRbNpPpH1GEE4HP+T42YYx+Wj7+u/emq0/Pkl9S7s3V6GVTQJ7a6pRmMlWZjPtQ9DTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R48VYeqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R48VYeqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC8FC4CEF7;
	Wed,  4 Feb 2026 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218730;
	bh=F2dU3F+38QM3h4vLyS8f4Nyvn/HLPgXu8d8pAegrKuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R48VYeqeZjKAj0QWZ51b4bygzFBBTljNMmyn4S90H390AlOO9E9DTC1HLe8B7KVeW
	 DFLF0Rpk9cNHD+CiXOuE9402S617btrCboWbStTeIRPzNeezEAEwy1Mt3d4OVqClpr
	 HUjmn9HwtenVzx0Hf5t499Qtabw+PkgVK3tIuZZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.12 43/87] efivarfs: fix error propagation in efivar_entry_get()
Date: Wed,  4 Feb 2026 15:40:41 +0100
Message-ID: <20260204143848.464670410@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Kohei Enju <kohei@enjuk.jp>

commit 4b22ec1685ce1fc0d862dcda3225d852fb107995 upstream.

efivar_entry_get() always returns success even if the underlying
__efivar_entry_get() fails, masking errors.

This may result in uninitialized heap memory being copied to userspace
in the efivarfs_file_read() path.

Fix it by returning the error from __efivar_entry_get().

Fixes: 2d82e6227ea1 ("efi: vars: Move efivar caching layer into efivarfs")
Cc: <stable@vger.kernel.org> # v6.1+
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/efivarfs/vars.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/efivarfs/vars.c
+++ b/fs/efivarfs/vars.c
@@ -609,7 +609,7 @@ int efivar_entry_get(struct efivar_entry
 	err = __efivar_entry_get(entry, attributes, size, data);
 	efivar_unlock();
 
-	return 0;
+	return err;
 }
 
 /**


