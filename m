Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645191F76A4;
	Tue,  3 Dec 2024 15:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238716; cv=none; b=hMUyDOUEmv6S9nJK0rKNZpRqoA58VarGtk91OenQpT/RQnj3Af4XVYPk6qS9x2Kv1MRMWEbRXLUlM4kcOUpbeT2yHsKrw9YFasvfEBp+jshqp2Y8Ke0gfty63qa8rJ+oh6SDD6JXKRDj0Zitmo0eD71Z/nfqvYFgSX+b8xdGRHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238716; c=relaxed/simple;
	bh=cG4mjA+nJ8XL+NjPshtIoT2nRFmtFjuANg/v1M7Wqhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPhjJ+sDGOiHUqWudRP85d6b1aOpXmJKk9AiQgzQIYUFSASjlzJ1POlRpvJRj3C5eiA7m5G1KMeviXpxyS//ua0JHsw7tFNYKWdVX86KFUL2nRfbrfGb2+7rmCMCnaXdFlfXwIA1f3GJJWilTz/FGeG/BLhVLeMBe87DQU2xiTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bf7c2wom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bf7c2wom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59C3C4CECF;
	Tue,  3 Dec 2024 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238716;
	bh=cG4mjA+nJ8XL+NjPshtIoT2nRFmtFjuANg/v1M7Wqhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf7c2womv47KOUahdl5QShnJVxB/xxJFchVPcKqfeD8lJNhRmq1gFtLy9CJj6SXk3
	 ZC2eEWvxDjpY6yJN7DVVfbL8at9VgYoQJgzBDEuxUgEf4uDaKOhcTvPooffVYy8X2a
	 2rm8s20z7iHbmL5gYWAqZB/wFcBzcLmpAkqfVZoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 342/817] bpf: Allow return values 0 and 1 for kprobe session
Date: Tue,  3 Dec 2024 15:38:34 +0100
Message-ID: <20241203144009.173384140@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 17c4b65a24938c6dd79496cce5df15f70d9c253c ]

The kprobe session program can return only 0 or 1,
instruct verifier to check for that.

Fixes: 535a3692ba72 ("bpf: Add support for kprobe session attach")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241108134544.480660-2-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b34a358c75e0f..61c3896087b2c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15798,6 +15798,15 @@ static int check_return_code(struct bpf_verifier_env *env, int regno, const char
 			return -ENOTSUPP;
 		}
 		break;
+	case BPF_PROG_TYPE_KPROBE:
+		switch (env->prog->expected_attach_type) {
+		case BPF_TRACE_KPROBE_SESSION:
+			range = retval_range(0, 1);
+			break;
+		default:
+			return 0;
+		}
+		break;
 	case BPF_PROG_TYPE_SK_LOOKUP:
 		range = retval_range(SK_DROP, SK_PASS);
 		break;
-- 
2.43.0



