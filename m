Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C187E3A1CEB;
	Tue, 16 Dec 2025 12:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888230; cv=none; b=UMRpIe+6B/M7m4uSMUQHrszFN06Buv/wAVFGr74MUJMIAi6DX1b6jFh2koyiIgG6PSKNgQgZzQI0ET1iHEGNms6XRmmrW3r0gOqj2mcDA94bBO8KA5lGu1/In/rP3PxXp3mn+PebFJoS1K5PNLhNHwtV2QJGUdyuow94i+6ACKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888230; c=relaxed/simple;
	bh=z+FNo4uyXUhapNLpJ9mgHn0Gfvs2plE3jZSmcqdsGqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEuELCpfcdH4jNdkg33VwS7nGXKnO+s/1a0UNeaprz2rY5cK1wsQevbPcZ+iYiYRGZEMYRaBzLGPPNDfk46bnHHmouRIssSBQnBcDcqe/IodzqBb7QqUiVX1zX8m3uOlDyqxsRQEIsTOZJta/Vu6Ca6NW9YOu3LSuNMK6W/6aPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/y372ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/y372ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30074C4CEF1;
	Tue, 16 Dec 2025 12:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888230;
	bh=z+FNo4uyXUhapNLpJ9mgHn0Gfvs2plE3jZSmcqdsGqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/y372ca9fP4pHjDrv0rUKpzUwYp0pb8rQP2nEDer7lbD8CCCP57mOJs67A73LFaI
	 1x7FMDX+OCMpCBy6p7FBI8W7jR/q1/aVWSINWs+fRYUVjuxQNo9AjaU7/luWPA7iaZ
	 cZpl0d+AxD1o9gF6HYTkBx8CAvAJypvJZGBXcRSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cf08c551fecea9fd1320@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 454/614] bpf: Fix exclusive map memory leak
Date: Tue, 16 Dec 2025 12:13:41 +0100
Message-ID: <20251216111417.817672028@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 688b745401ab16e2e1a3b504863f0a45fd345638 ]

When excl_prog_hash is 0 and excl_prog_hash_size is non-zero, the map also
needs to be freed. Otherwise, the map memory will not be reclaimed, just
like the memory leak problem reported by syzbot [1].

syzbot reported:
BUG: memory leak
  backtrace (crc 7b9fb9b4):
    map_create+0x322/0x11e0 kernel/bpf/syscall.c:1512
    __sys_bpf+0x3556/0x3610 kernel/bpf/syscall.c:6131

Fixes: baefdbdf6812 ("bpf: Implement exclusive map creation")
Reported-by: syzbot+cf08c551fecea9fd1320@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cf08c551fecea9fd1320
Tested-by: syzbot+cf08c551fecea9fd1320@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/tencent_3F226F882CE56DCC94ACE90EED1ECCFC780A@qq.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 15f9afdbfc275..df219e7259099 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1585,7 +1585,8 @@ static int map_create(union bpf_attr *attr, bpfptr_t uattr)
 			goto free_map;
 		}
 	} else if (attr->excl_prog_hash_size) {
-		return -EINVAL;
+		err = -EINVAL;
+		goto free_map;
 	}
 
 	err = security_bpf_map_create(map, attr, token, uattr.is_kernel);
-- 
2.51.0



