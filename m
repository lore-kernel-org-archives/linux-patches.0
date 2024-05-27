Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6572617E90E;
	Mon, 27 May 2024 19:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836802; cv=none; b=ihcAWXmwmpSZ1iKfXG4EgDG2MGIf6+2gQ43X1+7lY4RAAVRS4HO1w3mT9kHnaIAol4tgp4UGjaJniG8UMoeEpofYwsd4ZWTyxcGWvSSO7AN8m2A9SoIf7JH7fT/2xY+Ks0InXJEatb7uDfRTeoESN1A08ZYKpAt4JXs4LMAx9mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836802; c=relaxed/simple;
	bh=CfNoznnSdwUXc6UckrD7tNn7Bgoc1cDsrzhaYEhkL78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dENc7I4Oc+qoFdQhhiGyC0Qk8Gikejjf3PCunXgUDGfIhVghdbjttWyRAgUMEFZtfzAP/nVWbHajE4pPBNjsMIVww9w4bFcmcbAwMS7swAuczAqLtkT9RQOwzOlUkVk+yv6Zh2Up4F92BPphaqwZQbJQN/XCU+twXlDvxq4WUAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITfFLdO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITfFLdO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE53C2BBFC;
	Mon, 27 May 2024 19:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836801;
	bh=CfNoznnSdwUXc6UckrD7tNn7Bgoc1cDsrzhaYEhkL78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITfFLdO1Lz1v6FMvN7cVe9o52LT36K836iCK9BJk6vQvdG0k9D/ei5OW9z9TlqQBY
	 PKIQmK+AH2qgrbkpmt/yQlEuHzwvs+Lrdi8JZLLD/gmQI1ebae+vilaEyoV/6y2kCm
	 /ZPzJ2Pk7V7qrmy4Y25/JntN8R9hfX3OIdh1LYu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+838346b979830606c854@syzkaller.appspotmail.com,
	Stanislav Fomichev <sdf@google.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 194/427] bpf: Add BPF_PROG_TYPE_CGROUP_SKB attach type enforcement in BPF_LINK_CREATE
Date: Mon, 27 May 2024 20:54:01 +0200
Message-ID: <20240527185620.365282198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 543576ec15b17c0c93301ac8297333c7b6e84ac7 ]

bpf_prog_attach uses attach_type_to_prog_type to enforce proper
attach type for BPF_PROG_TYPE_CGROUP_SKB. link_create uses
bpf_prog_get and relies on bpf_prog_attach_check_attach_type
to properly verify prog_type <> attach_type association.

Add missing attach_type enforcement for the link_create case.
Otherwise, it's currently possible to attach cgroup_skb prog
types to other cgroup hooks.

Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
Link: https://lore.kernel.org/bpf/0000000000004792a90615a1dde0@google.com/
Reported-by: syzbot+838346b979830606c854@syzkaller.appspotmail.com
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240426231621.2716876-2-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c287925471f68..cb61d8880dbe0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3985,6 +3985,11 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 			 * check permissions at attach time.
 			 */
 			return -EPERM;
+
+		ptype = attach_type_to_prog_type(attach_type);
+		if (prog->type != ptype)
+			return -EINVAL;
+
 		return prog->enforce_expected_attach_type &&
 			prog->expected_attach_type != attach_type ?
 			-EINVAL : 0;
-- 
2.43.0



