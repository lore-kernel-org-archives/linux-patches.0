Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694721E98EF;
	Sun,  7 Jun 2026 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828983; cv=none; b=QBxWAYa2QpOqhVGF5iL5ZwR8aogwT9x0E8jxq+oCQ9B6bV9lb/keLczSdWyEYZXtaxNF9zv9sDgv9iaq0ZGM3l+smdPIqXtUoTGE1b4VY81gTl/Hn47/2tSXcs+SHQbv7OC7RnrEk6CP8vOW0cw7hqLvzIUrp9cUuNJ95CYYFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828983; c=relaxed/simple;
	bh=suTgiXbI5TJZirGIvS6IyYbc0TAYdNh0CxbV+WMSvZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQ5VdWJLu45QBg8CRz30HUdoYDSugGmfSGthxh7B5R5JFkbJJlLV8XqTomvfIm7ro3i87MCGeh4UoHwDdhve0BDQwljph60PrZ6tO4Kd13YtaLz1vKajfFcex1nAMfaZ/KinDb/D9UAnFZ1SdtdoAeOTpzQCvlWdJq+CUuAU9Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scp2HD45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scp2HD45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB2E1F00893;
	Sun,  7 Jun 2026 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828982;
	bh=vs/gxlNSn5CsYj4zxYf3Z5xIp+Echpv/oVnY9h/AqAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=scp2HD451F8YjXXuWh57tQRIF3Hp9If9VgVKCJLfQkQYl7nSw48rbqkYKi3mWHTD2
	 2bekULh0yUbBxOo33o20MnLUO4BMesB2D9NOg86aE02siyDWgt/C9oP7S2qyfpo7/G
	 XKmDXURRdmjg+hp7i9xZtSul2m2asyj642XT1+qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyq21@lenovo.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 184/307] bpf: sockmap: fix tail fragment offset in bpf_msg_push_data
Date: Sun,  7 Jun 2026 11:59:41 +0200
Message-ID: <20260607095734.474415851@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyq21@lenovo.com>

commit f72eed9b84fb771019a955908132410a9ba9ea3f upstream.

When bpf_msg_push_data() inserts data in the middle of a scatterlist
entry, it splits the original entry into a left fragment and a right
fragment.

The right fragment offset is page-local, but the code advances it with
`start`, which is the message-global insertion point. For inserts into a
non-first SG entry, this over-advances the offset and leaves the split
layout inconsistent.

Advance the right fragment offset by the fragment-local delta,
`start - offset`, which matches the length removed from the front of the
original entry.

Fixes: 6fff607e2f14 ("bpf: sk_msg program helper bpf_msg_push_data")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuqi Xu <xuyq21@lenovo.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/8b129d10566aa3eb43f61a8f9757bcf51707d324.1779636774.git.xuyq21@lenovo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2867,7 +2867,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_
 
 		psge->length = start - offset;
 		rsge.length -= psge->length;
-		rsge.offset += start;
+		rsge.offset += start - offset;
 
 		sk_msg_iter_var_next(i);
 		sg_unmark_end(psge);


