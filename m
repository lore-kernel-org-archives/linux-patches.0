Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D3627713;
	Tue,  9 Jul 2024 11:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524509; cv=none; b=BlMNSwpWrtjE7oZ8VpTOzjpwl2q9lOLtXTv/V08ZUl1xTIxua+AXLhxw32lhQu6YtwgKSrvCOyDKkn4gaJFsHBLK+IbwjZsgy80GLnBPna7V2I7QbIAulPxT1uQszI0zPF3Jz4U48axDsXSbFaK4EbbfXbdYf81VvHNYAYFp/Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524509; c=relaxed/simple;
	bh=q8fJ/ZND6o5ztUgvDzzTXW50C5jUzrCOTD8XhskQEKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ztap9H3/oaZrbU+GTlghShueTjaEaZ2xwvIz1nMJI2Ntd33Dn/K1HdaNC+N+I1Su8b6/XOzEr2TaEiv/HoagN8W10ao5nBsunGt4boVqIZZvTJhbyYuC+7wi0xml9HYJ/pTAn/B1j8WuaI+DnR4A/jk0KM1T4NnsdKEzHkFigcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j71V6b0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j71V6b0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A07C3277B;
	Tue,  9 Jul 2024 11:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524509;
	bh=q8fJ/ZND6o5ztUgvDzzTXW50C5jUzrCOTD8XhskQEKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j71V6b0TgO7GnXv/mHT7wh2mJk0tmKulo4FoKTkciwO0LtwcMH1B8KnAHvdA4HGjL
	 JHCEVmUbBuV5UBJtg0fFbNBmk39bSNIJbKIfBnDu3L/jW9a2MuSyBMkfsZPwAkqLJ+
	 cbA5Xy/ktTFY2AhkXa5YXRTpf744EDtXLKwzUyYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.9 197/197] libbpf: dont close(-1) in multi-uprobe feature detector
Date: Tue,  9 Jul 2024 13:10:51 +0200
Message-ID: <20240709110716.562123892@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit 7d0b3953f6d832daec10a0d76e2d4db405768a8b upstream.

Guard close(link_fd) with extra link_fd >= 0 check to prevent close(-1).

Detected by Coverity static analysis.

Fixes: 04d939a2ab22 ("libbpf: detect broken PID filtering logic for multi-uprobe")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20240529231212.768828-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/features.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/lib/bpf/features.c
+++ b/tools/lib/bpf/features.c
@@ -393,7 +393,8 @@ static int probe_uprobe_multi_link(int t
 	err = -errno; /* close() can clobber errno */
 
 	if (link_fd >= 0 || err != -EBADF) {
-		close(link_fd);
+		if (link_fd >= 0)
+			close(link_fd);
 		close(prog_fd);
 		return 0;
 	}


