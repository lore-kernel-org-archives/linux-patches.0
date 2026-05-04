Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B2F3DE457;
	Mon,  4 May 2026 14:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903245; cv=none; b=tLvR7p5zfqZWl55nJvatfw9i6WiFlPzjnsOjZzJkux06WTjLejdegbFZ7EgBeJN/BJ8h87DS/q2Xijp0bPbWTg2/BCkOY+3uPNa19F1MJKzcEJcH+aZpGjZPrbZlqYzYWcz/azvo0G7RcJMUvOJva+YmkqEjAVqJOtTv0QBEFiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903245; c=relaxed/simple;
	bh=RNVkSeReYcU7j2hJUUKZGD+dxeVTKLAA53DUZoCkLoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvAqJCL8HdbvF0ZHjMbufgk5zV1zdVXoGqkVkbWpfsOVKaKPqE8OpWUy7JtYct0tP9xieeu5tKky8fnGV/SR15mNCXiywWIM6OqtJ+Bbq6u28DVRwKdnKAuNi7iIrBmCt0KxZdgS6FzJzgguq0IOnqSWlolLM1EDnK6H7M+E6Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sklCjPS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sklCjPS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9541C2BCC4;
	Mon,  4 May 2026 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903245;
	bh=RNVkSeReYcU7j2hJUUKZGD+dxeVTKLAA53DUZoCkLoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sklCjPS+m0PNQubFayUpgYd6NPhQyhsCBwawneYfN2yGVykrIFk7BtSzZIcl1E1pW
	 Ruuteib6y/NinQwZesKrFJDXpogEvJn4opYJg4Qb9ALaPOZS5Uq1ldIA721vdnTrdI
	 +b0suXQC2NZPSES4H1X9fbt4Be8c5P9vzvhMtdlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.0 159/307] tpm: avoid -Wunused-but-set-variable
Date: Mon,  4 May 2026 15:50:44 +0200
Message-ID: <20260504135148.822411668@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 6f1d4d2ecfcd1b577dc87350ea965fe81f272e83 upstream.

Outside of the EFI tpm code, the TPM_MEMREMAP()/TPM_MEMUNMAP functions are
defined as trivial macros, leading to the mapping_size variable ending
up unused:

In file included from drivers/char/tpm/tpm-sysfs.c:16:
In file included from drivers/char/tpm/tpm.h:28:
include/linux/tpm_eventlog.h:167:6: error: variable 'mapping_size' set but not used [-Werror,-Wunused-but-set-variable]
  167 |         int mapping_size;

Turn the stubs into inline functions to avoid this warning.

Cc: stable@vger.kernel.org # v5.3+
Fixes: c46f3405692d ("tpm: Reserve the TPM final events table")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tpm_eventlog.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -131,11 +131,16 @@ struct tcg_algorithm_info {
 };
 
 #ifndef TPM_MEMREMAP
-#define TPM_MEMREMAP(start, size) NULL
+static inline void *TPM_MEMREMAP(unsigned long start, size_t size)
+{
+	return NULL;
+}
 #endif
 
 #ifndef TPM_MEMUNMAP
-#define TPM_MEMUNMAP(start, size) do{} while(0)
+static inline void TPM_MEMUNMAP(void *mapping, size_t size)
+{
+}
 #endif
 
 /**


