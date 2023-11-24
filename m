Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA3F3173F;
	Fri, 24 Nov 2023 19:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8bM5igs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF06C433C9;
	Fri, 24 Nov 2023 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852775;
	bh=1+X03Ih9jMo3Ty1oVPk+bLU2VKcBRbQh99bf/mFYbr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8bM5igsVBExhkrAfCUWwPk2dDCTD3Fm9mUg8yMkvZmiIQaQuhypjQnVhglibecoM
	 AtYfFacPkpK0HqzCk1X/UT8CU7w9HkRXaYe1ELMgctAxkAXraFwC53zU9YUlbbMSsX
	 f+hNRnYzqb+/fjTMwHjeOwxoH2tYjRSy4boOY3AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Mahmoud <mmahmoud@redhat.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Tao Lyu <tao.lyu@epfl.ch>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 093/193] bpf: Fix precision tracking for BPF_ALU | BPF_TO_BE | BPF_END
Date: Fri, 24 Nov 2023 17:53:40 +0000
Message-ID: <20231124171950.974623888@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

commit 291d044fd51f8484066300ee42afecf8c8db7b3a upstream.

BPF_END and BPF_NEG has a different specification for the source bit in
the opcode compared to other ALU/ALU64 instructions, and is either
reserved or use to specify the byte swap endianness. In both cases the
source bit does not encode source operand location, and src_reg is a
reserved field.

backtrack_insn() currently does not differentiate BPF_END and BPF_NEG
from other ALU/ALU64 instructions, which leads to r0 being incorrectly
marked as precise when processing BPF_ALU | BPF_TO_BE | BPF_END
instructions. This commit teaches backtrack_insn() to correctly mark
precision for such case.

While precise tracking of BPF_NEG and other BPF_END instructions are
correct and does not need fixing, this commit opt to process all BPF_NEG
and BPF_END instructions within the same if-clause to better align with
current convention used in the verifier (e.g. check_alu_op).

Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
Cc: stable@vger.kernel.org
Reported-by: Mohamed Mahmoud <mmahmoud@redhat.com>
Closes: https://lore.kernel.org/r/87jzrrwptf.fsf@toke.dk
Tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Tao Lyu <tao.lyu@epfl.ch>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/r/20231102053913.12004-2-shung-hsi.yu@suse.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1841,7 +1841,12 @@ static int backtrack_insn(struct bpf_ver
 	if (class == BPF_ALU || class == BPF_ALU64) {
 		if (!(*reg_mask & dreg))
 			return 0;
-		if (opcode == BPF_MOV) {
+		if (opcode == BPF_END || opcode == BPF_NEG) {
+			/* sreg is reserved and unused
+			 * dreg still need precision before this insn
+			 */
+			return 0;
+		} else if (opcode == BPF_MOV) {
 			if (BPF_SRC(insn->code) == BPF_X) {
 				/* dreg = sreg
 				 * dreg needs precision after this insn


