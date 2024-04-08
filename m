Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CA381726;
	Mon,  8 Apr 2024 13:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582057; cv=none; b=s0UrQSfCXVSLhzpozEhI0H8V/QfkrQt0TBzv5+lErbWE0tGUeuIeAZmlWjgnNb9el8tX7yrnfBG6zY29KDjhKHk6gfmlqBCwb/Md1GWZcnYAgr7ehXkFwYtOmvByrRne9rKHeoEuFBbPJQkYsHh1huxYJ2MQdjdYtgjEZ90uIS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582057; c=relaxed/simple;
	bh=F+N9VqxhkRWC8R7rt1KJ48w8s/e8V7gpSR1r73Gib3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWYoUe/6Tb/1UsyDXHlaehWrjv046IcqLmKJT8nODjU9A0KQuRLDPdq9p+H/FYaptENB94IVq0wqAvZ3Krpv/lrLEf2tqDG9zXIxASl3ZdZPOOLE1lkHy1J/euOImUTUKbnKyaG+fGlWJUDpSx3A+bWGNPQ9Gr+SxudZoB4na6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0V6HXsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0V6HXsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8EFC433C7;
	Mon,  8 Apr 2024 13:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582057;
	bh=F+N9VqxhkRWC8R7rt1KJ48w8s/e8V7gpSR1r73Gib3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0V6HXswyovdgcwAvRtojC2Lmul7pH8GQdtLWG7TGs1UPdEr+uvtskLVDW/bfX086
	 yYpGi6Aywj1I9x3VDyXqvm26w8YPOWX9Q2NQEaAt9XDa6Q5uA0fCuGI+lekl5NRvyU
	 ynrvXuFNrgaFZKOj0ZhAAvTp/T3Evg234eGb78To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+33f4297b5f927648741a@syzkaller.appspotmail.com,
	syzbot+aafd0513053a1cbf52ef@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrei Matei <andreimatei1@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 043/273] bpf: Protect against int overflow for stack access size
Date: Mon,  8 Apr 2024 14:55:18 +0200
Message-ID: <20240408125310.626999629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Matei <andreimatei1@gmail.com>

[ Upstream commit ecc6a2101840177e57c925c102d2d29f260d37c8 ]

This patch re-introduces protection against the size of access to stack
memory being negative; the access size can appear negative as a result
of overflowing its signed int representation. This should not actually
happen, as there are other protections along the way, but we should
protect against it anyway. One code path was missing such protections
(fixed in the previous patch in the series), causing out-of-bounds array
accesses in check_stack_range_initialized(). This patch causes the
verification of a program with such a non-sensical access size to fail.

This check used to exist in a more indirect way, but was inadvertendly
removed in a833a17aeac7.

Fixes: a833a17aeac7 ("bpf: Fix verification of indirect var-off stack access")
Reported-by: syzbot+33f4297b5f927648741a@syzkaller.appspotmail.com
Reported-by: syzbot+aafd0513053a1cbf52ef@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/CAADnVQLORV5PT0iTAhRER+iLBTkByCYNBYyvBSgjN1T31K+gOw@mail.gmail.com/
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Link: https://lore.kernel.org/r/20240327024245.318299-3-andreimatei1@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ddea9567f7559..19e575e6b7fe0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6618,6 +6618,11 @@ static int check_stack_access_within_bounds(
 	err = check_stack_slot_within_bounds(env, min_off, state, type);
 	if (!err && max_off > 0)
 		err = -EINVAL; /* out of stack access into non-negative offsets */
+	if (!err && access_size < 0)
+		/* access_size should not be negative (or overflow an int); others checks
+		 * along the way should have prevented such an access.
+		 */
+		err = -EFAULT; /* invalid negative access size; integer overflow? */
 
 	if (err) {
 		if (tnum_is_const(reg->var_off)) {
-- 
2.43.0



