Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77715235067;
	Mon,  2 Jun 2025 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876764; cv=none; b=Yx1nQHNCyfWaAfdWxV9ezpL0Bav9A10Ffip9AHO+iogxph0sxX/UyMzP6KH9uuzPHRZkbyyrU+lBT9cQ9/zLQKb/CtBK+qDuJJ7RjuoOTh3DLgdNtd2ZKETcFsom3u6R1HC/Dujlvo6ibscT3wGiuYYLMZpzNXIt53RWwMxxa2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876764; c=relaxed/simple;
	bh=3P5N7hbuZfJxDVD3thSf3hwmBx2ooa7lxecAZbniI6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVnig90yeSYzJkRsP54QcvCi0kKlw/VPZaO8dVBoLq1c1gM9qNDseov6gE3hChY/rIuta9rXUR5MYY3G+an2Szy/MKr2nQtdvx8lkDXltzYDmbg49X0XZ+DrVffitj+HQIDWe8MYVLDEqPABNiSHtqMT7tWTxBSW55yD1FvZfoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjHpgRo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjHpgRo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FACC4CEEB;
	Mon,  2 Jun 2025 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876764;
	bh=3P5N7hbuZfJxDVD3thSf3hwmBx2ooa7lxecAZbniI6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjHpgRo5hSuLSfLYV1KrPLXJ1BBzcCtapgbkfdnn9wts49v0cHaX2xuRxJvCmxg3E
	 qgW3DPCjXaOdDynsYYExTMiyBwXDRSyjOKA2xsQNCrFGwrsBFrCc9l3xh29H8JOuhx
	 jE9aIrHV/QMLyMCILEgneoo39g8VtseK/EdAE/Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/325] bpf: Return prog btf_id without capable check
Date: Mon,  2 Jun 2025 15:45:42 +0200
Message-ID: <20250602134322.457828099@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 07651ccda9ff10a8ca427670cdd06ce2c8e4269c ]

Return prog's btf_id from bpf_prog_get_info_by_fd regardless of capable
check. This patch enables scenario, when freplace program, running
from user namespace, requires to query target prog's btf.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20250317174039.161275-3-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 27fdf1b2fc469..b145f3ef3695e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4005,6 +4005,8 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	info.recursion_misses = stats.misses;
 
 	info.verified_insns = prog->aux->verified_insns;
+	if (prog->aux->btf)
+		info.btf_id = btf_obj_id(prog->aux->btf);
 
 	if (!bpf_capable()) {
 		info.jited_prog_len = 0;
@@ -4151,8 +4153,6 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 		}
 	}
 
-	if (prog->aux->btf)
-		info.btf_id = btf_obj_id(prog->aux->btf);
 	info.attach_btf_id = prog->aux->attach_btf_id;
 	if (attach_btf)
 		info.attach_btf_obj_id = btf_obj_id(attach_btf);
-- 
2.39.5



