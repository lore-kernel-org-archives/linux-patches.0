Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8A1305672;
	Fri, 15 May 2026 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860787; cv=none; b=YI2lzvGIM0drkXY/OS5NqHaBh/cCr1TJF41hgpi+zlWW0EMIMybTzUyGrhI8mm0s5Apnf60rF5l64KbMw+el9DU516GD63b/PBE7baJLfh7C0nv0zWYS4wi0/XkY/qL2ZHjV47Oe2lbFxa6urU+BxPHRtdQDx1RQ1FR/6xaZLIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860787; c=relaxed/simple;
	bh=OP5g0NU9qQoTuz1wlvEaHzVf2k7JqpNwrxPQj9m+zag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0p6dL2+/sW6PBTzH6CjeAWYRMHSoYu9LC485g6YhweFsRDVwNm/ZKdi5YwkW1a1fOP79BIOxiJi04QxsygZPIA1yuPMP3Ce6lZfKC0DhsPh+t9HBrG/Ir8KeiOGRwked/8yg19z+qy2OSnkj2uJ2Ag/rGgQM5l4kfn9p300Ru8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEl+BgHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEl+BgHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D877EC2BCB0;
	Fri, 15 May 2026 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860787;
	bh=OP5g0NU9qQoTuz1wlvEaHzVf2k7JqpNwrxPQj9m+zag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEl+BgHemR4g8qi8DOpzWg0itm6nKomHD5nMmUJgrKI4uTL12Nwkot5yYrVPXWEym
	 Yk7AFaHBewScT3LQIL1GBN3IUv6hyYWyUdSgF0VtwrdiRUh/5XM9BlPYwk3yIr47vX
	 UUWecwwiNnvR+5HKZTjZ3yVSCKQK0DoCMQBmpJug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 080/474] tpm: avoid -Wunused-but-set-variable
Date: Fri, 15 May 2026 17:43:09 +0200
Message-ID: <20260515154716.769605483@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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


