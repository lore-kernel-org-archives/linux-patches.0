Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F4C22332E;
	Wed,  4 Feb 2026 15:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218442; cv=none; b=QpPAb6w/21Sp4Fjh+GifdoojHYdFqqyJOOacSHHyHLImpEivU7T48/Or0KqlI4r7RtFjzh6vROmzWS5cWBqaAV+h8y1GXIqRDLbPiqZLcSJ0B4C+Wto4gsL0HK4cQ3Rh7EuLOIw4/ILeJCsZhaa5DpMUTDh/OrOoLP8fkh5XCbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218442; c=relaxed/simple;
	bh=UkDV5oFWDqE12Ree5Ts1sc83Auh+JDFOM20KcPVZhfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmgmeKTEV3OiW/pjHHm8v8mOyaf5cSK2aaTVtA9IwKD12GpruEr7MUGZ6fXXzlyjD960FfFs4xkNtvgdBksffcvWhGEcCSxdNltd1HqcGuJhV6R97DABnn1T+Ir9l/64nKJ6tq83BqejmxQC4sQKHD6UOnJt8wwznT7IVmoOTXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dF23e8LO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dF23e8LO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A852C4CEF7;
	Wed,  4 Feb 2026 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218441;
	bh=UkDV5oFWDqE12Ree5Ts1sc83Auh+JDFOM20KcPVZhfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dF23e8LOx4lzDfu8svrtnslA6+2o4CgUqLsbU1qJaBH2KWvyVFQ0qlUkRLKMqrGn6
	 OfJ2T/8jboZG1lTzvsCccaLJNT46zgShK39qfBFumPdB1bf1FjhpznN1rfTGCFL6gM
	 KCBv51OnWdQulXnYqh/YxPuFI2mgHXtFE9EVWCpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 31/72] efivarfs: fix error propagation in efivar_entry_get()
Date: Wed,  4 Feb 2026 15:40:34 +0100
Message-ID: <20260204143846.753639099@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


