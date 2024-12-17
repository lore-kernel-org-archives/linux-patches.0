Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35B08615A;
	Tue, 17 Dec 2024 17:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456236; cv=none; b=CZI6Psx1SInvgBmFmo61RMc4hlWMYVPNF/xw1aw2t/vRusR93Kpsho40aUIHjzhMD8iCSdpk6XHSY4I6yc1x2jfOJZFxZ8clHkP/sW8NgYRkc2j4EKZlPHsaYG7HH+fLNqB9qPnlTRIV9AHvJrxzqWEP/9tpatnfWhz1yKeF6sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456236; c=relaxed/simple;
	bh=u9ItzheF7vMvo2U9nOdAaxEKozQ/bMUlxoO0qjYCB6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OysZYT91HKWtUBP199XItnqKiP2Ox3bg/gEhLTgp7mwlFGAHa36AcmTa40OImbJVOLtSlWHmRt8O2SEfr4zHJBXTRjPB8Tczi1/mhFknpeq4+7B+ZTOXHJBOHO8Slc/fbTjV/v5+4pm3bwD661V1zODAIKzhjZEwG9e1hcotrYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUxv8PA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUxv8PA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0A6C4CED3;
	Tue, 17 Dec 2024 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456235;
	bh=u9ItzheF7vMvo2U9nOdAaxEKozQ/bMUlxoO0qjYCB6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUxv8PA/M1mzdCewIYzI2dyD+75R/netNBi5qUdms3zNpcqBvaWt/GJ1LXt3oeQK4
	 Te15jwb//vjI0H9DxGymyMtuMlurXcLWxNARSZhuJEMGRBacpXL2fUOmz+4i2W7tb5
	 ALVVntm+XUpxmqoMtttE147fh7yagkUX0YruU6pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lonial Con <kongln9170@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 096/109] bpf: sync_linked_regs() must preserve subreg_def
Date: Tue, 17 Dec 2024 18:08:20 +0100
Message-ID: <20241217170537.401138912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eduard Zingerman <eddyz87@gmail.com>

commit e9bd9c498cb0f5843996dbe5cbce7a1836a83c70 upstream.

Range propagation must not affect subreg_def marks, otherwise the
following example is rewritten by verifier incorrectly when
BPF_F_TEST_RND_HI32 flag is set:

  0: call bpf_ktime_get_ns                   call bpf_ktime_get_ns
  1: r0 &= 0x7fffffff       after verifier   r0 &= 0x7fffffff
  2: w1 = w0                rewrites         w1 = w0
  3: if w0 < 10 goto +0     -------------->  r11 = 0x2f5674a6     (r)
  4: r1 >>= 32                               r11 <<= 32           (r)
  5: r0 = r1                                 r1 |= r11            (r)
  6: exit;                                   if w0 < 0xa goto pc+0
                                             r1 >>= 32
                                             r0 = r1
                                             exit

(or zero extension of w1 at (2) is missing for architectures that
 require zero extension for upper register half).

The following happens w/o this patch:
- r0 is marked as not a subreg at (0);
- w1 is marked as subreg at (2);
- w1 subreg_def is overridden at (3) by copy_register_state();
- w1 is read at (5) but mark_insn_zext() does not mark (2)
  for zero extension, because w1 subreg_def is not set;
- because of BPF_F_TEST_RND_HI32 flag verifier inserts random
  value for hi32 bits of (2) (marked (r));
- this random value is read at (5).

Fixes: 75748837b7e5 ("bpf: Propagate scalar ranges through register assignments.")
Reported-by: Lonial Con <kongln9170@gmail.com>
Signed-off-by: Lonial Con <kongln9170@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Closes: https://lore.kernel.org/bpf/7e2aa30a62d740db182c170fdd8f81c596df280d.camel@gmail.com
Link: https://lore.kernel.org/bpf/20240924210844.1758441-1-eddyz87@gmail.com
[ shung-hsi.yu: sync_linked_regs() was called find_equal_scalars() before commit
  4bf79f9be434 ("bpf: Track equal scalars history on per-instruction level"), and
  modification is done because there is only a single call to
  copy_register_state() before commit 98d7ca374ba4 ("bpf: Track delta between
  "linked" registers."). ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14497,8 +14497,11 @@ static void find_equal_scalars(struct bp
 	struct bpf_reg_state *reg;
 
 	bpf_for_each_reg_in_vstate(vstate, state, reg, ({
-		if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
+		if (reg->type == SCALAR_VALUE && reg->id == known_reg->id) {
+			s32 saved_subreg_def = reg->subreg_def;
 			copy_register_state(reg, known_reg);
+			reg->subreg_def = saved_subreg_def;
+		}
 	}));
 }
 


