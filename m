Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021B54F93DB;
	Wed, 30 Sep 2026 16:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787153; cv=none; b=TbaTc8OjIGcIw4DyxZ5Zocde+P4AmoBFqjAH0g7YhuTK/Ljvw0cLf/EohdIQhqxWjoEDMnAmUsd+3/WyqaacDMYqdTJmfhlAU2LI9eJGw59jnz4+qYeLYx++nySmB8bo7r4Ia5ORI+CaMZpqek9tmqKVqv2d9sKhCYtTRR1/wQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787153; c=relaxed/simple;
	bh=zjjrvxABX5PXpJivJFuB6LAS2MRCaAAAmhj0GmzLwY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hvh3MsHSiLDJttn9tpikYoAx1MIMhG69wU1jB3FRhN+d2AgZdTmiUM+q7MDKUD7T2boRZi3oJ3nH1DnWtycCjxXk1p1Toz7C4GXUG8rYYMvqA3t1ZJld3ioJ7zpRkODUBGpAnIxZPzK0fINWw1XENftd+FwQr/jrkgrZwVuJ27c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVE39G0g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVE39G0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BF01F000FF;
	Wed, 30 Sep 2026 16:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787151;
	bh=yh0suxmBeaOeSAnNzcHgcA8/ofIjRd2ot2QVPCJFvDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVE39G0gb2kwKcuQtwtS7jc86BnF+Ew60phoZhC/m13D5iWaUHcpIdW7abTXMDFlB
	 962Jnxe4andWLnBjnCeY6YBg4IPrpW1omcWKkG1WEuLHlrbpC2H1oHX3DoLJVJcVnw
	 jS1l/ylxjb+DOkNMfAwg9xE7w30P9I37KB7FpFGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yunxiang <xyx2021@mail.ustc.edu.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 130/457] bpf: Reject non-negative offsets in stack_slot_obj_get_spi()
Date: Wed, 30 Sep 2026 17:23:55 +0200
Message-ID: <20260930152348.854636471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yunxiang <xyx2021@mail.ustc.edu.cn>

[ Upstream commit 79a9172f3ab4ad8392c5e5c8944b9b7710ade620 ]

bpf_get_spi() computes (-off - 1) / BPF_REG_SIZE using C division,
which truncates toward zero. For off == 0, this produces spi 0, the
same index used by the valid stack slot at fp-8.

stack_slot_obj_get_spi() currently checks alignment and the resulting
spi bounds, but does not reject the non-negative offset itself. It can
therefore validate a PTR_TO_STACK register holding fp+0 against an
iterator stored at fp-8 even though the runtime receives the actual fp+0
pointer. An effectful iterator kfunc can then interpret memory outside
the BPF stack as iterator state.

Reject non-negative offsets before converting the offset to an spi. All
valid stack objects begin at a negative offset from the frame pointer.

Fixes: 06accc8779c1 ("bpf: add support for open-coded iterator loops")
Signed-off-by: Xu Yunxiang <xyx2021@mail.ustc.edu.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
Link: https://lore.kernel.org/bpf/20260920210423.345636-2-xyx2021@mail.ustc.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index dc1a9ef32b78e..cb523cc5465dd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -582,7 +582,7 @@ static int stack_slot_obj_get_spi(struct bpf_verifier_env *env, struct bpf_reg_s
 	}
 
 	off = reg->var_off.value;
-	if (off % BPF_REG_SIZE) {
+	if (off >= 0 || off % BPF_REG_SIZE) {
 		verbose(env, "cannot pass in %s at an offset=%d\n", obj_kind, off);
 		return -EINVAL;
 	}
-- 
2.53.0



