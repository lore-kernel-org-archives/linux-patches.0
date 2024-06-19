Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACAD4D9EA;
	Wed, 19 Jun 2024 13:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803380; cv=none; b=LcyxpGhyhq38ZzOChe1ulcjzAxPKvdJVyprTJwL2Twr8uFTR89ENbFlNbo56QSQSpUmOO9apVdXYj0MswEP1IGp/yc+kJ3/uZi78dLmAObpmQraBdwNklom1fqCu7EFtV2oL8CGVOkFhJkVuQQ/MF7fIcmy+j+122uQn+mncrg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803380; c=relaxed/simple;
	bh=GHiueKTLITCaBpHg+J3EbDkGbEeJ0YFnRfmxLIVHnhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ+2+iABk4uUKhbwXtEFw0ENZQ9n2mUwRDY2rFaVT6ldgrC6Bavv210TefiTHNpmE49JFqEDjAPedM+pFMDkNw+UF4J2rfsD8uIoQgWFnIZhSaaT5jr6NRGbGO+J3tN715PFhpu99W63BEVLznLvZvOfTrK/ldDx/cMnyvfe7iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+zdbdnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+zdbdnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74570C2BBFC;
	Wed, 19 Jun 2024 13:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803379;
	bh=GHiueKTLITCaBpHg+J3EbDkGbEeJ0YFnRfmxLIVHnhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+zdbdnGRMAWpKicczkKY/arrkgzYgv9lh+iBDBRrQRT33P7zpNkSIGC2P/Rconqb
	 HKd7i1llolwB8KRjZqXm2AIf3v20KuZ/7Z0tfLJp+OMvjSmWFzlyB4kr6YzUDWzdE9
	 6G2Xp46xyoZ+PokcCPHHMfbQESpIzBJmyccR5sHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.9 216/281] x86/amd_nb: Check for invalid SMN reads
Date: Wed, 19 Jun 2024 14:56:15 +0200
Message-ID: <20240619125618.273368718@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit c625dabbf1c4a8e77e4734014f2fde7aa9071a1f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/amd_nb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -215,7 +215,14 @@ out:
 
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
 


