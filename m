Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7541221FAC;
	Tue, 12 Aug 2025 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020887; cv=none; b=fY9vvsSc6BB+OGASFnF8K+jMRIOwkpEkRAJdpqRceqMisBwPRTlvKCppVWDXF/5g1LEEzpJDIqMni/ATc8v7Sgyq3lbDzkkGKEBbVhDp5nR48vLxV8Ub8p5lqHpeKQpFf8xJQcwOhlRFywaRMceu42fGKqhMiYnf0waCFlKPUDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020887; c=relaxed/simple;
	bh=OT7QXgIYVZJwKIw5NI7TOe/NRA5ne18HD/miGD27FaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIlEbe6AByV//iQasD9uzOWSbwlBMyt/YeR/2go54Mw8ptPEC6rJmHQPwAYYua31UqmKrn7Ygz6FeNr1HyY2Au1szIyRiLrfxzProxoPsk9odVX04a5ElhRIciqy510SIbgBTfUNiUMG+RobJ/KI/uvWGhIj3OHYFIFOVkq4r08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXHrGVXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXHrGVXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59093C4CEF0;
	Tue, 12 Aug 2025 17:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020886;
	bh=OT7QXgIYVZJwKIw5NI7TOe/NRA5ne18HD/miGD27FaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXHrGVXDvDowOC8B9eqW9T3cYWoEG7vyJJiR7WXZY6O3aTkWLB15ENQUCuTfK3ysX
	 9AqU4MTEBs7oN1dSO8uvg8RfQVbNj8WJprCo9I0trfpUDHg2eFmO4iYpec/ZAXoHSw
	 HetOU2AvnOdWlchheHWGEYVsbYdaT8LYE7JtYNX8=
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
Subject: [PATCH 6.1 182/253] bpf: Check flow_dissector ctx accesses are aligned
Date: Tue, 12 Aug 2025 19:29:30 +0200
Message-ID: <20250812172956.517375278@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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
index 4c806ce62739..cd0c28e94979 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9270,6 +9270,9 @@ static bool flow_dissector_is_valid_access(int off, int size,
 	if (off < 0 || off >= sizeof(struct __sk_buff))
 		return false;
 
+	if (off % size != 0)
+		return false;
+
 	if (type == BPF_WRITE)
 		return false;
 
-- 
2.39.5



