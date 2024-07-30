Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120A518C93F;
	Tue, 30 Jul 2024 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355707; cv=none; b=bLQ1VDl3GV1JoERHwH2PjVqZ9nfHULj+nUzfefuk29iUVXCZqPAlwPIOxx6RCF+nqQ3AUmw2TsLBlZa3CQpDy93JenZn14qwuKpZPk1s9l25G1DkqNIOHfEGAMMj5G6/yOT6E8hqSYSf4rNGSMKrTkdKJG68ZMwFTAZfvCGLwd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355707; c=relaxed/simple;
	bh=IF4kgqIgdqJVX4xih+GTUJ2tki88K1qzdQeK9x8u8Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MZO8QmclZ+rPcgG+b6HUHGnqPacDq2Vu7Kmmjxm5vVOlNo3yQch1OpGqoO/ze9+50OHwjNWr6mL25qvFWOuug0LqbKYYxLmvPvANcLLKpva47W62MbxOGuiOYxSBDlAlruscdtmYI3fp+hvoRIifDTLnua1Guo47wq6qBVuNzb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcy1MMVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcy1MMVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E00DC32782;
	Tue, 30 Jul 2024 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355706;
	bh=IF4kgqIgdqJVX4xih+GTUJ2tki88K1qzdQeK9x8u8Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcy1MMVNIwnqlGaadKWF6I0cOvQjAiY+5BQnXlMyp8HAp5YEGXqsJQWPJxpys1SDR
	 NfZuKkx4U2VGGNQZH6mFHokBB7XFYDx7YB81JLbSaj9CgYukbNEn1FePj4ZngCh85Z
	 /rQI0cYXGhe+L+MxQQnI15eKUXjek3EoTzjVILKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/440] bpf: Eliminate remaining "make W=1" warnings in kernel/bpf/btf.o
Date: Tue, 30 Jul 2024 17:45:56 +0200
Message-ID: <20240730151620.692724054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d6524caf8ea9..bb88fd2266a86 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -378,7 +378,7 @@ const char *btf_type_str(const struct btf_type *t)
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



