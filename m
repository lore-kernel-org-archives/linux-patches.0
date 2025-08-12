Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EF03F9D2;
	Tue, 12 Aug 2025 18:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022712; cv=none; b=Wy1f9yVwcQ/CdOPQl9hqRFPJOEK0Cqs+wcmczL0/pMWn9NSKoh+KhzbjGqYDw0JJfO+c4Gi6aZs1yN3HT98+Lwi4Sk6ul/B0X8f91hquPUKfAbo3RYdr7uqA224cmLE2DwlaSWTS45bLadeG7Oc7J9k2t2L5qr9s9l2L4JCPPzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022712; c=relaxed/simple;
	bh=dTJxMbnJ+JYBLjPm0uur+TkmFTfH8IQ1wb2xksN1Bqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcN7xAF6PwAFqevswPoSQh12bV6NoxcPWKsOPsu3VxMCYbecWsA9ngMFqRcAfwDYcCRn0Aeh0aY31kSGaFhYr/6IairyGag+oiU/JAP8LbzykH6mGep6jo46drZbrEaiNhHL0QagMRNBEg6cjB8fJ2d77LcP/UOduMCrPugU0Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUedhndx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUedhndx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10724C4CEF1;
	Tue, 12 Aug 2025 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022712;
	bh=dTJxMbnJ+JYBLjPm0uur+TkmFTfH8IQ1wb2xksN1Bqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUedhndxNxQconzs+cgjuiMbAw3ZOPomRpC/ZvMK6kwxVrJWX6GgNjfKgeQpvNLPa
	 J6hyuhiN++eyG1caE6b2Urgood4JYj1QrNi0iyD6ecdqWknwdrqPDawPq/ydXUhUU2
	 Hf7NHABq7UY05h0U+PUoYat8jXFbblB2QiMwI4V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ccac90e482b2a81d74aa@syzkaller.appspotmail.com,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/369] bpf: Check flow_dissector ctx accesses are aligned
Date: Tue, 12 Aug 2025 19:28:53 +0200
Message-ID: <20250812173023.650996313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit ead3d7b2b6afa5ee7958620c4329982a7d9c2b78 ]

flow_dissector_is_valid_access doesn't check that the context access is
aligned. As a consequence, an unaligned access within one of the exposed
field is considered valid and later rejected by
flow_dissector_convert_ctx_access when we try to convert it.

The later rejection is problematic because it's reported as a verifier
bug with a kernel warning and doesn't point to the right instruction in
verifier logs.

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Reported-by: syzbot+ccac90e482b2a81d74aa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ccac90e482b2a81d74aa
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/cc1b036be484c99be45eddf48bd78cc6f72839b1.1754039605.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1c0cf6f2fff5..02fedc404d7f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9407,6 +9407,9 @@ static bool flow_dissector_is_valid_access(int off, int size,
 	if (off < 0 || off >= sizeof(struct __sk_buff))
 		return false;
 
+	if (off % size != 0)
+		return false;
+
 	if (type == BPF_WRITE)
 		return false;
 
-- 
2.39.5



