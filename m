Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3B441836B;
	Fri,  7 Aug 2026 14:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114711; cv=none; b=AkoAM8gNIIWicRHc23JqjFeu12mgum/FKjhaiUfuyZV4u3HIMcRRBGUv5dy7XWZTUZn5CoJAFRuJhWyf5Ia4jnUVV0ujL880c1WU5HsB177AElXqhSAc1bK/6QBRzNGghr9iJYKeoKSmDfgnnSTns8JwjVJAcMKw7W5s3GTaXzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114711; c=relaxed/simple;
	bh=pBBd21tT05729A3DTWpOa8h7JS99PvUzzRWnv2cTGh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ltJkgIkBIg8PYLi8NJXehL8Mrkg9TurAZrayU1j8qT73PFKvsG78OnO/qZxFHpTFdhUhgjRIbmSp3GX0MUL1llF5jqI395w2sPwID2GmgBtQFuHPYDczXVLYywzz+THVVvO4wCr7nciUarPv4E/nHMfe5c6xGDekWHCP7zYmmww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ah1R009F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ah1R009F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C772E1F000E9;
	Fri,  7 Aug 2026 14:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114710;
	bh=CadYK0fvgCSrPucbG9N7R8o0xcpUBiI/8jlcp+VRemw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ah1R009FVM0I6UnC/5zNJ/1ZeR3mUT4Hi8tVcfWLD3HUHVbAqesSsClEMI2HR0taX
	 pSRwCFilDPwbD3gVAuDMLLH8dtmH0LIWdFaGYgOsRWMDy+21Sg/xpWdaNflKjT0CD4
	 Mg0vN34yQajXx+vxtaROAhBYqZ6uo+jUr3Jc3Zvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/396] selftests/seccomp: Fix pointer type mismatch build error
Date: Fri,  7 Aug 2026 16:33:01 +0200
Message-ID: <20260807143424.734170201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>

[ Upstream commit 3421b9b056a6576d0ebac1030eafb48ad0544092 ]

We hit the following build error while running the seccomp selftests in
our testing.

CC seccomp_bpf
seccomp_bpf.c: In function ‘UPROBE_setup’:
seccomp_bpf.c:5175:74: error: pointer type mismatch in conditional expression [-Wincompatible-pointer-types]
5175 | offset = get_uprobe_offset(variant->uretprobe ? probed_uretprobe : probed_uprobe);
| ^
seccomp_bpf.c:5175:57: note: first expression has type ‘int (*)(void)’
5175 | offset = get_uprobe_offset(variant->uretprobe ? probed_uretprobe : probed_uprobe);
| ^~~~~~~~~~~~~~~~
seccomp_bpf.c:5175:76: note: second expression has type ‘int (__attribute__((nocf_check)) *)(void)’
5175 | offset = get_uprobe_offset(variant->uretprobe ? probed_uretprobe : probed_uprobe);
| ^~~~~~~~~~~~~

get_uprobe_offset() takes a 'const void *' argument, so cast both
operands to 'void *'.

Fixes: 9ffc7a635c35 ("selftests/seccomp: validate uprobe syscall passes through seccomp")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://patch.msgid.link/20260715053559.28535-1-kuan-ying.lee@canonical.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 874f17763536b..19c9afa0be719 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -5172,7 +5172,8 @@ FIXTURE_SETUP(UPROBE)
 		ASSERT_GE(bit, 0);
 	}
 
-	offset = get_uprobe_offset(variant->uretprobe ? probed_uretprobe : probed_uprobe);
+	offset = get_uprobe_offset(variant->uretprobe ? (void *)probed_uretprobe
+						      : (void *)probed_uprobe);
 	ASSERT_GE(offset, 0);
 
 	if (variant->uretprobe)
-- 
2.53.0



