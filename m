Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A096E5ED;
	Wed,  3 Jul 2024 11:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006052; cv=none; b=C1+4ieeYsy27ikDAKNb5xc5Tgtg5fD2evkA1y/uvsLA7EIIN452IAJmSQdMAadJ735ZNammOlE7W3VIWiIkPdP30ybP42xVwsUr55JI7OB9yku7bzcgsZ7DZ2KKk8q5ABsqy9Ccze9N1s4fGp2caoawqNdggWc08qxd1iR2J0sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006052; c=relaxed/simple;
	bh=ElUcc+8sBjOdSCZVLEmoANjz6coRInpdYTe4fdFvLhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNZ1j2Mrqye7RqX5468B0dIDhW/dm3BGdaoxFSaiHDv1fa1VpyNq5/g/uJphEYBrDWd3BU8MT/TLGHuBn7zf5cjjeP6BTBXDn+tS5iR9DHoZML++i3vmzZMjjrqztS6m6VRTlDe0mgQ48E24BTmz/B3TcOLRTHngq+9YE5A+4MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5OCino0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5OCino0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79090C2BD10;
	Wed,  3 Jul 2024 11:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006051;
	bh=ElUcc+8sBjOdSCZVLEmoANjz6coRInpdYTe4fdFvLhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5OCino0ahWmXRKaDw5N6qRgQT3OSf9+aV6GPwHkXvahBriVB7H1uugg8Ppp2+Cml
	 avdBN4DanSqPHzafKnpyjmTuk3a0mfA07vtAXuqVnjskcpKB1Zi1Ali2h0OKm6MYEe
	 bTHzby/06DJM7IOvqbYylqe84jw/ph4xkpl4xYuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/356] x86/amd_nb: Check for invalid SMN reads
Date: Wed,  3 Jul 2024 12:39:49 +0200
Message-ID: <20240703102922.689301862@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit c625dabbf1c4a8e77e4734014f2fde7aa9071a1f ]

AMD Zen-based systems use a System Management Network (SMN) that
provides access to implementation-specific registers.

SMN accesses are done indirectly through an index/data pair in PCI
config space. The PCI config access may fail and return an error code.
This would prevent the "read" value from being updated.

However, the PCI config access may succeed, but the return value may be
invalid. This is in similar fashion to PCI bad reads, i.e. return all
bits set.

Most systems will return 0 for SMN addresses that are not accessible.
This is in line with AMD convention that unavailable registers are
Read-as-Zero/Writes-Ignored.

However, some systems will return a "PCI Error Response" instead. This
value, along with an error code of 0 from the PCI config access, will
confuse callers of the amd_smn_read() function.

Check for this condition, clear the return value, and set a proper error
code.

Fixes: ddfe43cdc0da ("x86/amd_nb: Add SMN and Indirect Data Fabric access for AMD Fam17h")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230403164244.471141-1-yazen.ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/amd_nb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index c92c9c774c0e5..62cd2af806b47 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -172,7 +172,14 @@ static int __amd_smn_rw(u16 node, u32 address, u32 *value, bool write)
 
 int amd_smn_read(u16 node, u32 address, u32 *value)
 {
-	return __amd_smn_rw(node, address, value, false);
+	int err = __amd_smn_rw(node, address, value, false);
+
+	if (PCI_POSSIBLE_ERROR(*value)) {
+		err = -ENODEV;
+		*value = 0;
+	}
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(amd_smn_read);
 
-- 
2.43.0



