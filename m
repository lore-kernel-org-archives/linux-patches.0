Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FB84F218;
	Thu, 13 Feb 2025 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458575; cv=none; b=P4Dr3m75B5md782gXCWCfafnnsGiFh9tmj+yI2V2scWesjdLt7NVuxhTjHdsiXU/sOCa0ot7POK62OncS20+3LR55y/4EIlE9HV+iTqVneWQscuMxOahbqaso6gvS7ibLS+dlv7BGT2ryZPZKsq4LM6HSsqKZJcxhT3s3VKsbMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458575; c=relaxed/simple;
	bh=JgTtrGSLTCnZ7sbFmNfJjQvrZ36p6vG8npx8XApNMj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxKQkxbz8xqT6ZzPB6H1ECm5s/OyUYW6SQoztEs4yDlIXcbTRio6W/mdP7xLBGNuaeDKlFJRtlpxjd0S2mNr6p7x1Xu2JXZ86BrdyVdI2Uxedj8KT36Wjopi4dPXw5xEWMutPiivrqbYMY7k6gsXsj6QwNuGzHcIRQbEHQ36rxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TPm63/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TPm63/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769A3C4CED1;
	Thu, 13 Feb 2025 14:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458574;
	bh=JgTtrGSLTCnZ7sbFmNfJjQvrZ36p6vG8npx8XApNMj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TPm63/pyL0o3lvk2km4IEuyJcLTh7ZCTFQ8FV4rxAp0DVtyi5lFAAvubByCqDWCU
	 DXKyPsfSIFMFRf/pB+YamvYvlgA5s026jDT05FrksG8cD77Ncl3ghmU7UCA0BTi/zY
	 wuDllWWc6sZON5JRIoHyaH+UYYNHyKQItqWOWyFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 018/443] x86/amd_nb: Restrict init function to AMD-based systems
Date: Thu, 13 Feb 2025 15:23:03 +0100
Message-ID: <20250213142441.323795038@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



