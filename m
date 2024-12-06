Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4389010E0;
	Fri,  6 Dec 2024 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497106; cv=none; b=f5U1tm5s96NamqCszk2xiSjKvBlk/zkHdwqJ3YBo8FLbyutiBXXr5EYH6kREUJtsYmvCnddgMENb6L5g7dE8cpzIhBfi3uS263HKLuD5sIRrbdq1RQSZuuA9qqC2V76vPa8hYyuxBraxWOh/98+tr7JhTt7ALkN3fior/8mnQ5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497106; c=relaxed/simple;
	bh=v/PYJ0L9HNY7Op5OTbcB8fIg82i0wu/EnmyZ6tZlYvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eulxz2qrcxxqAGo4VykA45JBSzO5cVJYVeymaDslUFf0bfA1zm//dcUA6z2HjhBRSjJxkpUVy3nXOTb+Gg21Ee4Xt0B5KmAO1f9D+eT5OMPhmxOKlZEadialPznSxERFU+C64bhPbX/lYdFahuwJi7dOTOJcwxt8M7QXSIRQ6L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOm/GnrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOm/GnrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FABC4CED1;
	Fri,  6 Dec 2024 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497106;
	bh=v/PYJ0L9HNY7Op5OTbcB8fIg82i0wu/EnmyZ6tZlYvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOm/GnrRjvVOuVBZSVU1KPTocarNl6ClkTeJyd+sbMDSzOXDDMAJDKodkJkDD7VE4
	 MNxwF3naS90yTe1mDYgrGmDrvNg9ZsO1pKzbxEM0b8LQDYWYGNl9f4aJOw5JIqaz0v
	 k+nY/1nqwOaRUwPnaWwXQArbmAxJ4cJyIfIe3V6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/676] libbpf: never interpret subprogs in .text as entry programs
Date: Fri,  6 Dec 2024 15:30:15 +0100
Message-ID: <20241206143701.001270405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit db089c9158c1d535a36dfc010e5db37fccea2561 ]

Libbpf pre-1.0 had a legacy logic of allowing singular non-annotated
(i.e., not having explicit SEC() annotation) function to be treated as
sole entry BPF program (unless there were other explicit entry
programs).

This behavior was dropped during libbpf 1.0 transition period (unless
LIBBPF_STRICT_SEC_NAME flag was unset in libbpf_mode). When 1.0 was
released and all the legacy behavior was removed, the bug slipped
through leaving this legacy behavior around.

Fix this for good, as it actually causes very confusing behavior if BPF
object file only has subprograms, but no entry programs.

Fixes: bd054102a8c7 ("libbpf: enforce strict libbpf 1.0 behaviors")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20241010211731.4121837-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d39b340222d61..2fad178949efe 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3990,7 +3990,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 
 static bool prog_is_subprog(const struct bpf_object *obj, const struct bpf_program *prog)
 {
-	return prog->sec_idx == obj->efile.text_shndx && obj->nr_programs > 1;
+	return prog->sec_idx == obj->efile.text_shndx;
 }
 
 struct bpf_program *
-- 
2.43.0



