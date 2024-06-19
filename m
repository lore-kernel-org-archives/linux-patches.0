Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BDA12FB31;
	Wed, 19 Jun 2024 13:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802515; cv=none; b=dHUE5hDBzru77N12t4wiEqoqsQ53Yc6dH/7RxI6exSAc6VWRzSIQKpcOfFHlxvTlD9v7/HurVBMdgovyx1tOaDDkK5H/TUog90CRY+mF+v0DbnrO5Xw6JeASgh9NNs/RofyHx23dcGbzA6KWJ7xRd1DUjlHHu5Cey9yObnnkKTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802515; c=relaxed/simple;
	bh=bWUZfzpuljJu198XuADiyT7chP3k2eU611aPCsxaZzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cS+Dh3G9NyH1tjskMKDzsBZxkcNbLREGXNgRcJYBDkmMVPHuvBzgUt/EIOYKN0n+jOvzPUyJrmw8IC1GIY5O62SOQGdBp/NPNG39sZoUO3AiPYfPDV6Y+BleZPm+Uj8eXzteKbkem/w0BmSRXNJKpf4343wroCgTuABle3WzvI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdDG/48B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdDG/48B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D11C2BBFC;
	Wed, 19 Jun 2024 13:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802514;
	bh=bWUZfzpuljJu198XuADiyT7chP3k2eU611aPCsxaZzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdDG/48BvHmVAZtT/TMYx2uLBZpcE7VvwAbwlbdJTrb3qG3UPzufZABdF+4s8AeFI
	 tpkBjqZ5JTrzd8VKn2L5Uo0AUJiVFtqVE83+X1atAv6a+Q//XFmWI0mlCPKAQQ7N+g
	 lhSdNvBXlYsvVIytbZIeZXWDZ9Pr9ubQXcZwEDLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 191/267] x86/amd_nb: Check for invalid SMN reads
Date: Wed, 19 Jun 2024 14:55:42 +0200
Message-ID: <20240619125613.669801916@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
@@ -209,7 +209,14 @@ out:
 
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
 


