Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593F71DEFF3;
	Wed, 19 Feb 2025 09:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956211; cv=none; b=pMK96tOgBHzdm+UazyJn04U1sDWDuSf6qOIwuLS5Q2H5SyvvMe+hMyqB+NT8+IijSJ9/ASHR3qoBgngODD/MNChOOAUxaqywHlt+y78SUUNy680ak5upyN5Pm4S6jhIo9oF1P3vlBebSreCKvG1X7z8s42P0JmNSvyNHIaAyhFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956211; c=relaxed/simple;
	bh=hkT1KN0+Lq+29EiMjBqMEbPtWmkgBKAAQ1yim52IDI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FG2FEELfWw3L8LRK7Wu093zApyRsUSGrfz3TLc2L3SIsqBWA4bpebwvqM7AvN5kKQqJnIIYEZsl/py8me3qpvISBMelf+VWGDCLPzcTcJy8cpmjgE0c8tyqg6oIeVZxYMX8acNqpmItw+nCqMztddyXRtaXtxJpP7wb4sbD26ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTZF5QLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTZF5QLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5D6C4CED1;
	Wed, 19 Feb 2025 09:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956209;
	bh=hkT1KN0+Lq+29EiMjBqMEbPtWmkgBKAAQ1yim52IDI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTZF5QLMLEdmS3muIBkprEZ5niarzn2IGrTsoPa16thH0qlNwAnNPuQPnjilLS9e8
	 UEDgLj/X6jQ/fFTL5I6nCyV7jrc3AG9jASEhqcCghc/iNJ8iY9Jt8DVkSDmT21AQTt
	 kQDj9mYjQ/HXEyrx6dRt16zdF+zfCPlEtWuWzpiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/578] libbpf: dont adjust USDT semaphore address if .stapsdt.base addr is missing
Date: Wed, 19 Feb 2025 09:21:46 +0100
Message-ID: <20250219082656.978617985@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index af1cb30556b46..b8e83712a5d72 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -653,7 +653,7 @@ static int collect_usdt_targets(struct usdt_manager *man, Elf *elf, const char *
 		 *   [0] https://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
 		 */
 		usdt_abs_ip = note.loc_addr;
-		if (base_addr)
+		if (base_addr && note.base_addr)
 			usdt_abs_ip += base_addr - note.base_addr;
 
 		/* When attaching uprobes (which is what USDTs basically are)
-- 
2.39.5



