Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE933451BF;
	Wed,  3 Dec 2025 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777502; cv=none; b=Gjv5kbFTT3Nii4vcWp8YfP1ryGnHS4bnQDBFJ75kQbsUrjZsKFG9iB12IV20PQNHovVqkjr4jR7D6BEU0pRgNLTEBTnc0O0jwIHhio26KKPRM2dpsaV3kooy6aSJRpVC+VIZdTNUPYgUm7QsWI5eXEgkYfRdaG01OxES4sY7I3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777502; c=relaxed/simple;
	bh=BgGljCg7AamPtZi7F699RHbhzWUqO2s7iIZAlrQmJEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SJAKBA+stpdI8n3o32VCGzNo+Xr5lUciq5Abewqmw1Rz6gPiCQm2knGrKFDpDAt4v6leipqTV7qVf3BU0tBeHJ4IVxnSQJi1J5CQgpAq7+2d/0dpFSHMLBDwPNG8JufluvuiorK7XVijdv/9U2mQeWIitRvb8nVSs0SV4Xoi4hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eu38BtKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eu38BtKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C719C4CEF5;
	Wed,  3 Dec 2025 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777502;
	bh=BgGljCg7AamPtZi7F699RHbhzWUqO2s7iIZAlrQmJEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eu38BtKciBRCAh5WrHjK1nK2ySHxNh7ve5A3K7o5pUrPisoPHHKb7e7P5wHMC4K6h
	 5DNndSqLVRltFU+GVWHahNDHWn8YAr/2r+dd6HGPrzEQ7Jfo4EwmXkGO6Z0iwOMFlP
	 7ic0Ka55pUQl2GwCJJLTSUBXh7nMVYxQiqKCeUH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/392] bpf: Dont use %pK through printk
Date: Wed,  3 Dec 2025 16:23:27 +0100
Message-ID: <20251203152416.211236217@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 2caa6b88e0ba0231fb4ff0ba8e73cedd5fb81fc8 ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250811-restricted-pointers-bpf-v1-1-a1d7cc3cb9e7@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 7d8294d0d7173..dc49c8eb00fd6 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1090,7 +1090,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other);
 static inline void bpf_jit_dump(unsigned int flen, unsigned int proglen,
 				u32 pass, void *image)
 {
-	pr_err("flen=%u proglen=%u pass=%u image=%pK from=%s pid=%d\n", flen,
+	pr_err("flen=%u proglen=%u pass=%u image=%p from=%s pid=%d\n", flen,
 	       proglen, pass, image, current->comm, task_pid_nr(current));
 
 	if (image)
-- 
2.51.0



