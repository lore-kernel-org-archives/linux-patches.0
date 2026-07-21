Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9963434E2F;
	Tue, 21 Jul 2026 22:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673949; cv=none; b=lxmL4ccUmb4R7wLjwK6IfJU8GSj8ex99LGWLkGGOvGZfTlqMnrkvy8+Y91R7CSZTfDBS2SG1jtiH1Q1oPrcwwl6F++z2xhil1smU0jv37HoGGISek7/9sZ/RHv8sjzzrN5hKZVzMwtr1KF6jYYSgjFkkcT33yyi0smjf+9+HyIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673949; c=relaxed/simple;
	bh=0/J2b3Mi1jozJMeVnz/jv8ZFb/vrnZADQlB0T/1pWss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQC+bbh4m3c/0hOKNR+lvQQqMqriwYIzP6fx2P6P5Lh/uKDwr3xwrKK4sVPu0ojp8V/GyVmSrzbiVF57Wnh/YJ7o2t+TjMOnAXT9r75X1mcxT+zgrVXIYluK/gSkrAp7u5c+JZjTJkaOkLBgFcxbjeagScNHZDxg5jeespeT5AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnBo5oLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnBo5oLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E181F000E9;
	Tue, 21 Jul 2026 22:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673948;
	bh=+XcxngDeljTASh5AGKmZSYjQUsyu2F6vODSOJZHmgrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnBo5oLK6kW1W9FcxTYyU8fs6yU945kzrY/yMODmd3foYu2zf/Cx+dBCRZoN8bRar
	 +zqOVmXyIIOKDQ4LA0j5IbsiukA3t/4vq5Hqkt9fmiswEVbZE9eYjBFBjlngyfdlKE
	 QwATn5hPLTqWb2AO3IPMcjBx6Qw+YhpCb4eAHiQU=
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
Subject: [PATCH 5.10 354/699] bpf: Fix stack slot index in nospec checks
Date: Tue, 21 Jul 2026 17:21:53 +0200
Message-ID: <20260721152403.678632606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e6cf29b117e1a5..19e1f7fff07a9c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2523,7 +2523,8 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 		bool sanitize = reg && is_spillable_regtype(reg->type);
 
 		for (i = 0; i < size; i++) {
-			u8 type = state->stack[spi].slot_type[i];
+			u8 type = state->stack[spi].slot_type[(slot - i) %
+							      BPF_REG_SIZE];
 
 			if (type != STACK_MISC && type != STACK_ZERO) {
 				sanitize = true;
-- 
2.53.0



