Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024144D90C7;
	Mon, 31 Aug 2026 13:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183558; cv=none; b=ar3v9ZjALCQjYEVfdw41udrNsxHemnFZp5kFdrqphP/ciWzUKhONOWj4mndj008MmjN0mFSBIRhKorc0fbo61NqBEYI6FXJc+x2li5r04EEXue3eJx0+qclJbCOjpBqMWfMLRpgdWjSr+wK2oQMMHbddS+Rg0SYxvS5N5QmOQko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183558; c=relaxed/simple;
	bh=ohT452WQLvUVcqEEQvvtosXDsqRoxjA3xhJOb44r+WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/YpYyXk0XVF1380Tl5KYGSCojATAa7SOsCwUh+iH73vMnu9mync/R1ToiWZZGrW1hWS1HR3LkSmX+r/2bsBN8nxUExR7MgtHqUFatHP8EgoYeTAEgRRNswe1Lq3g/jfbkZyoGf1TpFIVew9PoznpIGiwpC4wMHK4oiXLmsMvIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLZ9aPK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLZ9aPK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5F71F00A3D;
	Mon, 31 Aug 2026 13:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183556;
	bh=1i2sU13SgT8cmIiK+48lRWLzto15QWdIbq8ZePJQJyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLZ9aPK6rWgl7slqIoi0BwpoqDzVpjBKHTa0eJEb/6wnfAOCJyqG+6pStiYLyro7n
	 zARFIDqGt7nSfm3GNF7fma3BgU8Qrcxw766x+kERednI7ElX9cDhMBPgNayKTN2f/O
	 b/w7WOd9ywq+DTBqUbGnqBTOIgSOh3MGCXT1o9zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re=20 ?=" <ricardo@marliere.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 04/71] selftests/bpf: Fix test_maps sockmap failure
Date: Mon, 31 Aug 2026 15:33:29 +0200
Message-ID: <20260831133359.255098956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 27a0f3635d862919dd7e5e93e19f3f5d1b240e57 ]

test_maps fails in the sockmap test because sockmap_verdict_prog.c
drops the packet when the first 8 bytes are not directly accessible:
	  if (data + 8 > data_end)
			  return SK_DROP;

The blamed commit removed bpf_skb_pull_data() from the stream parser
program so that the parser no longer modifies the skb. That was needed,
but it also removed an implicit side effect: bpf_skb_pull_data()
linearized enough of the skb for later direct packet access.

In this test, the send side goes through the sockmap SK_MSG path. The
skb can have skb->len == 20 while its linear area is empty, so the
verdict program sees data == data_end and drops the packet even though
the payload length is sufficient.

Keep the parser read-only, and pull the first 8 bytes in the verdict
program before reading or writing them. Reload data/data_end after
bpf_skb_pull_data() as required.

Fixes: 22a0cc10dacb ("selftests/bpf: don't modify the skb in the strparser parser prog")
Reported-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Closes: https://lore.kernel.org/bpf/e3a91acd-2b4d-4e93-a3bb-a0e9ee5ede0f@linux.dev/
Link: https://lore.kernel.org/bpf/20260701071501.39628-1-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/sockmap_verdict_prog.c     | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
index 0660f29dca955..3177bc5b733ac 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
@@ -44,8 +44,18 @@ int bpf_prog2(struct __sk_buff *skb)
 	__sink(lport);
 	__sink(rport);
 
-	if (data + 8 > data_end)
-		return SK_DROP;
+	if (data + 8 > data_end) {
+		if (bpf_skb_pull_data(skb, 8))
+			return SK_DROP;
+
+		data = (void *)(long)skb->data;
+		data_end = (void *)(long)skb->data_end;
+
+		if (data + 8 > data_end)
+			return SK_DROP;
+
+		d = data;
+	}
 
 	map = d[0];
 	sk = d[1];
-- 
2.53.0



