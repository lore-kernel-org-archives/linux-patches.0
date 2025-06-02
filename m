Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF8227E95;
	Mon,  2 Jun 2025 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876180; cv=none; b=SevvkuKOB2R0zDL7NeQ1gl588sOnKLEjmhdGZg6OD76Tx9mMGe5mQwDDSSlzb8agos3tcAbawZ9knOcHsaltmvfuVnD6kzZ4SyRg/YdLfd0h4/Ld6ByfK8IENMjUn3inLhf2//hyWSM4FIZDC6/A7cOvOx/N5AK9WyoBWMrNkv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876180; c=relaxed/simple;
	bh=f5QTFoujuLer7SklPTZ3SItX8ret6YT9g7hr9p1P9uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYoMbSAUhjsGoZGgtS7T/Tt4z2HFRFU7XZi6sBipfJgLuIBzgJIv/j1UOw8pswHHgSs5u/4qfKWETzYO70WfTJnptdgF/6njscOEaI85tTMZKIG3VGn83gBR/l1jjpD6R2O+vHtWD9oWUJz22M1vu9aievyOyRnoPz+BRHq5n60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOBaG37+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOBaG37+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2E6C4CEEB;
	Mon,  2 Jun 2025 14:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876179;
	bh=f5QTFoujuLer7SklPTZ3SItX8ret6YT9g7hr9p1P9uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOBaG37+aMqCQ9mVyGksYfAWizsuzkKc5dQPIhAcjvxwx9zZsMAB3NQ3l0NUAcUDP
	 ss9VkT6WWPrj8PeSxm6+i8twsh4kwPor7fW1ENLqeYBdFpdAIDTzNlrwLA4KTfUU9m
	 Ue4f7DR1SBsKkoftM+y8FS1SPK5kF6G1ehYkuvbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandakumar Edamana <nandakumar@nandakumar.co.in>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/207] libbpf: Fix out-of-bound read
Date: Mon,  2 Jun 2025 15:47:49 +0200
Message-ID: <20250602134302.538449790@linuxfoundation.org>
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
index 294fdba9c76f7..40e0d84e3d8ed 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1567,7 +1567,7 @@ static int set_kcfg_value_str(struct extern_desc *ext, char *ext_val,
 	}
 
 	len = strlen(value);
-	if (value[len - 1] != '"') {
+	if (len < 2 || value[len - 1] != '"') {
 		pr_warn("extern (kcfg) '%s': invalid string config '%s'\n",
 			ext->name, value);
 		return -EINVAL;
-- 
2.39.5



