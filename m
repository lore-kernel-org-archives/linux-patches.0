Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AC53859E3;
	Tue, 10 Mar 2026 11:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140803; cv=none; b=dXqsWgC2i+EtXsHxPyx6b/Loj/im/M48Mz+Sgui+EqtJNA9Pbti3V1WYeT2I5A414/csN02kFx7aFugPN2JvoQuPqDQJVuqA9ro64O5jf4/55vMNv1So/U5AjodecfeDc/T2FDvSakPMKP4J0fwGVFYI8XDKuMGFND1EMzermp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140803; c=relaxed/simple;
	bh=2CYjOw6iKgznJ42auX7n2z9R0FGZee5FBEAGBx9yqNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBMr2rb9fYgNOrCw3MbdDJQIXAsJVZ4llx8fOGlk6ONXnBld+jnW/4dtx0sq6Q8q1P5TNjCvj5CplCKywggrPSoV+SJzvAPktoTAWYkW7lH/XROmem0J95CmmxudiNOiN1kjXjAb79eq1eohdLqlICCpZK3eMGOqH1kevHljais=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TG910/B1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TG910/B1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DA0C19423;
	Tue, 10 Mar 2026 11:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140803;
	bh=2CYjOw6iKgznJ42auX7n2z9R0FGZee5FBEAGBx9yqNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TG910/B1zklpRembSm6nKO+q1AlhZpdnFFaj4+0g63bsHrPYGwqWYo1wKHO7jrqfV
	 nsmnhucM8i+ieqb2mEjyqwwsbqQkOe1f8Fp5W7QBMRN1d6L0lO1vCBMLmCjXVUVXV4
	 fjamnd999ZBqHZOhBPQz7oxVQTh11UK+JyTjEp/GFuNRc23to8TwgmLr4it9McNK7F
	 uVquOfOA1tl7ZbNYsczlqTHJhdi4+OhdDq2fplCzeOoUTcpdySCZlGa9WQDFB2Au1k
	 LcfZ7MupqsGdBk/fB8t6CiP3QErKThUl0l0T0EPONBC3AachBoeMyDTjd0d39kCxzz
	 2UM+7MOC426CQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 041/311] accel/amdxdna: Validate command buffer payload count
Date: Tue, 10 Mar 2026 07:01:28 -0400
Message-ID: <9c7de057c54b63040df112139e6c62a95f172402.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 901ec3470994006bc8dd02399e16b675566c3416 ]

The count field in the command header is used to determine the valid
payload size. Verify that the valid payload does not exceed the remaining
buffer space.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260219211946.1920485-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index db3aa26fb55f0..e42eb12fc7c1b 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -104,7 +104,10 @@ void *amdxdna_cmd_get_payload(struct amdxdna_gem_obj *abo, u32 *size)
 
 	if (size) {
 		count = FIELD_GET(AMDXDNA_CMD_COUNT, cmd->header);
-		if (unlikely(count <= num_masks)) {
+		if (unlikely(count <= num_masks ||
+			     count * sizeof(u32) +
+			     offsetof(struct amdxdna_cmd, data[0]) >
+			     abo->mem.size)) {
 			*size = 0;
 			return NULL;
 		}
-- 
2.51.0

