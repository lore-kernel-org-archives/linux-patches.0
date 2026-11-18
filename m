Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015292;
	b=Up3oTfQM2zzvYM1VqTjZqtbEO9erOA3qQAK+WayOugo72/9vZcjaClFZQAg+TPsc3vSv
	 hG8Z4MmiyOR+cgye+cC/L0ofRoAxSmNPIVehXc44rlIfBTVre93CWhtFij1yJzvAHiXkB
	 FEX/Sg/vv56ooX9HOfSMItcfiKntGrnIjee1MggV4UKO1JOERparDY+5qpgy09ZCcQ5iF
	 QXazoNnIcaeOLq7VwH1evAyIBIm9HrMUjMpNicf6rPh81TaLg9zRSyysOh9EOptT04UPV
	 Uipwzh+mmTkHmCROPFqXG9XTGy+Tge3HC+wcW2VOR+mENN8RFRp/NDX+iie+RhfysuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rrw7uFW+lQnae3P3fs9opryv9f6OlY7kSBJz0+ZQsdM=;
	b=qR4iSz3tzraZAUfnGAmkFpeZTG7hpUf88aHqN4b0w7Q1uLEXiSFK1SKXmxKnkHGFmM3w
	 lE+0sEE1zFfDUppSY4SLeFBwFumSoFNNdE6UtzQY3Dk4Vz3jVNMrNzTf/rsSeQ/gD/Cje
	 uReCUD9/Qbj5TiT2JV4nowBKg/QdWEQsW5UjdWWWGciED9hhAl60Or4bFfWh90OGOXIqV
	 7sgRxC4eBQw0VcaTCJos0piE30EfbcBWXpKLoKFE6/ZDTqomPjJCGoeB49oCVKLOH4v0q
	 AF0DDEHFnm3TXCs2jq7HNbVfzV5h14graZ+lxqLYvxlihMsOVzomCFRZfStSO6WX1jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yCEhpP43;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B64F606A320;
	Wed, 18 Nov 2026 15:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yCEhpP43
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803311F000C4;
	Wed, 18 Nov 2026 15:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015292;
	bh=rrw7uFW+lQnae3P3fs9opryv9f6OlY7kSBJz0+ZQsdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCEhpP43ppdEb+9ZBqUtPAMWgwfrMnK7m5LqHRqiX7mvaOcTeJp/1+S3tXV6/6VI4
	 edPmS+Renfs7qDveySkNnvXN4yfeTFGmh8Lcik16gdroeLidy7g7r7BFY4oszasGnF
	 OPEF316Ahfo/N+N4v/CfkEPDFaqq9BI0lVkFgXCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0079/2651] libbpf: Fix usdt attach failure when nop10 crosses page boundary
Date: Wed, 18 Nov 2026 15:21:59 +0100
Message-ID: <20261118150250.767897506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 8b94878b2572f0f41e6002d0fe2cc4086ddc2a47 ]

The kernel refuses to attach to a nop10 that crosses a page boundary,
since it can't be atomically rewritten:

	/* can_optimize(), arch/x86/kernel/uprobes.c */
	/* We can't do cross page atomic writes yet. */
	return PAGE_SIZE - (vaddr & ~PAGE_MASK) >= OPT_INSN_SIZE;

Whether the nop10 crosses a page is purely up to the binary layout, so
this does happen in practice. libbpf doesn't check for it and blindly
shifts the uprobe onto the nop10, and the attach then fails with
-ENOTSUPP. Just keep the uprobe on the preceding 1-byte nop in that
case, it works everywhere as a regular int3 uprobe.

Fixes: ee2862439e5c ("libbpf: Change has_nop_combo to work on top of nop10")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260825150444.31603-1-jiayuan.chen@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/usdt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 2e56e3ab5b6cc..ee9d1b614883c 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -608,8 +608,12 @@ static bool has_nop_combo(int fd, long off)
 	unsigned char nop_combo[11] = {
 		0x90, 0x66, 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00,
 	};
+	long page_sz = getpagesize();
 	unsigned char buf[11];
 
+	/* the kernel can't attach to a nop10 that crosses a page boundary */
+	if ((off + 1) % page_sz + 10 > page_sz)
+		return false;
 	if (pread(fd, buf, 11, off) != 11)
 		return false;
 	return memcmp(buf, nop_combo, 11) == 0;
-- 
2.53.0



