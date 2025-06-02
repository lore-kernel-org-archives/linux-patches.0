Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E87238174;
	Mon,  2 Jun 2025 14:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876344; cv=none; b=po9j6WePh8x2wAr2CMdhBX6sCnpBMdyiiwmZgNOTV2Vn8MB12A+WN+BawN+LdeqebV8g3n1FDx1w/Cnsv086hAdhjXT87CKC5u4TudfXNocsD5CEqoeWq4UJsEACQIJIs3jY+GymYv7N3WeVt9khzrvSvmsNkT1Fkcc28+HZx/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876344; c=relaxed/simple;
	bh=hDkUA4cEEsZwHHY7uXz5q4lIw80E8U7zX/KILu7/B1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqvI0cpPWop6NtNByprqL5dL+fwVy3zf23zelPzc+LPToWou80SYagEgWurJOi688GXLVmLkzijJC0GlS0RH5Uise2BcgaDehnw3DQL2wRWIRq/mak0KVZieM9z03RLtM7ibidKEZgOTcbSl+LGFtOHfgndNgmkkVmqJKYdOpb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMbxh8aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMbxh8aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EF5C4CEF0;
	Mon,  2 Jun 2025 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876344;
	bh=hDkUA4cEEsZwHHY7uXz5q4lIw80E8U7zX/KILu7/B1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMbxh8aUZ4O+nY2Me0jYpyIO6cKBT3SSP4xrXrxijWhlnT0uRaGwXqqzfUdZ6dRKz
	 IEQUK/NxzlP2SKnckV1zUujuBze/O/RHgM4HG1HT3gTOF5pBeKxEjvwcqG6DruccOg
	 l+ghCTQQW/rgewZjalL/HwiYebUjY9RgQ+oYNmZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/207] bpftool: Fix readlink usage in get_fd_type
Date: Mon,  2 Jun 2025 15:48:38 +0200
Message-ID: <20250602134304.440729650@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit 0053f7d39d491b6138d7c526876d13885cbb65f1 ]

The `readlink(path, buf, sizeof(buf))` call reads at most sizeof(buf)
bytes and *does not* append null-terminator to buf. With respect to
that, fix two pieces in get_fd_type:

1. Change the truncation check to contain sizeof(buf) rather than
   sizeof(path).
2. Append null-terminator to buf.

Reported by Coverity.

Signed-off-by: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20250129071857.75182-1-vmalik@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index e4c65d34fe74f..2b4773e00ab68 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -318,10 +318,11 @@ int get_fd_type(int fd)
 		p_err("can't read link type: %s", strerror(errno));
 		return -1;
 	}
-	if (n == sizeof(path)) {
+	if (n == sizeof(buf)) {
 		p_err("can't read link type: path too long!");
 		return -1;
 	}
+	buf[n] = '\0';
 
 	if (strstr(buf, "bpf-map"))
 		return BPF_OBJ_MAP;
-- 
2.39.5



