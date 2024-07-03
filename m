Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5624545945;
	Wed,  3 Jul 2024 11:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004995; cv=none; b=mLLU7IkySPbsiw9zEB7nQIcmZOtvNigOdUue22ilGjCl/eBvh9o5zvf9G87QF28lkitjy1I4oBPI7WI6bSvNQO00MzHjLD1Cb4OW8RMOmFc2HESqsNywVIChoLpy2pa9MpalUw7R7KEtwO/gfM2fibRWweUTBcMUsnxAyOUVW5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004995; c=relaxed/simple;
	bh=GVT8TmjC3TG48MFekijPiD8qGRxOknXKJ+4qUy/kun4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ym2GpC1zjwaX2RQvXOF6QYZpHN+MNXkRWjJx+VKzaAGsplRhxV8KwJQjIKw3wcJQJsW9QMgM37sfPiF8mNLYPcPVrxNrojFPgAMDGgBB62Z+PtPLjJ2jUYU6b1zqsoNtbTqnFC4S03eYQPoPFUYAKuFjFoKf3HW11/6x/BZsK6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr116/zV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr116/zV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27F4C2BD10;
	Wed,  3 Jul 2024 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004995;
	bh=GVT8TmjC3TG48MFekijPiD8qGRxOknXKJ+4qUy/kun4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cr116/zVCrNnRRb/FeVskAI8SW2VFmFgrKAAbLU2OBtUmA9Wd+Zpfl+n4CLpuE/hA
	 D88uFwGQFJ1h39Y8Xi1XYU1hcv5weOPmu8FcCs6fwNaPtUMCZc6kxIt6KnMySZDecE
	 AmrhN4RxWuwISuxeoyHhm3zaiaphLXtXBS1v3UCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/290] x86/amd_nb: Check for invalid SMN reads
Date: Wed,  3 Jul 2024 12:39:35 +0200
Message-ID: <20240703102911.493825383@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 18f6b7c4bd79f..16cd56627574d 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -164,7 +164,14 @@ static int __amd_smn_rw(u16 node, u32 address, u32 *value, bool write)
 
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



