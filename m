Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE85215E8B;
	Mon, 30 Dec 2024 15:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574044; cv=none; b=m2xLr2lXt+R1Ovyi5v/1LigwZY8YF5QwII2jaVywWn0UpeBhl1cdm+i/VpcYIGNbhYPRYDPZMKeOG+TrizHirKr6A604mTONhttmWN3ue2+3K00oe9Wjo7AViOZZLotseq1ET4YLVV2pp7q56jzDXNngv5ih0XgwCWMtVjrXCE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574044; c=relaxed/simple;
	bh=Cio0mgOsxI8XSg+7jNpUkTRUP+z8ss9beLEFmIRozRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z07h2wRmvujeRX0Rbu2DeURRRgBv3FYE7zcuuFEG1aBSchM+JAq9FY67oS66t7zg/kJv1i1jfGeRLiNMfyE2PeN2Lckjc0SR14gTwOjVp1i0hrSRge96s+hFHyTJ+7QnUxClkp/2UJ2FLxsp8DQLJkU6V08SHnr8ic95gK7GT2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+kybC8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+kybC8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748CEC4CED0;
	Mon, 30 Dec 2024 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574043;
	bh=Cio0mgOsxI8XSg+7jNpUkTRUP+z8ss9beLEFmIRozRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+kybC8g/I3GBYaH+c6Q7FlPsOHERiZyfiZIUEyMejtUsChyrk9wVET317GC4w3vi
	 vMDL/dIJ2tF3i6H2/+Q9GmyzIkNGfgUsZ+cNh5oDI8jujt5HQ/UDjgo6CQnkWMA713
	 USlZy0a1oygsFAi1blNfPz6pl+CfBBrGAE9NFTzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Marchand <jmarchan@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/114] selftests/bpf: Fix compilation error in get_uprobe_offset()
Date: Mon, 30 Dec 2024 16:42:04 +0100
Message-ID: <20241230154218.343609849@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Marchand <jmarchan@redhat.com>

[ Upstream commit 716f2bca1ce93bb95364f1fc0555c1650507b588 ]

In get_uprobe_offset(), the call to procmap_query() use the constant
PROCMAP_QUERY_VMA_EXECUTABLE, even if PROCMAP_QUERY is not defined.

Define PROCMAP_QUERY_VMA_EXECUTABLE when PROCMAP_QUERY isn't.

Fixes: 4e9e07603ecd ("selftests/bpf: make use of PROCMAP_QUERY ioctl if available")
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20241218175724.578884-1-jmarchan@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/trace_helpers.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 2d742fdac6b9..81943c6254e6 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -293,6 +293,10 @@ static int procmap_query(int fd, const void *addr, __u32 query_flags, size_t *st
 	return 0;
 }
 #else
+# ifndef PROCMAP_QUERY_VMA_EXECUTABLE
+#  define PROCMAP_QUERY_VMA_EXECUTABLE 0x04
+# endif
+
 static int procmap_query(int fd, const void *addr, __u32 query_flags, size_t *start, size_t *offset, int *flags)
 {
 	return -EOPNOTSUPP;
-- 
2.39.5



