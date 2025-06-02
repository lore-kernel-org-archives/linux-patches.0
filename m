Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0942E22D78F;
	Mon,  2 Jun 2025 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874865; cv=none; b=YzbPOwtgRGCFvoQq33SMtUmpHbY/dhOsg3oPbfg/ueuLELu1Che0bmgGhrapuENRp7SbOGH+t4m7SO4h0Qmwm1tJZmb7um+FBnO94F6GMSIZj94oUljCL+gl7pOuHoQJemGjiDoIN6bTAOk0G3XUx2sWr5iPeKSzldfUaNESPvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874865; c=relaxed/simple;
	bh=Mq8AkIxvRqRFzmIEdRH8w5iJs288RmJBbcMzFBm9tes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kztIQjUwRvleWXPBzuRKpP1Y4pzgWzun+5ZROeUWNe5y+0XiQ+VoKnoOflJhIwHjH072tfpNOZCIyBWRtz8lmlNSgZ2wrM5/tK0LupQIHRMIy4volUq94fEWFvTYnX3OftDI2cEqlnMqJw0NT085Ipsse2RcFRULivspOyKylCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUdj85Dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUdj85Dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41521C4CEEB;
	Mon,  2 Jun 2025 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874864;
	bh=Mq8AkIxvRqRFzmIEdRH8w5iJs288RmJBbcMzFBm9tes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUdj85DdmuXPoWfGIpACUu4NHfHoJioUE3KLJcXUy3q1q9dbB4L8l0AsI6fTWn9Mn
	 gWix+LFKCw95qojMW62hAWdkSGBPWH1GluFiSbzG7lrXj4LeSSI4TEBa0ysZTRSglT
	 RYGaukloNu3+WZ2+6gC2MjhpQ+IcGgJFjWsVgUDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/204] bpftool: Fix readlink usage in get_fd_type
Date: Mon,  2 Jun 2025 15:48:13 +0200
Message-ID: <20250602134301.944137529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a209f53901b8c..91bf7575493b5 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -283,10 +283,11 @@ int get_fd_type(int fd)
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



