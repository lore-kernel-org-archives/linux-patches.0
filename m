Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049448;
	b=SntI0LzUAn4EwNydNerU64z5/7zER7vQPU71ane2dG8kncEAZulwjiS8VagN2IdUbtHe
	 E/R/y+S9CFuTGfQLZ7f1iawKvIpM2Xbe5pSywBI38ZgnRQslnSq2+xR3JP5xBW9EYEAGa
	 Tbh436CVteaIC/GfbT21xOGcWqfiUFeSy0ix87jlfEOuobdofFyVMIf7imRPZtG3a+kg7
	 4YyWHXj2ND1lBUFZ9wdBlfUA+I+cnIjcd+Sv7kwFmVUJ8chG7XsKswTCdLvypryXdGBzi
	 bFvI/5Dh+wqDiLe7cWfLqOgulUI+vOq8VtSh7RcWhffJIBimazb/5OanRlhcltV/ZbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M9yg2Wz51T1WBSAAwPpwGONy65429XApFkdVINVPtIA=;
	b=Sw0m0E2GoLFDkUuHkNtYjELkJ3ri7EXK2CUkhUsLLQmkY5S3nzk1KovrRHpE7HjDexD/
	 Zn4vOdZBZy3AHoKmgzyTeXOP1UMVRQG6CZcq3YrXYwES3irex2T/8fKXXbUDp1ay86sPI
	 prTVmE2eXXzDftqJovY3J7E/1RFOyGVpquBTrZYTZr5Z3+XMviPOBnfX4KVVvPr5O6af4
	 eVLH+5Rv4eLPYJJAxNZ08o5TDtwLowsbwxZlRkhdHAowxwnEEyOlE/z1KGtQtbbKLOpe2
	 Lv6Craz89i9QIjFPbDKHNeE4lVPl13633XIXVINbcRgZ3+0h00gSFppy0sRRpi+SKeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oKvDexAE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278B0606A320;
	Thu, 19 Nov 2026 00:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oKvDexAE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6671C1F000C4;
	Thu, 19 Nov 2026 00:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049448;
	bh=M9yg2Wz51T1WBSAAwPpwGONy65429XApFkdVINVPtIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKvDexAEdY+xEkU61wYGk9CZcWPo/g7SJEeYiNFSrTh9JZgkSwDq5dWu7FgdDSHhy
	 MbL2Nz2yjr1GbDXY/XgoMd4Xq0mi/nqeFEJnwv3Ckc6yLmkmlQCGCsbjUTEjDyluVj
	 6ZoxM5XUPO4EgnFOoZp5QKgVaQQH3AvHJURCCVCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2354/2857] bpf: test_run: Fix false -EBADMSG after skb leaves CHECKSUM_COMPLETE
Date: Wed, 18 Nov 2026 15:56:28 +0100
Message-ID: <20261118150326.280762459@linuxfoundation.org>
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

From: Maxim Skokov <skokovmaksimevg@gmail.com>

[ Upstream commit 36edb1c7738dade8ed83ec4e0aef000e538b2095 ]

With BPF_F_TEST_SKB_CHECKSUM_COMPLETE, bpf_prog_test_run_skb() computes
skb->csum over the packet from the network header to the end and marks
the skb CHECKSUM_COMPLETE. After the program has run, it recomputes the
checksum and returns -EBADMSG if it does not match skb->csum.

bpf_skb_change_tail() resizes the skb with __skb_trim_rcsum() and
__skb_grow_rcsum(), which move a CHECKSUM_COMPLETE skb to CHECKSUM_NONE
and leave skb->csum as it is. The post-run check still compares against
that stale value, so a correct program fails with -EBADMSG. After a
trim, skb->csum still covers the removed bytes. After a grow, later
writes cannot update skb->csum, even with BPF_F_RECOMPUTE_CSUM, because
skb->csum is only adjusted for CHECKSUM_COMPLETE skbs.

skb->csum only holds the packet checksum while ip_summed is
CHECKSUM_COMPLETE. With CHECKSUM_NONE the stack does not rely on it and
validates the packet in software, so there is nothing to compare. Only
do the check if the skb is still CHECKSUM_COMPLETE after the run. A
program that keeps the skb CHECKSUM_COMPLETE but leaves skb->csum stale
still gets -EBADMSG.

Dropping the checksum offload is documented behaviour of
bpf_skb_change_tail() ("implicitly linearizes, unclones and drops
offloads"), and the stack does the same in other places, for example
skb_forward_csum(). The test harness has to accept CHECKSUM_NONE either
way, whether or not the helper is later taught to keep
CHECKSUM_COMPLETE.

Fixes: a3cfe84cca28 ("bpf: Add CHECKSUM_COMPLETE to bpf test progs")
Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261009174755.22026-2-skokovmaksimevg@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 84d7a4dd8f051..8233451e659a5 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1234,7 +1234,13 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		memset(__skb_push(skb, hh_len), 0, hh_len);
 	}
 
-	if (kattr->test.flags & BPF_F_TEST_SKB_CHECKSUM_COMPLETE) {
+	/*
+	 * A helper such as bpf_skb_change_tail() may have downgraded the skb
+	 * from CHECKSUM_COMPLETE. skb->csum is then unused by the stack and
+	 * there is nothing to validate.
+	 */
+	if ((kattr->test.flags & BPF_F_TEST_SKB_CHECKSUM_COMPLETE) &&
+	    skb->ip_summed == CHECKSUM_COMPLETE) {
 		const int off = skb_network_offset(skb);
 		int len = skb->len - off;
 		__wsum csum;
-- 
2.53.0



