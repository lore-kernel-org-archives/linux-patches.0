Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FBE25F783;
	Tue, 11 Mar 2025 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705585; cv=none; b=XqGi7VYCtpCsi+uy8P6CTv4FvY2SDngF5ZJ25GuolWVPI3os6FCuLurvJOsUjhns9Qi5DKXCBV8gnBPy9pcy9XB23YoP77akcg2YEmd2dN8N/69At2s4Mfmbu/qwLYbdGns4IlhKlQhc6TWrTz5AL15WQU00ZbSV6CsqQOzz34I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705585; c=relaxed/simple;
	bh=m3XXxe8BRsCKg0ccgovl2urHpeYU2LqXuOoH5MacTsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekV4AEZzu5AO4F4Fz3A0poThaobsd1hSw4f9iJ9eHMFasvoU/Ab/cmozzg+qQMWT2jjQdgIZRvkFptUScwbJhTd1ncbtXwK1y3ChzHYwqxR4+3h5BuyvNV3UTkyzxiBzquI6bQE7OlJ9dBrR2MFNeB8YGF5QaHbqkO8EsO8LWNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iMhC3Ms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iMhC3Ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9463BC4AF09;
	Tue, 11 Mar 2025 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705585;
	bh=m3XXxe8BRsCKg0ccgovl2urHpeYU2LqXuOoH5MacTsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iMhC3MsAhDp85gjfc5RcygRRHvl49SRMh8m01Ki5jyglM4O79KqXM7xzfc/u1XPV
	 m+QWhrd1EveQETK4hsZ/lORbeXKl51IJR2iS/F2zJqbjsg7KGVuGe4roP0QPC+IgQb
	 y7SHOnKOQHkXyH0hS6lLwi/QBVlfyHYmJ/ks1v/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/328] x86/amd_nb: Restrict init function to AMD-based systems
Date: Tue, 11 Mar 2025 15:57:36 +0100
Message-ID: <20250311145718.306645046@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit bee9e840609cc67d0a7d82f22a2130fb7a0a766d ]

The code implicitly operates on AMD-based systems by matching on PCI
IDs. However, the use of these IDs is going away.

Add an explicit CPU vendor check instead of relying on PCI IDs.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241206161210.163701-3-yazen.ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/amd_nb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index e3b5de7b95988..ead78f981345c 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -538,6 +538,10 @@ static __init void fix_erratum_688(void)
 
 static __init int init_amd_nbs(void)
 {
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
+		return 0;
+
 	amd_cache_northbridges();
 	amd_cache_gart();
 
-- 
2.39.5



