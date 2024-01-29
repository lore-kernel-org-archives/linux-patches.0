Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B6F157E66;
	Mon, 29 Jan 2024 17:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548520; cv=none; b=Cd8pKEF16MvkK+oE3tc2oo/XXtu90nCP2sQPQENY6Y2aI1vf35ByrY0YWr7IzJAcNTsxYe4570LamrfkXDfw2TPRdQdkgwg2/uy+Ov+utOmKaD4oQhGhuvUgZM9ys1l78/bJnNS4/AgGWJegbrw8yssOmpc7Mljgj1PFhLw6ezU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548520; c=relaxed/simple;
	bh=gRdI4p6/IU789oke/qe/v3q3kVAgI8OU7xZkmD45r34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntD1y4qg+rB8BXfqt/4bOVffcDaAmbe+W8kUTYfP6qt7GoZjBkGTKkJ0D9ETTPLCD3nv07v8rYWQWVfZTSOyytLlzVG/aaahz8QY2bAhvHoZPq8Wwbf/FjMpXoeOTejaKN9W9LUTAWu5ucw7L7C2OGr4PgSV2bvGkUZCwvE8zgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRrSETCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRrSETCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988E4C433C7;
	Mon, 29 Jan 2024 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548519;
	bh=gRdI4p6/IU789oke/qe/v3q3kVAgI8OU7xZkmD45r34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRrSETClXzPE3MXzzOnUS3aXMWJtSRxRoJHf8s3aSbROUgg5UFZ58SZsLAwxK4xvR
	 /lQIgn5iiasLaWElMRLCkxBsCIwCVXHaHNKu8us1Yt4epto4ZdD0ig7zTon59MdrqB
	 j/EUu8D78tWH0m2Yh9QDFHuyhaKnfgRTn7DY/xeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 152/331] bpf: print full verifier states on infinite loop detection
Date: Mon, 29 Jan 2024 09:03:36 -0800
Message-ID: <20240129170019.372145196@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

commit b4d8239534fddc036abe4a0fdbf474d9894d4641 upstream.

Additional logging in is_state_visited(): if infinite loop is detected
print full verifier state for both current and equivalent states.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231024000917.12153-8-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16540,6 +16540,10 @@ static int is_state_visited(struct bpf_v
 			    !iter_active_depths_differ(&sl->state, cur)) {
 				verbose_linfo(env, insn_idx, "; ");
 				verbose(env, "infinite loop detected at insn %d\n", insn_idx);
+				verbose(env, "cur state:");
+				print_verifier_state(env, cur->frame[cur->curframe], true);
+				verbose(env, "old state:");
+				print_verifier_state(env, sl->state.frame[cur->curframe], true);
 				return -EINVAL;
 			}
 			/* if the verifier is processing a loop, avoid adding new state


