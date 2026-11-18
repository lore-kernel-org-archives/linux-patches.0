Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045970;
	b=oYqVEiy90kTacTgLk7tLIwMFS4IW+NtDj94n58LUUsAYcPmHJqXADaJj3qc67z9oYxDb
	 F0VAaz2TJ2p3q4yVwB7V+wwRpDeczmF18YCho3J5fyoBbsdWLHSG9fdsk17UtTZJb3VG1
	 /EWXAShdclWmTvL7vZL+zUPjpaonjmCX/BA0S6D5st/ys0NFTaFcKPgR4w7J+ZSOfuB8/
	 i8k77xt4LAVQeuSyJvALD/3+QFOdzRn8/XX+AzJp4pjFSBH9pp9iKqL1QSQ64T/IwCiuT
	 o2WRNmzek5uLAJFmHX9nABdyPCW3NhrJvOqAmKUf0Ke8fpu9JDzVbtIb6cxPYvvMBgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=80isYa8GCe2phW42zWzKVjauLi26LGxrfLkv4VZk9sI=;
	b=f5LQswZQqL/sk4USBHD6Wg4VfbcOrIbTL7oTCmpRv2y2SFMkHReSNK+kQnK7UmYE/Gk+
	 MNvkit6p0QUbzDD9uZuh265iclcy1qc5XD3shaoDL7bN62/5xn2X70rtC8XYhVO4ji8DO
	 nLHF6uN5JxS0lzuyFm7IgmrWv8RZhbyTvfcTOovqBPA85vs/nBf+3vuWBKUmVMHW15VxE
	 2QWzqmh9ZnVEVqKPLsvau47gMUUeEXxHtLkmBfJ51jcCgir3iTXEFxqPuaEPs7R3jzARA
	 GfwGzTzUURmv0zsboXsf92zGL/MBERjQ7WbJTbTTw3aFF8hZl68LIgErzSIvpiZilng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlRlnMS1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771AD606A325;
	Wed, 18 Nov 2026 23:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlRlnMS1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB1D1F000C4;
	Wed, 18 Nov 2026 23:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045970;
	bh=80isYa8GCe2phW42zWzKVjauLi26LGxrfLkv4VZk9sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlRlnMS1QCi1piGWK1rrBYuAj0k//NFpRNb8+HfRNX/PRqL1kAcbv4O433OFo6rxR
	 aNE6up7IG/4BleD3++igmjqfEyUkjdF6ZUoN72xlIDvPCEmS0/N7WOAZmvg3Gl5+h4
	 J03MnzHx+vZ3I7lBZEj8khSIjr4EtPYApOuESsEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Keith Busch <kbusch@kernel.org>,
	Andrew Stellman <astellman@stellman-greene.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1112/2857] nvmet-rdma: fix out-of-bounds write in nvmet_rdma_map_sgl_inline()
Date: Wed, 18 Nov 2026 15:35:46 +0100
Message-ID: <20261118150241.668093010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Stellman <astellman@stellman-greene.com>

[ Upstream commit d1512773a0d539669440bd9f6d050b8e12923b5f ]

nvmet_rdma_map_sgl_inline() bounds the host-supplied in-capsule SGL
offset with "off + len > inline_data_size", evaluated in 64-bit
arithmetic. off is taken straight from the host SGL descriptor
(le64_to_cpu(sgl->addr)) and len is promoted to 64-bit, so the sum
wraps: an off within len of 2^64 makes it small and the check passes.
off is then used as page_idx = off / PAGE_SIZE to index the fixed-size
rsp->cmd->inline_sg[] array (NVMET_RDMA_MAX_INLINE_SGE entries), so a
crafted offset yields an out-of-bounds scatterlist index that is written
through in nvmet_rdma_use_inline_sg().

The mapping runs while handling a received capsule, before the command
executes, so a remote RDMA peer can reach it (the Connect capsule is a
write and takes this path on a queue that has no controller yet). The
host controls only the low bits of the resulting displacement, so the
expected impact is an out-of-bounds write that faults the target
(remote denial of service).

This wrap was reported, with a KASAN reproduction, on linux-nvme in May,
and the check below was suggested in that thread. The fix that was
applied, 48c0162f647b, reworked how the offset is mapped but kept the
original check, and its page index turns a wrapped offset into an
out-of-bounds index into inline_sg[].

Reject the offset before it can wrap.

Found independently by static analysis with AI assistance, not
reproduced at runtime.

Fixes: 0d5ee2b2ab4f ("nvmet-rdma: support max(16KB, PAGE_SIZE) inline data")
Fixes: 48c0162f647b ("nvmet-rdma: handle inline data with a nonzero offset")
Reported-by: Bryam Vargas <hexlabsecurity@proton.me>
Closes: https://lore.kernel.org/all/LM21QIR-1-qJb7PViyJKCnGBnUzizeiNJVWQ3wb7ZwGezodjgKg3f-iobqOyequ-sT1jFCKJImfqNO_BKU3KO80xFITnaI5GTV_GxLUNDDc=@proton.me/
Suggested-by: Keith Busch <kbusch@kernel.org>
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 77439a3d5244b..629081e4c37c7 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -865,7 +865,8 @@ static u16 nvmet_rdma_map_sgl_inline(struct nvmet_rdma_rsp *rsp)
 		return NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 	}
 
-	if (off + len > rsp->queue->dev->inline_data_size) {
+	if (off > (u64)rsp->queue->dev->inline_data_size ||
+	    len > (u64)rsp->queue->dev->inline_data_size - off) {
 		pr_err("invalid inline data offset!\n");
 		return NVME_SC_SGL_INVALID_OFFSET | NVME_STATUS_DNR;
 	}
-- 
2.53.0



