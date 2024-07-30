Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10043183CCD;
	Tue, 30 Jul 2024 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356619; cv=none; b=YfQ/iQUBmCsSyumeTHX7Q1+d8hS0NA/aBzswRLrsfpcZexBfYdemRJozSd2WJF6DMklvXeyfW/cG7X81XKH5O6BnfGU9cXRF+/TQUnhk1d9hgqn1wgzUYv9DzUkyGZfG0I560qT3wddCqztrnHCcNN0GjmgW0jpwQhNGukwcDZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356619; c=relaxed/simple;
	bh=aqgXFIpn2ddr3PvYUg0wJvw3aykahUKT3Lvwxu2jX4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U0yH6pSM3xTxUTqGxTtKgSXwIqyyBb0SBklNukE/4jVhVpYdkheURUj6iHOLkJ4wpW0+2SbjPk/2199MEnEZRJ48LJGRuAuRgG3ukxy3LN85HkCwNeQ5Ri9MEDhKLX5g/i4zofwW9ij+LM+pv082NIk4axmW0rsnPx7T1DG6m0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEFvw3B5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEFvw3B5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2772BC4AF10;
	Tue, 30 Jul 2024 16:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356618;
	bh=aqgXFIpn2ddr3PvYUg0wJvw3aykahUKT3Lvwxu2jX4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEFvw3B5+teSJax5OqP26HFUsOLApmHh5KmaJgbEgP+ph5iM2EHfkt8p3uwDN6+sA
	 dzK861nPVDaf4gbFvr+jiCA9a82xozbWFjjE7G6T0kGE3bAM9WZHQTMSoDO4vItx9W
	 Bhv2cgx1UE4OzGDxloDUY2RbfR83DXvUwQ25pIhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/568] bpf: Eliminate remaining "make W=1" warnings in kernel/bpf/btf.o
Date: Tue, 30 Jul 2024 17:44:34 +0200
Message-ID: <20240730151646.414206237@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 2454075f8e2915cebbe52a1195631bc7efe2b7e1 ]

As reported by Mirsad [1] we still see format warnings in kernel/bpf/btf.o
at W=1 warning level:

  CC      kernel/bpf/btf.o
./kernel/bpf/btf.c: In function ‘btf_type_seq_show_flags’:
./kernel/bpf/btf.c:7553:21: warning: assignment left-hand side might be a candidate for a format attribute [-Wsuggest-attribute=format]
 7553 |         sseq.showfn = btf_seq_show;
      |                     ^
./kernel/bpf/btf.c: In function ‘btf_type_snprintf_show’:
./kernel/bpf/btf.c:7604:31: warning: assignment left-hand side might be a candidate for a format attribute [-Wsuggest-attribute=format]
 7604 |         ssnprintf.show.showfn = btf_snprintf_show;
      |                               ^

Combined with CONFIG_WERROR=y these can halt the build.

The fix (annotating the structure field with __printf())
suggested by Mirsad resolves these. Apologies I missed this last time.
No other W=1 warnings were observed in kernel/bpf after this fix.

[1] https://lore.kernel.org/bpf/92c9d047-f058-400c-9c7d-81d4dc1ef71b@gmail.com/

Fixes: b3470da314fd ("bpf: annotate BTF show functions with __printf")
Reported-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Suggested-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240712092859.1390960-1-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 896ac05bf1bd1..fbf9721ba21b6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -405,7 +405,7 @@ const char *btf_type_str(const struct btf_type *t)
 struct btf_show {
 	u64 flags;
 	void *target;	/* target of show operation (seq file, buffer) */
-	void (*showfn)(struct btf_show *show, const char *fmt, va_list args);
+	__printf(2, 0) void (*showfn)(struct btf_show *show, const char *fmt, va_list args);
 	const struct btf *btf;
 	/* below are used during iteration */
 	struct {
-- 
2.43.0



