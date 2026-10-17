Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8D43A380C;
	Sat, 17 Oct 2026 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260810; cv=none; b=jAMncyiVLihqFw/JhV4q2JhXXswl9ygUsJkXfksZL8if/fXw2RBt2KeZItGFjDU3kGMVqguN6U1+S6sdEtRTvPVVpzVTViMxRiUMUATOf2cae2YI4AdepnRdIjW7hsbG33jun/BWhaszB+FYwJT5/GzLfS8ngY4lWSvdXBZ6TLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260810; c=relaxed/simple;
	bh=mZO0hbgXIv9l614UhUtsTNX9cRLh5mPH0Gsg3S/8xVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ysvp8ks8H1emgTu5cTk2H5YvUFcPhXYoDCEpMb8WdRDfXbOrnLnKksd+LiAPG8Taxru25EDen/j/N1T/qBY0UAi8x08CwvY18G8h+CH9bPPuADBFc3iDlGAApuNWG4GwFCicYSn7Cx1R18RKKkH4CQT/IavTaqsFeqdeomPaiv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3HuIGlG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3HuIGlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597561F000C4;
	Sat, 17 Oct 2026 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260808;
	bh=c13LeaF+6tMajmmZHT/0AP1kRknPCjJdt7/AOzmjsWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3HuIGlGjO2wrNJvmXpaii5uwsrTz9VsEdgVZR2RMvaseJ/PhH+3ktgLUbGcQp3J8
	 J0ymZxP3RYCFupQNFS74FpmSTOjsQu0QmGo9HzPW3yfzdaip4ZqB+Nvq/QGHkd5BZW
	 Sngynd25sunQe+N7clFbgHDnWUiUDhNWJzWwUHYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1666/1674] bpf: abort verification if env->cur_state->loop_entry != NULL
Date: Sat, 17 Oct 2026 18:05:38 +0200
Message-ID: <20261017160513.831405256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit f3c2d243a36ef23be07bc2bce7c6a5cb6e07d9e3 ]

In addition to warning abort verification with -EFAULT.
If env->cur_state->loop_entry != NULL something is irrecoverably
buggy.

Fixes: bbbc02b7445e ("bpf: copy_verifier_state() should copy 'loop_entry' field")
Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20250225003838.135319-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17676,8 +17676,10 @@ process_bpf_exit:
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


