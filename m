Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035C72494FE;
	Wed, 25 Feb 2026 01:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983544; cv=none; b=UVkqUIbdrpUwFB/RbJB/5hpPDsjNNYT6WD0FWiG0MwAq7Xqy+B6e7J+J/CLUYxiiS4DFiPMnYlZx8tejYPrRwM6UYPm69WVDn0Y1Dy1rNmI/ObnlRUXo2hiPT9p1ddxkGKGiLDv6jUO+WN4lITP8f9DEniTUczgxoFdjNOei3Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983544; c=relaxed/simple;
	bh=uZqNJvZ+STspT0v0sNDbZR5GTOwPZA1deNvEfHqduqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGIPqaHI5Dbzwe2bU811ecnJxiE4IR3XleuzZMmtJHNKuwmiOM/Pe+9vEFuRWPAlYX8rAUFVSzER8PN3qX0E+Da0haBkVQ0A6yN42N5KH/kw/G5GkU7dsC/43NJOw5SFgToyHEdTfxmaRBesvWIo9Iw32ov+oGFykzXChVVs3TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IY24/3Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IY24/3Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18E9C116D0;
	Wed, 25 Feb 2026 01:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983543;
	bh=uZqNJvZ+STspT0v0sNDbZR5GTOwPZA1deNvEfHqduqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IY24/3HnxoQVh7zDWUppLfsgamNYERA4Q6K16CafqWeEsvpzwAxyatLRwPNMVmx2v
	 ml+QRQPSG4VYmTksYFlGr1xihoorDKrfz5SnimLpjiLkEcX0uojQ2sFwSNYh1pyPti
	 a+/dGrnZNeLoYypvfIRYaw68z5LJuEMWtIvyTkfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 647/781] libbpf: Fix invalid write loop logic in bpf_linker__add_buf()
Date: Tue, 24 Feb 2026 17:22:36 -0800
Message-ID: <20260225012415.664357783@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amery Hung <ameryhung@gmail.com>

[ Upstream commit 04999b99e81eaa7b6223ec1c03af3bcb4ac57aaa ]

Fix bpf_linker__add_buf()'s logic of copying data from memory buffer into
memfd. In the event of short write not writing entire buf_sz bytes into memfd
file, we'll append bytes from the beginning of buf *again* (corrupting ELF
file contents) instead of correctly appending the rest of not-yet-read buf
contents.

Closes: https://github.com/libbpf/libbpf/issues/945
Fixes: 6d5e5e5d7ce1 ("libbpf: Extend linker API to support in-memory ELF files")
Signed-off-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20260209230134.3530521-1-ameryhung@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index f4403e3cf9946..78f92c39290af 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -581,7 +581,7 @@ int bpf_linker__add_buf(struct bpf_linker *linker, void *buf, size_t buf_sz,
 
 	written = 0;
 	while (written < buf_sz) {
-		ret = write(fd, buf, buf_sz);
+		ret = write(fd, buf + written, buf_sz - written);
 		if (ret < 0) {
 			ret = -errno;
 			pr_warn("failed to write '%s': %s\n", filename, errstr(ret));
-- 
2.51.0



