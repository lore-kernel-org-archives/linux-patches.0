Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A900F3A8C9
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HHMuFxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0AAC433C9;
	Wed, 15 Nov 2023 19:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076913;
	bh=yQ6RDszFdVtbqTh8YZ+L72Yhp0oeBloY8G+HGqmFjmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HHMuFxXIpNJsaUl6wMTj7nZoXNXWkJaEE4aZoHGk63Nw1tpp8iLp53pLqnnwDK7I
	 PCzi0vbdCr1A1aXCx/e5H8Bsu3UQBf9LS/neK6wH5FKHMwGutAgFBThbpnSW1sufXW
	 tbU1S2/9yPLM3IVuoqHM2iJx3/FONANEyYSN2la0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/603] bpf: Fix kfunc callback register type handling
Date: Wed, 15 Nov 2023 14:10:10 -0500
Message-ID: <20231115191617.655617653@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 06d686f771ddc27a8554cd8f5b22e071040dc90e ]

The kfunc code to handle KF_ARG_PTR_TO_CALLBACK does not check the reg
type before using reg->subprogno. This can accidently permit invalid
pointers from being passed into callback helpers (e.g. silently from
different paths). Likewise, reg->subprogno from the per-register type
union may not be meaningful either. We need to reject any other type
except PTR_TO_FUNC.

Acked-by: Dave Marchevsky <davemarchevsky@fb.com>
Fixes: 5d92ddc3de1b ("bpf: Add callback validation to kfunc verifier logic")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20230912233214.1518551-14-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9f180ae74e492..82c9e5c470319 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11202,6 +11202,10 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 			break;
 		}
 		case KF_ARG_PTR_TO_CALLBACK:
+			if (reg->type != PTR_TO_FUNC) {
+				verbose(env, "arg%d expected pointer to func\n", i);
+				return -EINVAL;
+			}
 			meta->subprogno = reg->subprogno;
 			break;
 		case KF_ARG_PTR_TO_REFCOUNTED_KPTR:
-- 
2.42.0



