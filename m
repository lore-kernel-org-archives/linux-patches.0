Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955EC2D77F5;
	Wed, 25 Feb 2026 06:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002719; cv=none; b=haLWGrgxM5NepXuDmYKI9Tc0UHIZhXsp98XwY6xO50ivLlhQRT7m/OEkIZo/GQgJckVT4BA1hDxXIjqYAEiv3OF2DUgfd4BFfBhLJiiOJOjm0YEDBB/5PTlQ/qx7uuKEOauV8vzp9Ss/bHEgr6E/YVSnr1SyEph94BSzTAPl3zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002719; c=relaxed/simple;
	bh=m/2TukzH2o6WaiTi5r0mO9/o03fZ9q4XEq43G5HnOa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idLhJSb+Od/BJARsVJPrT/rT0+9H0h6XETHR75FC3OYAg6j2dWuZd/SWpnBP8qi/PNPlIFGIXvC7Q+SMSueW0JkR8eNV+9+TVQfJ5j03peUQTQLQQR9ZZHdF65rpmSvm1givo6qDmU0ijqmNu35ZSW/Ws0Q0XY5jbxecOxlStFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sft71XOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sft71XOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDC1C116D0;
	Wed, 25 Feb 2026 06:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002719;
	bh=m/2TukzH2o6WaiTi5r0mO9/o03fZ9q4XEq43G5HnOa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sft71XOXFhF8lU4yelHojE2f3Ju163PcJaX32MjowNBpD2KGaeRrrQ020tIy91P6w
	 j5EmIGSzP55Q6DMXtKHCHHVw1bu0HktEH2K/x09Hyu95cPn6gP/PkA19co5tmGWIkC
	 d1tMOmk0KWp34ynJtfT+XRHtWWrG5Add2jy7DeCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 529/641] bpf: Add a map/btf from a fd array more consistently
Date: Tue, 24 Feb 2026 17:24:15 -0800
Message-ID: <20260225012401.347297629@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit b0b1a8583d8e797114e613139e3e3318a1704690 ]

The add_fd_from_fd_array() function takes a file descriptor as a
parameter and tries to add either map or btf to the corresponding
list of used objects. As was reported by Dan Carpenter, since the
commit c81e4322acf0 ("bpf: Fix a potential use-after-free of BTF
object"), the fdget() is called twice on the file descriptor, and
thus userspace, potentially, can replace the file pointed to by the
file descriptor in between the two calls. On practice, this shouldn't
break anything on the kernel side, but for consistency fix the code
such that only one fdget() is executed.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/aY689z7gHNv8rgVO@stanley.mountain/
Fixes: ccd2d799ed44 ("bpf: Fix a potential use-after-free of BTF object")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://lore.kernel.org/r/20260213212949.759321-1-a.s.protopopov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index dade674ffe071..c4fa2268dbbc5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24098,9 +24098,11 @@ static int add_fd_from_fd_array(struct bpf_verifier_env *env, int fd)
 		return 0;
 	}
 
-	btf = btf_get_by_fd(fd);
-	if (!IS_ERR(btf))
+	btf = __btf_get_by_fd(f);
+	if (!IS_ERR(btf)) {
+		btf_get(btf);
 		return __add_used_btf(env, btf);
+	}
 
 	verbose(env, "fd %d is not pointing to valid bpf_map or btf\n", fd);
 	return PTR_ERR(map);
-- 
2.51.0



