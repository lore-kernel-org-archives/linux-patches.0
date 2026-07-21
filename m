Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43B63B6BE3;
	Tue, 21 Jul 2026 20:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666639; cv=none; b=OqrxSkeompFXdt5b4gtgB8se8PVOBNK9zuARqikO44irpVwRq+CF4+qZ1IT1YmYLWuinCK8ByBZ+IUjhuWReiII/V6rjnH1ZBIFlSqCeKvQWtFIgoxlfwKg4Gywurr5/uOAhgCNzu5UBO6Fa2vw+GHP0/Zs+l5VVbVLxlXy5rJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666639; c=relaxed/simple;
	bh=qDJVftTHYgY2CSy5qMFKSdAs2pNEPLwcf5NGaEkng2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t28vkkgLLmj5j6aJ3TXtcW0E6YBXvUhZwMt1p8rVin4CEKHWcO7Bu3BH/n54oa3msKUPW3vz2Q2t43z44VHlVod/TS78FVfGAsXyVn0pcAB5QgENdS68jatJCTiy0cO0cPZVWjn2CHtWPgi4+Ue7TguNgAZA4GVjEoj4mMNruPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbmZbvFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbmZbvFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1D81F000E9;
	Tue, 21 Jul 2026 20:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666638;
	bh=vZaQvJ5JLPM11iLLF2393UZcM2OV7g9SWnqe3oXY7u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbmZbvFLidfFXSzaWas9q+WznaqLzlc5IFmlbtkklocWlukHpRt4+5ZRvyOzJ6HAu
	 alA1Y4L0H/ZSkWfsrIRtLxRyYZ/2Ceuyr6JBDSaM8XhlGnZHz6+6sc2B2vD0cmpgbH
	 B0sRKJyFJ/CfAdeujn7zbUPNxAJ3EOcSfpGD9ln0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerhorst <luis.gerhorst@fau.de>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0759/1266] bpf: Fix stack slot index in nospec checks
Date: Tue, 21 Jul 2026 17:19:56 +0200
Message-ID: <20260721152458.851787039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>

[ Upstream commit d1d53aa30ab3b5ae89161c9cc840b3f7489ad386 ]

check_stack_write_fixed_off() computes the byte slot for a fixed-offset
stack write as -off - 1, and records each written byte in slot_type[] with
(slot - i) % BPF_REG_SIZE.

The Spectre v4 sanitization pre-check uses slot_type[i] instead. For a
4-byte write at fp-8 after the lower half of fp-8 has been zeroed, the
pre-check scans bytes 0..3 and sees STACK_ZERO while the actual write updates
bytes 7..4. That can leave the second half-slot write without nospec_result
even though the bytes being overwritten still require sanitization.

Use the same slot index in the sanitization pre-check that the write path uses
when updating slot_type[].

Fixes: 2039f26f3aca ("bpf: Fix leakage due to insufficient speculative store bypass mitigation")
Acked-by: Luis Gerhorst <luis.gerhorst@fau.de>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
Link: https://lore.kernel.org/r/20260618-f01-11-stack-nospec-slot-index-v3-1-780297041721@mails.tsinghua.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f638b2d3a42fbc..1da0092122c1db 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4672,7 +4672,8 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 		bool sanitize = reg && is_spillable_regtype(reg->type);
 
 		for (i = 0; i < size; i++) {
-			u8 type = state->stack[spi].slot_type[i];
+			u8 type = state->stack[spi].slot_type[(slot - i) %
+							      BPF_REG_SIZE];
 
 			if (type != STACK_MISC && type != STACK_ZERO) {
 				sanitize = true;
-- 
2.53.0



