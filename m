Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6B227702D;
	Wed,  4 Feb 2026 15:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219121; cv=none; b=L00lvnnEbyX7u3p57opHmZAGvVEXU0B05RgQ4OQY6bg5jOC+cIIC3FgVSQkaWgznsYIRYntFidcdfcGrvQEv2y8TlvOuDVLkb1xxVxY8lyQ+1+EPF9MN5M5IVy1aRyCj2wpZdaVw9k1lPM/EsUMI0y2GJHl+K7XT52ttH5B9URw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219121; c=relaxed/simple;
	bh=eUdMCAcMiJ+Xqdasf0Neum9nf/QzUwBm8o5ZITPdPa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMgOqQwL4/4sf36XSXksfX1YvQoX9711hjZUoWStWV7WcO+M67DHcz6s/xhazUOs6lQRbvxQBFqZxEVlQw9vfFrTzX1zuXRacKY8p9X+edmNpgFgprY10dsz1UI/Vh0DD5iZ9zVavJeCShSObKQqoIqfX3bkgDPbyPKWMB9cJEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOi9kCYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOi9kCYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62812C4CEF7;
	Wed,  4 Feb 2026 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219120;
	bh=eUdMCAcMiJ+Xqdasf0Neum9nf/QzUwBm8o5ZITPdPa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOi9kCYm8FkS5WytYTCAY7QZqp4xL+2cPJptdDr9aNyTF/ySyvNwdxQuvAxPUSRrG
	 UgZHEYdo6P0kpD55eO4XS2tbMCRK2tMH6j3ngIIMxybLcNSu5XmYFMS9jPyNvFr5NW
	 /rcnxQ2nPtA/IeyQANu/WetmqhsoWcdgSXYnGlaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18 074/122] efivarfs: fix error propagation in efivar_entry_get()
Date: Wed,  4 Feb 2026 15:40:56 +0100
Message-ID: <20260204143854.513548497@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -552,7 +552,7 @@ int efivar_entry_get(struct efivar_entry
 	err = __efivar_entry_get(entry, attributes, size, data);
 	efivar_unlock();
 
-	return 0;
+	return err;
 }
 
 /**


