Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77AA4596E;
	Mon,  1 Apr 2024 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988888; cv=none; b=cgM8UHcwRIfjer3UgasdQZ6vpmyAo/kz/p28hvogA30XpbqLqcba5F6tV6E82w3v8vk+istfL0uK3JYNgt1ZdyqqB1Qw1AkS3oOQt7D2xp9sPHPshnBPS6kCrmMJEB2/sGWaM4dGVVUrefPLBTbm15wfYbmGbwkMcxPOiz+Kjik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988888; c=relaxed/simple;
	bh=yA+vNWWKs2lzl+7YLAR3ZUXLBP6PARkD3EP7maoMk4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVcJcEgfuvcFEnbQyuCW2ZrTCStFJutb0JvlSfvc2zWr0tdpo5YFu83PZtHPCjpDhx4OQy25d83Z10pgCYr5+J33pBhld0i+CpHUSd31QuJv+T5YFoZqgiUX/Orh9ds/E+PnYtPmKZwKo71NksD8tQhmUuC8n32HEYOKcj1NdqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aieXda2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aieXda2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3D8C433C7;
	Mon,  1 Apr 2024 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988888;
	bh=yA+vNWWKs2lzl+7YLAR3ZUXLBP6PARkD3EP7maoMk4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aieXda2DdlBcs18zBslu/Y4Te1w+wj2xyXnUc+dVdQfAux69PluRcBlW04OIT+Y2W
	 TBit0kkBnCLm1sWtI11FkOsrEpgrQbP3Q074VaM8jldufgq1Z9fvw+BIhdYdXzZM4j
	 x+mVDOC1Z+fZm2zEI7oOR2jey6kx6Aac3xI6RhHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tymoshenko <ovt@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 317/432] efi: fix panic in kdump kernel
Date: Mon,  1 Apr 2024 17:45:04 +0200
Message-ID: <20240401152602.647606029@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksandr Tymoshenko <ovt@google.com>

[ Upstream commit 62b71cd73d41ddac6b1760402bbe8c4932e23531 ]

Check if get_next_variable() is actually valid pointer before
calling it. In kdump kernel this method is set to NULL that causes
panic during the kexec-ed kernel boot.

Tested with QEMU and OVMF firmware.

Fixes: bad267f9e18f ("efi: verify that variable services are supported")
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9d3910d1abe19..abdfcb5aa470c 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -199,6 +199,8 @@ static bool generic_ops_supported(void)
 
 	name_size = sizeof(name);
 
+	if (!efi.get_next_variable)
+		return false;
 	status = efi.get_next_variable(&name_size, &name, &guid);
 	if (status == EFI_UNSUPPORTED)
 		return false;
-- 
2.43.0



