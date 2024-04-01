Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E664CBA3F;
	Mon,  1 Apr 2024 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990307; cv=none; b=eaieUvO+zwDXC1PVzUa1OX56FzNxZH1Lb0oM4jt2rIh3bAdVjkR2yMD1wOmLgDeEqF1FrYvGszgV3ajvyiVKS1JJaGxAuF/QEbEDBADStP0yB/FzntRpcb23wUT25XXv3J79oLKKHwi12k3d2QwMR5Q3EdZO6xLyeq/iymHBOx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990307; c=relaxed/simple;
	bh=z+XzkpEqU2gEPyI6YRCD4Oh7D2Fzenj0pBBD4kfxgP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWhURGrajJ9jpQtk/UoKpQS/mrUNVqKfQfZyfb5y9Vd4hj+LVyAd9tAYqHDdqkE4p85ysGYvG39C4SISfx2kJhQApEGxpos9iCFiNBy4j5/IYpis5HjUNTO+pbPipbLfxHGE//3tg8sbDu7WEdB1XE/SVXBXAwBFTMwQ2mmwFPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRMOkoZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRMOkoZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E15C433C7;
	Mon,  1 Apr 2024 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990306;
	bh=z+XzkpEqU2gEPyI6YRCD4Oh7D2Fzenj0pBBD4kfxgP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRMOkoZDb2aZyVgt1l3IuDNEMCUEp5lM5hJLeqiS3O1qKlNesjKPeP9Jk/vNNQ6/1
	 b1/U++DVHU9Osy4XkPfJV5d0V9oAIuTAomkQRMYSF9sABE/milOzbgxQusMtAwNTfH
	 V+vwaYujqe11EixxWD8hS6Ys4FzU3A4gsaOBY4kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tymoshenko <ovt@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/396] efi: fix panic in kdump kernel
Date: Mon,  1 Apr 2024 17:45:52 +0200
Message-ID: <20240401152556.933817660@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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
index 1974f0ad32bad..2c1095dcc2f2f 100644
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



