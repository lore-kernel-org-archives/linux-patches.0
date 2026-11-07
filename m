Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062395;
	b=WHzCXSD1TlSlBq6tokmWVk7NAqDhTBxptfScqHDGQ2zhFRATs9NTTuJWutpln5HTBHIy
	 JNcHeGe16rmzyKTi6iIUAiHRRXuIEa5pBRs/v1PKDV2poBeRciH/fwCbvECB1ldi6sXb/
	 aCUbS6W5Dc4itEtGSnkuIPOdsLppgs01wVIRSfmq6PavFQeNZO0l9t0EE86UqmtMXJuM0
	 D4llxLWMjl+mQqooj8TR+DFr7pcuMBh4zNuqzh/85A+zEFG9UIbPc8VvfjX9jd4t2ax93
	 Dz0UuR/jeRfXmqikRLSC0IQzXvt658QtdytgvL+Fk3cbVoZphN1R6qZbvoNUuisHn8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HHna0GgF9C/b2+oyKhg1pPYyAGuFiJO43P19hrYC0nA=;
	b=diVmifJF0jsEkJN8GBaSIHBQxsxTDod5oO+tSlOiDYN57sLEOEFmb0a07Ut0DMWXHf7Z
	 a+Lt2YlkXzoAyINuaISJvLFxzXW7TFM+Y2Atvfw69FHycUtH8kXefEfv+HuhRvH/IPGA6
	 cByGKKPkdiUq61H5h3zzOdak9rjomzTnE2aiVOb9iKUwOoiIXUtonk6g3gb3F3oJkh5Wr
	 EQGlVIwdCatKTfXtYAH5hKHDtnCKCj284vJtC4TaZv0WX7wKrQKYX90Jd5aKXNs8wuDbD
	 2ZR2bj+XlIo/n+m83qCihspHorJv61mK0P1gLQaIL+v6DDxX5syKDvKLRJxpSAoievg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXWbIvfe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1938B606D839;
	Sat,  7 Nov 2026 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXWbIvfe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9731F0089F;
	Sat,  7 Nov 2026 14:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062395;
	bh=HHna0GgF9C/b2+oyKhg1pPYyAGuFiJO43P19hrYC0nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXWbIvfeokD2Q2GEcTXcG9PWdIFQ45kc0k3D+6T6wylMSv7Vh98lvESORMP5Chj/P
	 Qp21q1yhdy76k8/fbmh8r3S5/jHAZ8qL6FwPyBsCbRtK/jLGJCX323AH6Pw+ngnlYh
	 K7cvWzS9Y/fGeTTduBB3putPs7tot3uVkGXX814U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1313/1536] efi/libstub: Dont replace an existing LINUX_EFI_MEMRESERVE table
Date: Sat,  7 Nov 2026 08:55:29 -0500
Message-ID: <20261107135034.679170954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit aaf3ed0f46298e18ec8bc477cf0a37478e41f2ea ]

The LINUX_EFI_MEMRESERVE table is the root of a linked list of memory
reservations that need to persist across kexec, such as the GICv3 LPI
pending and property tables, which cannot be moved once the
redistributors have been enabled. Each kernel adds its own reservations
to the list that it finds via the EFI configuration table, and honours
the ones made by its predecessors.

The EFI stub installs a new, empty table unconditionally, replacing any
existing one. This is fine on a cold boot, but not if the stub is being
executed by a loader that passes on the configuration tables of an
earlier kernel, e.g., a kexec loader that runs the incoming kernel's EFI
stub, as the reservations made by earlier kernels would be lost.

So leave an existing table in place, and only install a new one if none
exists yet.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index df5ffe2364429..438c7aed2d287 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -81,6 +81,14 @@ static void install_memreserve_table(void)
 	efi_guid_t memreserve_table_guid = LINUX_EFI_MEMRESERVE_TABLE_GUID;
 	efi_status_t status;
 
+	/*
+	 * If an earlier boot stage installed a memreserve table already, e.g.,
+	 * a kexec loader passing on the persistent reservations made by the
+	 * previous kernel, use it as is: installing a new one would replace it.
+	 */
+	if (get_efi_config_table(memreserve_table_guid))
+		return;
+
 	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*rsv),
 			     (void **)&rsv);
 	if (status != EFI_SUCCESS) {
-- 
2.53.0



