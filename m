Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AD827703A;
	Tue, 12 Aug 2025 19:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026473; cv=none; b=XwX/R4nxAA3FxSdzw5nJR9zBq5RfjYMsOgH2RG2ZZ0w9PZ6394eMI5OFRht2Od3mBXgOS9FvMtA6jilXCR/A43uHe5cRzfQByq59qffavPx1h4b2T3kfNmOJtvMvh7WVeRpp5KQxXHUlFUCC7F9Ssin1psFYFpoGSjQ52nGJik0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026473; c=relaxed/simple;
	bh=NppkE5M+xsjW7cPlf99EdcJ/+Ia5SSClBx+4dSsiM2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czKiA+R6LNw+jDzT1o2OlTtfBk630eQwTQhS7zK4wzFEmC6n5H2yvEsDBKTBtXXyiEUwSmy/jg/wMi3HB6CYBJt/Qz5rRGaZC+DJMqzcxIgIwTm+XBG2oEntYV3xfCsG7TECzQIrXNCFlFDoFSAs3l2waVF1NejigiQxpcF4JCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okiZFca8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okiZFca8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD68C4CEF0;
	Tue, 12 Aug 2025 19:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026472;
	bh=NppkE5M+xsjW7cPlf99EdcJ/+Ia5SSClBx+4dSsiM2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okiZFca8ZtcbJkuAB3aCeMiq4MMd3+sof0Q+xfh7nk3volADu+QkLtWDSCVr3KHem
	 mB39pAdZ1xJxCWc2gWk7vHB5ZNitn52DWIAx7qDVf3S5cbhXFztPzEl1O4u459JlDh
	 +Vx+yL7WtXDSf/RiqH/RyA+YJTSlWaD9J0hd1kRE=
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
Subject: [PATCH 6.15 330/480] bpf: Check flow_dissector ctx accesses are aligned
Date: Tue, 12 Aug 2025 19:48:58 +0200
Message-ID: <20250812174411.051500621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 34f91c3aacb2..ac2cb6eba56e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9463,6 +9463,9 @@ static bool flow_dissector_is_valid_access(int off, int size,
 	if (off < 0 || off >= sizeof(struct __sk_buff))
 		return false;
 
+	if (off % size != 0)
+		return false;
+
 	if (type == BPF_WRITE)
 		return false;
 
-- 
2.39.5



