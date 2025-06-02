Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954AA223DCD;
	Mon,  2 Jun 2025 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873601; cv=none; b=B0/x5rx8kCK4TSzzcz794bxelJQRq9VjI0AzH33F1j4npdKzyQyJj6Ov4E6rK55aXdEq5BZu6Rr9KMT/KkPMVaZ2RIZC6KrwLadMWUVRLre/dd39u1dgc3WFrVa5ByunO/AHWWdgp19yEYnrJYURp5YRSC+zn2il6qcBQb9Ngxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873601; c=relaxed/simple;
	bh=GIm50p4n/Eyw2Us4kyZ3yaLejCKRchxCC7YvgKmeq18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dch6arq14a8LkPFMtBYEzG2bKZLfE9ANTYIuy+nnLFG4JADUN0htxkKdj4eJikrwHLAlYhjkTeBBSvR9zj/8lJ5m1BK1OqPCaS5fl+HgQfWmk1w/50qqjCcwjB6eY1xf+W99h51ZfPbOy6UXqVUn7vMt3JvYHmwQdHlKOjuJcpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVXe+Via; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVXe+Via"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9374BC4CEEB;
	Mon,  2 Jun 2025 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873601;
	bh=GIm50p4n/Eyw2Us4kyZ3yaLejCKRchxCC7YvgKmeq18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVXe+ViaOJnUuwZ02vPY5kLcnRBLr6kVK85rd0a8+v3IzFTObfz6nVqYwCmV1WJin
	 fYx9HNSzyMKVMbYr45fyXNMe2P0fN6V7ODgYWF7ATuq9id2Juc3t3RdAqS9bbEYjQs
	 AWpRpcEQpToBlZgvrw9kj8qHX4xiTVoeLQ+hOqiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandakumar Edamana <nandakumar@nandakumar.co.in>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/444] libbpf: Fix out-of-bound read
Date: Mon,  2 Jun 2025 15:44:16 +0200
Message-ID: <20250602134348.699013555@linuxfoundation.org>
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

From: Nandakumar Edamana <nandakumar@nandakumar.co.in>

[ Upstream commit 236d3910117e9f97ebf75e511d8bcc950f1a4e5f ]

In `set_kcfg_value_str`, an untrusted string is accessed with the assumption
that it will be at least two characters long due to the presence of checks for
opening and closing quotes. But the check for the closing quote
(value[len - 1] != '"') misses the fact that it could be checking the opening
quote itself in case of an invalid input that consists of just the opening
quote.

This commit adds an explicit check to make sure the string is at least two
characters long.

Signed-off-by: Nandakumar Edamana <nandakumar@nandakumar.co.in>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250221210110.3182084-1-nandakumar@nandakumar.co.in
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2fad178949efe..fa2abe56e845d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1802,7 +1802,7 @@ static int set_kcfg_value_str(struct extern_desc *ext, char *ext_val,
 	}
 
 	len = strlen(value);
-	if (value[len - 1] != '"') {
+	if (len < 2 || value[len - 1] != '"') {
 		pr_warn("extern (kcfg) '%s': invalid string config '%s'\n",
 			ext->name, value);
 		return -EINVAL;
-- 
2.39.5



