Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DFF281360;
	Thu, 13 Feb 2025 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457100; cv=none; b=t7ORRcjrbt+f2HVhvxesDuq0Dx2tTOPg/M0xEBnG5bepD3GuKKSi/a6G+wrWP8la2zw9CVLr3a70o9FW3PcXd3DfLALOP24hiiMdmtRAsFr586UGTRdvj9uzSS5NrWLaIPeTp6n+dWlLAhzyggzuoM66ZWzBJsgJgPdHuSLv9Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457100; c=relaxed/simple;
	bh=eYqVfenUrUBSlqe51aOUqxMzD/QRT7qC9Sk1bFkEOhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKlKfwK9+QF+KCbcXS9s4HDB2Y+hYxnumOgZqOgWLIYkU8/9UVE3Jjcn2EtvjYDL0zUfZbs/jDDTCAKBwLyePBSzbAOQtwRbA40tsCseQdo6Lj6Gy+kul4QrPN8jI5w1kkyJ2MBuaT3KIUE9qo1Dr2Q13F+FsRxHhm0D4XoLXbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mFVgmuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mFVgmuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E01C4CED1;
	Thu, 13 Feb 2025 14:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457099;
	bh=eYqVfenUrUBSlqe51aOUqxMzD/QRT7qC9Sk1bFkEOhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mFVgmuoIIskwWra8Pox1dEtJysMQeF+OCfPwMXvnN0nd33Uy+BoQlDmqUR2R8tbm
	 +iQ6nq7+pPUAhJiXLCvJGVpN441TCdqbuUcdkoGalIhgeDIKLgeDCC+ChSdwExlYqg
	 JMltKKJaDFr7zhV4YjGNueWY+l+Ot6TIYI/YHUs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/422] x86/amd_nb: Restrict init function to AMD-based systems
Date: Thu, 13 Feb 2025 15:22:45 +0100
Message-ID: <20250213142437.059177035@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9fe9972d2071b..37b8244899d89 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -582,6 +582,10 @@ static __init void fix_erratum_688(void)
 
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



