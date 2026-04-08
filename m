Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4922727F3;
	Wed,  8 Apr 2026 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674175; cv=none; b=R/h6AFAx8can1K/Bm0GplV/90dQVaopxUchBbOgVAt6R1hq5MO8sLF5SelZJcvLpQpgvDYzO7abSx/+6kLX7pRBKBUdh+uz6n5ANITgotN8ip9AdOttbBzq4mmvMaVaAZ0BaUIeiqGvMK/ztN/ncLREFeJV0Uss5+CQHCrBccaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674175; c=relaxed/simple;
	bh=V5jBlWKkKkLQJh/flHAZ7VDTumCe6GrsVqPwKYm3Fd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7esBnI8ol0b2zfnHhFbemHaw0pBBJnDjucM8jnnqF422eoF8kwPgmxAWS1ufxuzeRcfqCorM0q/bQxrIwtN7ibQdVNgbKiuwExL+Tvjj7RaSJZVKJjfTOgbg+hEEWB4zQvYEVAVKJnh/bCSnESfYeedsCUr7j4Wuh9We+z6Obw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZ/4fpTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZ/4fpTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44B4C19421;
	Wed,  8 Apr 2026 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674175;
	bh=V5jBlWKkKkLQJh/flHAZ7VDTumCe6GrsVqPwKYm3Fd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZ/4fpTmrOAEnGWf60T0DfAKoCIM2vIk7qY1WavXQhRZTeDXeBVkTtCwvYox5De9k
	 8N0+k99EVZJ8UDXamtvTzWNxo7VagmrFzit1V4psoT65ejt2GrF9RQ6E1TIpY+MlbW
	 gO0CQ4jncWmSxK/40KYd9Od+adkQx9eXgjGyj0n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 237/242] bpf: Improve bounds when s64 crosses sign boundary
Date: Wed,  8 Apr 2026 20:04:37 +0200
Message-ID: <20260408175935.977382257@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 00bf8d0c6c9be0c481fc45a3f7d87c7f8812f229 ]

__reg64_deduce_bounds currently improves the s64 range using the u64
range and vice versa, but only if it doesn't cross the sign boundary.

This patch improves __reg64_deduce_bounds to cover the case where the
s64 range crosses the sign boundary but overlaps with the u64 range on
only one end. In that case, we can improve both ranges. Consider the
following example, with the s64 range crossing the sign boundary:

    0                                                   U64_MAX
    |  [xxxxxxxxxxxxxx u64 range xxxxxxxxxxxxxx]              |
    |----------------------------|----------------------------|
    |xxxxx s64 range xxxxxxxxx]                       [xxxxxxx|
    0                     S64_MAX S64_MIN                    -1

The u64 range overlaps only with positive portion of the s64 range. We
can thus derive the following new s64 and u64 ranges.

    0                                                   U64_MAX
    |  [xxxxxx u64 range xxxxx]                               |
    |----------------------------|----------------------------|
    |  [xxxxxx s64 range xxxxx]                               |
    0                     S64_MAX S64_MIN                    -1

The same logic can probably apply to the s32/u32 ranges, but this patch
doesn't implement that change.

In addition to the selftests, the __reg64_deduce_bounds change was
also tested with Agni, the formal verification tool for the range
analysis [1].

Link: https://github.com/bpfverif/agni [1]
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/933bd9ce1f36ded5559f92fdc09e5dbc823fa245.1753695655.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2129,6 +2129,58 @@ static void __reg64_deduce_bounds(struct
 	if ((u64)reg->smin_value <= (u64)reg->smax_value) {
 		reg->umin_value = max_t(u64, reg->smin_value, reg->umin_value);
 		reg->umax_value = min_t(u64, reg->smax_value, reg->umax_value);
+	} else {
+		/* If the s64 range crosses the sign boundary, then it's split
+		 * between the beginning and end of the U64 domain. In that
+		 * case, we can derive new bounds if the u64 range overlaps
+		 * with only one end of the s64 range.
+		 *
+		 * In the following example, the u64 range overlaps only with
+		 * positive portion of the s64 range.
+		 *
+		 * 0                                                   U64_MAX
+		 * |  [xxxxxxxxxxxxxx u64 range xxxxxxxxxxxxxx]              |
+		 * |----------------------------|----------------------------|
+		 * |xxxxx s64 range xxxxxxxxx]                       [xxxxxxx|
+		 * 0                     S64_MAX S64_MIN                    -1
+		 *
+		 * We can thus derive the following new s64 and u64 ranges.
+		 *
+		 * 0                                                   U64_MAX
+		 * |  [xxxxxx u64 range xxxxx]                               |
+		 * |----------------------------|----------------------------|
+		 * |  [xxxxxx s64 range xxxxx]                               |
+		 * 0                     S64_MAX S64_MIN                    -1
+		 *
+		 * If they overlap in two places, we can't derive anything
+		 * because reg_state can't represent two ranges per numeric
+		 * domain.
+		 *
+		 * 0                                                   U64_MAX
+		 * |  [xxxxxxxxxxxxxxxxx u64 range xxxxxxxxxxxxxxxxx]        |
+		 * |----------------------------|----------------------------|
+		 * |xxxxx s64 range xxxxxxxxx]                    [xxxxxxxxxx|
+		 * 0                     S64_MAX S64_MIN                    -1
+		 *
+		 * The first condition below corresponds to the first diagram
+		 * above.
+		 */
+		if (reg->umax_value < (u64)reg->smin_value) {
+			reg->smin_value = (s64)reg->umin_value;
+			reg->umax_value = min_t(u64, reg->umax_value, reg->smax_value);
+		} else if ((u64)reg->smax_value < reg->umin_value) {
+			/* This second condition considers the case where the u64 range
+			 * overlaps with the negative portion of the s64 range:
+			 *
+			 * 0                                                   U64_MAX
+			 * |              [xxxxxxxxxxxxxx u64 range xxxxxxxxxxxxxx]  |
+			 * |----------------------------|----------------------------|
+			 * |xxxxxxxxx]                       [xxxxxxxxxxxx s64 range |
+			 * 0                     S64_MAX S64_MIN                    -1
+			 */
+			reg->smax_value = (s64)reg->umax_value;
+			reg->umin_value = max_t(u64, reg->umin_value, reg->smin_value);
+		}
 	}
 }
 


