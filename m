Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF56D7DA6A;
	Wed,  5 Feb 2025 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766162; cv=none; b=hKNwk9CXRJXrD6Fa4eb58HXPOBz6QpcWgUGPYSNpDPm2NiZYEjT6RPhdJFyu1e0DMfTNgV64KWFd0AIUOkzIopzmqnfr8HOW7vOBlSSzX8z/d//yIL+nLmLckn0lPyU/sWWkiBkIZtCytK4sqESRjG3xS4ybDL1Nn+nITXa1mPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766162; c=relaxed/simple;
	bh=26ToBPSgEvYia6R+2gcdUIYKaATc7yHQElONWh1klYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9XuhB6JV+WXamHUmHve84A2cd4+ND9IhgTQnoIs3vMhAxh525WNFDGjdmovONEFWFN3GvPcWB60H5y4npcIF9XfO4dTP9ZxqrtJ3Cw2ZAqJY4/NMcs5ZiGFau2143W60+EfrqfEhqFVSPssEcC0Z2lEk1Vsxq3Zvp18NGfgLE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjrNTWMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjrNTWMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FA2C4CED1;
	Wed,  5 Feb 2025 14:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766161;
	bh=26ToBPSgEvYia6R+2gcdUIYKaATc7yHQElONWh1klYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjrNTWMBf+THRNUAoUGEfCZUTLhHlA9N6xcSpbKO2aibj82tv39IBWrR0Ci0Pp2I7
	 WSP0JwBgn7cZYLSHf9eC75fYppmu5Xufmh1AllWGeS+JsITCah9/oEwkm0qR0dtjcv
	 a3EmxVvSNvYXFX2sic+0IbXADBAGr1I8g6KOJ1yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 248/623] libbpf: dont adjust USDT semaphore address if .stapsdt.base addr is missing
Date: Wed,  5 Feb 2025 14:39:50 +0100
Message-ID: <20250205134505.712562944@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 98ebe5ef6f5c4517ba92fb3e56f95827ebea83fd ]

USDT ELF note optionally can record an offset of .stapsdt.base, which is
used to make adjustments to USDT target attach address. Currently,
libbpf will do this address adjustment unconditionally if it finds
.stapsdt.base ELF section in target binary. But there is a corner case
where .stapsdt.base ELF section is present, but specific USDT note
doesn't reference it. In such case, libbpf will basically just add base
address and end up with absolutely incorrect USDT target address.

This adjustment has to be done only if both .stapsdt.sema section is
present and USDT note is recording a reference to it.

Fixes: 74cc6311cec9 ("libbpf: Add USDT notes parsing and resolution logic")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20241121224558.796110-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/usdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 5f085736c6c45..4e4a52742b01c 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -661,7 +661,7 @@ static int collect_usdt_targets(struct usdt_manager *man, Elf *elf, const char *
 		 *   [0] https://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
 		 */
 		usdt_abs_ip = note.loc_addr;
-		if (base_addr)
+		if (base_addr && note.base_addr)
 			usdt_abs_ip += base_addr - note.base_addr;
 
 		/* When attaching uprobes (which is what USDTs basically are)
-- 
2.39.5



