Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1971863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBBCC433EF;
	Wed, 28 Dec 2022 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241338;
	bh=mVKQcYqU4FyxFEy9N/VKUlGh7w6PglcIXEAJtqnsxxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZ3uyGxwqocsIAYH+MiSCzfEq/t+QAnsHqVR2X5FCAiUcY7wWgpjZVLAek1g2+gTz
	 vsHR1oAsQxFmxWSQzySoSIziyzV0H31vYLNO2/TO6SD90/nst4wDe8aMcszo2AyCfg
	 rqQmT55QJ1vNXKmrkOaRokskRYX1jUPjmBJGfrbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yhs@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0268/1073] bpf: Clobber stack slot when writing over spilled PTR_TO_BTF_ID
Date: Wed, 28 Dec 2022 15:30:56 +0100
Message-Id: <20221228144335.298647839@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 261f4664caffdeb9dff4e83ee3c0334b1c3a552f ]

When support was added for spilled PTR_TO_BTF_ID to be accessed by
helper memory access, the stack slot was not overwritten to STACK_MISC
(and that too is only safe when env->allow_ptr_leaks is true).

This means that helpers who take ARG_PTR_TO_MEM and write to it may
essentially overwrite the value while the verifier continues to track
the slot for spilled register.

This can cause issues when PTR_TO_BTF_ID is spilled to stack, and then
overwritten by helper write access, which can then be passed to BPF
helpers or kfuncs.

Handle this by falling back to the case introduced in a later commit,
which will also handle PTR_TO_BTF_ID along with other pointer types,
i.e. cd17d38f8b28 ("bpf: Permits pointers on stack for helper calls").

Finally, include a comment on why REG_LIVE_WRITTEN is not being set when
clobber is set to true. In short, the reason is that while when clobber
is unset, we know that we won't be writing, when it is true, we *may*
write to any of the stack slots in that range. It may be a partial or
complete write, to just one or many stack slots.

We cannot be sure, hence to be conservative, we leave things as is and
never set REG_LIVE_WRITTEN for any stack slot. However, clobber still
needs to reset them to STACK_MISC assuming writes happened. However read
marks still need to be propagated upwards from liveness point of view,
as parent stack slot's contents may still continue to matter to child
states.

Cc: Yonghong Song <yhs@meta.com>
Fixes: 1d68f22b3d53 ("bpf: Handle spilled PTR_TO_BTF_ID properly when checking stack_boundary")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20221103191013.1236066-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b781075dd510..65c627571e33 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5142,10 +5142,6 @@ static int check_stack_range_initialized(
 			goto mark;
 		}
 
-		if (is_spilled_reg(&state->stack[spi]) &&
-		    base_type(state->stack[spi].spilled_ptr.type) == PTR_TO_BTF_ID)
-			goto mark;
-
 		if (is_spilled_reg(&state->stack[spi]) &&
 		    (state->stack[spi].spilled_ptr.type == SCALAR_VALUE ||
 		     env->allow_ptr_leaks)) {
@@ -5176,6 +5172,11 @@ static int check_stack_range_initialized(
 		mark_reg_read(env, &state->stack[spi].spilled_ptr,
 			      state->stack[spi].spilled_ptr.parent,
 			      REG_LIVE_READ64);
+		/* We do not set REG_LIVE_WRITTEN for stack slot, as we can not
+		 * be sure that whether stack slot is written to or not. Hence,
+		 * we must still conservatively propagate reads upwards even if
+		 * helper may write to the entire memory range.
+		 */
 	}
 	return update_stack_depth(env, state, min_off);
 }
-- 
2.35.1



