Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80AE1E89C;
	Tue, 27 May 2025 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366198; cv=none; b=WF2P+v2xjKVUkn5aVygdV1ycvjgml3GgBB8nfX/bfh13DPeUIROcCcHMVLNMgD9ve7qyMY7e4sWWDLyTO6mWP3t9oavNR8Xrd+h50wff92lvdh9EI5JlLhFbdfqh+VcpwgrJENpfYrCGRlZBKw3LUWhLnlIwc8fW4s17SKDe3S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366198; c=relaxed/simple;
	bh=8GORCM8yAEKA1n1LuvccYacmhdoz79vSeCZ9gNx65GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0wWfer1DGxG0OIXrDdRoIELDkKA710Q7SMtL+q5xYz7fWKo3mwbnVh69WuXMgqvFWImFpc+5nIXkZ4Hw045bbaM4KWm82ZPZp9UOGWRAG+sd5yd8nsYHhh6ACUm9AqzUPGIw/pno2RC7dJcuDdXcR/AtVpbO773preXW96UW8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KviJIeTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KviJIeTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2868EC4CEEB;
	Tue, 27 May 2025 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366198;
	bh=8GORCM8yAEKA1n1LuvccYacmhdoz79vSeCZ9gNx65GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KviJIeTjFntgRn52uWBe47k/EclNyCrSbQzWXMOOW4Armn+zXXkt5Do9tqE8+xf90
	 dOhlnDpizbHfe5Q4nDhor24LhL1VIQ88nzdNkZxT4WGcpB0xolge8CK7fp0CRZpMWz
	 atZ5RIChQz0Gz647DmzZzvkJNS0METWVgsSnqF40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 619/626] bpf: abort verification if env->cur_state->loop_entry != NULL
Date: Tue, 27 May 2025 18:28:32 +0200
Message-ID: <20250527162510.148289103@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

commit f3c2d243a36ef23be07bc2bce7c6a5cb6e07d9e3 upstream.

In addition to warning abort verification with -EFAULT.
If env->cur_state->loop_entry != NULL something is irrecoverably
buggy.

Fixes: bbbc02b7445e ("bpf: copy_verifier_state() should copy 'loop_entry' field")
Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20250225003838.135319-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18721,8 +18721,10 @@ process_bpf_exit:
 						return err;
 					break;
 				} else {
-					if (WARN_ON_ONCE(env->cur_state->loop_entry))
-						env->cur_state->loop_entry = NULL;
+					if (WARN_ON_ONCE(env->cur_state->loop_entry)) {
+						verbose(env, "verifier bug: env->cur_state->loop_entry != NULL\n");
+						return -EFAULT;
+					}
 					do_print_state = true;
 					continue;
 				}


