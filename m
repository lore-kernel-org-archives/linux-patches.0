Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA5E29A2;
	Tue, 30 Jul 2024 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354848; cv=none; b=juKVjMk2KwLN/lfuYZ3aX0W+5BLEgDB+FRwpD4WkM7ORNCZpF9KB20JLwMUtcRFe8P3o67V9GXGcHB3xXS0R3682jCchhk4jkhXUqDLcakxV9f/3kdtii3G9yTa2Y48qB8vKZFqHHTdTr34SHgywgH74BQx2mMg8ABAZWG6u3sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354848; c=relaxed/simple;
	bh=km+ndnq7vGjCXbBzCNYxkC4saIWTTxOFsJhMHOtvlR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrdqjI4pMNDWYGfCgBSx5EEFo2tawRwcWCDUyZyI5cKxuraiY30dRMCQgBP+VebabFKNyAj7dd+WpbPRvgXvj7mTpFsBdsg9IkOUYlJqQBcmk9hBnvm8aO08bhvji6r7zJHCSLeefKorQj+XnXB5NiDkoq+luUkIHU+E6JgsA8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaiTQC54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaiTQC54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E96C32782;
	Tue, 30 Jul 2024 15:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354847;
	bh=km+ndnq7vGjCXbBzCNYxkC4saIWTTxOFsJhMHOtvlR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaiTQC54YLJ8VuMbET7GrtTRM2I4Ze+M9eVBGKLc568Zk/QI8LUamV/RR5mfF3bwt
	 0exoqEHuM1UACbYUhHJhs7L5eip/dvrFp7/goPohuWmPSYmNZL98OBIK0BYtfjqHLJ
	 iBPZ1EgQetb95hmPcK929oFDaWYnsa+jos/LbPWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/440] x86/of: Return consistent error type from x86_of_pci_irq_enable()
Date: Tue, 30 Jul 2024 17:44:06 +0200
Message-ID: <20240730151616.279362100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ec0b4c4d45cf7cf9a6c9626a494a89cb1ae7c645 ]

x86_of_pci_irq_enable() returns PCIBIOS_* code received from
pci_read_config_byte() directly and also -EINVAL which are not
compatible error types. x86_of_pci_irq_enable() is used as
(*pcibios_enable_irq) function which should not return PCIBIOS_* codes.

Convert the PCIBIOS_* return code from pci_read_config_byte() into
normal errno using pcibios_err_to_errno().

Fixes: 96e0a0797eba ("x86: dtb: Add support for PCI devices backed by dtb nodes")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240527125538.13620-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/devicetree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 5cd51f25f4461..c77297fa2dad5 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -87,7 +87,7 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 
 	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 	if (!pin)
 		return 0;
 
-- 
2.43.0



