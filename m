Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FAB1714A8;
	Thu, 15 Aug 2024 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729374; cv=none; b=ticgSrsjPFFfPnfNxr8jCOCBK5Q4fX+k3e8bDVlPsdQssRqqj6yNdZ0J3YC1RTlQyI10/L7C4C40+qokpk0OueFu/acKKAnQ2KOjgp1sV16o+FcDjj8s1MP4ySBmEv077Bd7oobMSqKEEoTaShfFtCSjqxuhA8v9ZCAGzJ6Uqzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729374; c=relaxed/simple;
	bh=QxNWEq/4lHir5Ifb1i7Zpcuh7COn7FUEXpUX8OCPAnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZCioedg3m63A92/0liy3Yc/sq1blaFZiPkazmpTlG0WoO1tzepfMeI/M7ECIjuvI/qs7yOdC4xDgUN6C+Ufxdk4KLtkQViDKmPVU4OKpp/fgusG3sAOf1Fhvmq6sMkyvBaL22wbfzrqMGgLWLuPuvtTUDO+97iJ1vA0MwxnDG9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAiMLAb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAiMLAb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22B9C32786;
	Thu, 15 Aug 2024 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729374;
	bh=QxNWEq/4lHir5Ifb1i7Zpcuh7COn7FUEXpUX8OCPAnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAiMLAb/15IXS9/BL4s8gQ6NIOwMUFRzTShRHr7jemXHBosdBLCNCYCsEI4IUQWXe
	 c5oT67W7v/WN/Y+p5eABnuO9N9mHHsvTy/azhaUXRd2wRebhjMPZ2esJBGv5D2njix
	 mkpUMzkGdtDSwTlkT5SnytxFxzGxcZV+MVl7I+gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/484] bpf: Eliminate remaining "make W=1" warnings in kernel/bpf/btf.o
Date: Thu, 15 Aug 2024 15:18:56 +0200
Message-ID: <20240815131944.298217784@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0c9d93e2c18f0..d3eb75bfd9718 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -349,7 +349,7 @@ const char *btf_type_str(const struct btf_type *t)
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



