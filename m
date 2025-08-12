Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB36E2ECE93;
	Tue, 12 Aug 2025 18:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023663; cv=none; b=hCg4dqDqtA2knxSb6Eyy7rrtLqOOngJsvNYuk0RVHOF4l/Ls6ORkgP1ErKcG0bhZGtbjdLH77bzKmy2F11p4kiAoBWanhf5ysnzrra9/pq2IfyYWES0G6hVtc2vJZKCwN2vEzY3trSEerApQfqugLe8elufRM0U27/r1pISE+i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023663; c=relaxed/simple;
	bh=WI/EBr7e6dalzEQFqeHFThuNy0ACbswWNlSqvpjOmLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbHN8D9xmeEjkLGFGD2lIeVI/z9+kvsRnOXeSs/4bHm2lcxBCpELZzChyU+dhvhmT/AVAX07y3Y8l5sVVIta5MXGa3Cxagwk7lH3HhUi1wZZJpa8iYaZPx2rio3EIY7dWEcaSst8kakS/QIpE8lMsZmNuHEEoIkEmiMt16NdcZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0V9/6KK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0V9/6KK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA9CC4CEF0;
	Tue, 12 Aug 2025 18:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023662;
	bh=WI/EBr7e6dalzEQFqeHFThuNy0ACbswWNlSqvpjOmLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0V9/6KK30suGTJFC2drEerObTiXcJKqahUmXJWMP6IxDWqOTQs7yakux0Ji4c9AkY
	 nHEbENmaVWVu2cBAwo5Qp2g7r3hsL7X+cZaN8Aob4Rxk8+sdu8K4j3smjwBkfza/Z0
	 kdVC3otQlafoENz2Y67QV2J/EVt9C5e6V1jVfnZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a36aac327960ff474804@syzkaller.appspotmail.com,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 146/627] bpf: handle jset (if a & b ...) as a jump in CFG computation
Date: Tue, 12 Aug 2025 19:27:21 +0200
Message-ID: <20250812173424.848377199@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 3157f7e2999616ac91f4d559a8566214f74000a5 ]

BPF_JSET is a conditional jump and currently verifier.c:can_jump()
does not know about that. This can lead to incorrect live registers
and SCC computation.

E.g. in the following example:

   1: r0 = 1;
   2: r2 = 2;
   3: if r1 & 0x7 goto +1;
   4: exit;
   5: r0 = r2;
   6: exit;

W/o this fix insn_successors(3) will return only (4), a jump to (5)
would be missed and r2 won't be marked as alive at (3).

Fixes: 14c8552db644 ("bpf: simple DFA-based live registers analysis")
Reported-by: syzbot+a36aac327960ff474804@syzkaller.appspotmail.com
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20250613175331.3238739-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 169845710c7e..97e07eb31fec 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -23671,6 +23671,7 @@ static bool can_jump(struct bpf_insn *insn)
 	case BPF_JSLT:
 	case BPF_JSLE:
 	case BPF_JCOND:
+	case BPF_JSET:
 		return true;
 	}
 
-- 
2.39.5



