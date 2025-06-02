Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECA31CBA18;
	Mon,  2 Jun 2025 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873914; cv=none; b=hr19A4krKXQ32ZcX9+E9GloSGuj/iCnjmWAqE1WEe0kYECKTNJFnccY/Eo6Pi0n8msHMQ6POQB4e/yOf9Rgj382gHZxAfXYH+HFbBF+xaWRWa6vDtHEa9AIfKi2JvHxbKkg/VgxqqxSLjrf4WVWDkBQq3UWXxrIdffM6z6sSRnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873914; c=relaxed/simple;
	bh=wdWFbBuYXmnpskCXzMtSB1dzdJF+qyj1OZ/tZ+I0OZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zb3cCYrG0Ce7ukmbDZA++vwhaOG7M/OBwoG2rqMH2/JCaOvj6aGdjU2ALZi8PSPNpnoaSxRLYGtsFC0zhe77aUdomhwSiBPfUib0a4+T2zCGB//pUg8w+2V2dfeyldZbsHezJgiC2PwaYuDBeSMXsZhXRlrhrdGerO8VSfhAHsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yefcfnPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yefcfnPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8ACC4CEEB;
	Mon,  2 Jun 2025 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873914;
	bh=wdWFbBuYXmnpskCXzMtSB1dzdJF+qyj1OZ/tZ+I0OZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yefcfnPzz8MWYHsxBTKWyWVw++hZ86WgN2JDD+vrdpkD3dRQv7wTafMvkCE2r4oyN
	 s392049LTZVv1yhReSCd7A2Wp6XJMQDENdPsgRRiBPSFLcCaSDlw6rW8rRj7z3hFYL
	 zUH2GrTrkYm2PKbUfn2vLhD6Z++M5RKgrxl8p2eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 295/444] bpftool: Fix readlink usage in get_fd_type
Date: Mon,  2 Jun 2025 15:45:59 +0200
Message-ID: <20250602134352.924768119@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9b75639434b81..0a764426d9358 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -461,10 +461,11 @@ int get_fd_type(int fd)
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



