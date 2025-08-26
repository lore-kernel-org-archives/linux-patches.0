Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623AE20DD51;
	Tue, 26 Aug 2025 14:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218775; cv=none; b=m2HhXmlEqFdw5chCxcj6kV1qjR5AvC2amGEV7HcurAHPWsSIU4LD8Y0bF8Uq8DLQ16c2VpD8zzkIMNI6JmD8p5vPuc+hk84JdUemE6l7BWy/cpnBHd31zHaigBau7J56kELcLkX0RKKZiKsKVdXQN0t6c3rnuuIQ+qybTuwhpV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218775; c=relaxed/simple;
	bh=pipHSf7fOpqIUnBmCE+gVf3qKiDEUmqAUO7roc6Wqxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEUnNxwyZABP3gLmsQ1fss6rgJfGs/hpSIAM6KLEuXw+BqfGxpuvHb+dkfhYSEOdliAuUKQqlEknuhXTu7scqGjGgQoyrUSDq7GUwx+gnV54aCIc2BTbCmkOuFwSDb0lC2M6JEzWtqbciKJu6iJlmPWZeLqpexxK7UdrCbhfOhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txJAPT8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txJAPT8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8489C4CEF1;
	Tue, 26 Aug 2025 14:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218775;
	bh=pipHSf7fOpqIUnBmCE+gVf3qKiDEUmqAUO7roc6Wqxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txJAPT8NFInxIMrlweq/FUdTiRwEAWGkFzSQbmA5xytEhfrCyRyzJUROuw39rfOWJ
	 McgTDJu5dqr+GxczxbGs5KHSbDe0DPiIruTcGf20p+1aBTbg40dOuoz/mUeuteznZq
	 mt0O1Ps020rtChXHX/1HOZWwzYRDQVIYuCJ5MDsY=
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
Subject: [PATCH 5.4 129/403] bpf: Check flow_dissector ctx accesses are aligned
Date: Tue, 26 Aug 2025 13:07:35 +0200
Message-ID: <20250826110910.304043212@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e6ec6f013ec0..fd18497977bd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7282,6 +7282,9 @@ static bool flow_dissector_is_valid_access(int off, int size,
 	if (off < 0 || off >= sizeof(struct __sk_buff))
 		return false;
 
+	if (off % size != 0)
+		return false;
+
 	if (type == BPF_WRITE)
 		return false;
 
-- 
2.39.5



