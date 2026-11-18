Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036619;
	b=g23FwnF6u5PYeQA7RyzLQFIe7M5yQwehyM59o/J7Hd41wwIwRLKCpYD+ILPHm0Jai+f3
	 eH+oYbaXjzhHW5UaXQG+Szy//GYJstcSAAVx7f6X+YJUSANlBzjpR/AuS3lhZ+nPlPMwQ
	 E+z6ViHYguveb8iRvqTLpQL15V5dpUn8PkQt7xmtMUh714dwc/n7h+ANd5bCGb/Rfi4cS
	 2lU43ibqRZTeFwvc1tGcGaXrsi6YRML23jnJW/DPn6dgQiIit+S6HOG4NESjUK5Vz0eTk
	 BM60Rnc2xBo57VK2z/Yq9rLudMca59fWq+HtKHyDUIkV8KUeRe8zfbKzLvg+3qWaZFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tk9h1LpkKUlf6C8YQsZJ29/Kx6OQLotTkBlRoibpmD0=;
	b=39jpt8Z5R6/bVYwaqQP4C9iBrkuK1vVcwmfWeUXQmpaiLJPQFchsDpzyXEQdcZTHMpNo
	 yV9hSkSQ+edzqvq5YEz2Htc5LmCPyO8bAaiUvjgs47oYJKcH73snJySEhuVYV33UWmPOE
	 hv4Hr0pQ+mJnNh6KYyr/QT0s74G64aFQ65Q4h9R3jPhIIwnhmarIm8DQUiMOnYvgSCzlp
	 hxrTpJx6W2f1KdQbwkG3lBmzF9E2dYByJ0Lc4dcDnDtYaGXUb/ujo1awTK6p3mTIhxlw0
	 tkG8ECk/SNumxFfdxZhsN8hTdLDQaqv8fFU9MH+gCEboauIOSlLmHBPJnYyBjAUrh6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uhvw14y+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AD9606A320;
	Wed, 18 Nov 2026 21:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uhvw14y+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6AC1F000C4;
	Wed, 18 Nov 2026 21:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036618;
	bh=tk9h1LpkKUlf6C8YQsZJ29/Kx6OQLotTkBlRoibpmD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uhvw14y+bZTyNFqHZQLYJS5VQd/xDwcXDneq9hVhfoDy+rEy31TzVmEvFqYdHnqWv
	 oM4y1RiEb0+bRzgWhTHeBUgz0sEuM99M+K2pYXs+8B3ApqIXEEABzhvjp+MEQWIKmQ
	 ri8a8w90nUyUH6DvRZy23XAyyOXJBcyUv72UiJJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1125/3318] efi/libstub: Dont replace an existing LINUX_EFI_MEMRESERVE table
Date: Wed, 18 Nov 2026 15:29:07 +0100
Message-ID: <20261118150353.785775590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ec01b7d3b6d4d..2809d4578d28c 100644
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



