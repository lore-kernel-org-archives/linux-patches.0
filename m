Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABC0F510;
	Wed,  5 Feb 2025 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764252; cv=none; b=R5UHPsnJXFxvRNkFOurlYS5AKOQ/78f27QGX4neaQXwe+Los1KLqRNy3oRSsTBz6lSeWgLTrcAmavjQEqR09jcpA39l1KrIsY2Iqm2hijyYF1elapIkp8oGZz1ynsJmD0yy0kVP3IGUCmJMemfFP7FvvhnWwJ8u5OuO5/pQAHnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764252; c=relaxed/simple;
	bh=Cs02ncU07pypBV/RLjCHbvKuFyAJgBjy0h0XlMQiRuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIuyuOTWfgfQuF7hwP5yYRszVz6c4zkFsyc1pDAMs43tFh5Wx71PJoCnpRiuqIHhZJqAVa774jbQ1vaVI6sTzDSTmSrkYccVR3gUsHv/zPq+dP5fptWw9/34Enixq0Vw6ricPb7qBAjOC/a4YoNVT60uoYYR6rChhTj/pL1QxSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvaPxA/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvaPxA/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC3EC4CED1;
	Wed,  5 Feb 2025 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764252;
	bh=Cs02ncU07pypBV/RLjCHbvKuFyAJgBjy0h0XlMQiRuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvaPxA/mivIlHTUQT5whle+9Da4+dcaISoUYFcVnXLRsqKyFWiUiygTAnuAz96EWU
	 mZSYVveqgLO6VYIyLlp4Or/ZI1mvwKwGU2WpWDfLY6L87ghH6Zx6z5Tb9pwOung7V9
	 EIZnGl7mNg9NP5NoQyF6bRPoXyILNxQOGXO4GBxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/393] libbpf: dont adjust USDT semaphore address if .stapsdt.base addr is missing
Date: Wed,  5 Feb 2025 14:41:12 +0100
Message-ID: <20250205134426.156561955@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 93794f01bb67c..6ff28e7bf5e3d 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -659,7 +659,7 @@ static int collect_usdt_targets(struct usdt_manager *man, Elf *elf, const char *
 		 *   [0] https://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
 		 */
 		usdt_abs_ip = note.loc_addr;
-		if (base_addr)
+		if (base_addr && note.base_addr)
 			usdt_abs_ip += base_addr - note.base_addr;
 
 		/* When attaching uprobes (which is what USDTs basically are)
-- 
2.39.5



