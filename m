Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698131DF73C;
	Mon,  2 Jun 2025 15:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877089; cv=none; b=OGz3rh3Y9rkr234+i4yT1mwoEb1GcCyfyQIQpSI6bsdHhmf8YCxe+m2nkWmduMiBlICMZ3FTabmvgfFtg+4WIrB1SVPA2XTu2Lmd+2Fx81KRsCeyG1zLhzSr9GCkIuUrSk21DLnUpyWecz0J1LxhEz/NeRPks1aempSrKcatOLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877089; c=relaxed/simple;
	bh=DOTQOcgx5/2LnSs66q6DEuP607uuEEHz4wTF2/o7ABQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GR/ZGouMpBBDrDClBzpzt84XDqzalIbSiW0KNlQ0a+j6bm4+qEFHDjv8JZ4smy1aVYr025lMMV2e47qLGppI2nNbcmW73W9LPbMlW3/uZTxyDBUaeZV9t31UcdYezlrlPZ9y4BTsWJFHsJx2uUI1YDbq0Dim4ABiINftCZ0nix0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsHiIyoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsHiIyoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD875C4CEEB;
	Mon,  2 Jun 2025 15:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877089;
	bh=DOTQOcgx5/2LnSs66q6DEuP607uuEEHz4wTF2/o7ABQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsHiIyoO+zLSgt3ASxhdtcUVBE458Oz3IU31svJS7Us5BZ8BMrf6dnr7YKTdAMy4Q
	 oOvtEQBNQfbSPpjcLk00qN+JV2DuyZxnBPJ32uVUsCrXQ2FIeB+0RoIJFJ26+DiauL
	 IudzzDheLaAkaacB6EjDi2r94AJPfPQt0WGbt3Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandakumar Edamana <nandakumar@nandakumar.co.in>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/325] libbpf: Fix out-of-bound read
Date: Mon,  2 Jun 2025 15:46:57 +0200
Message-ID: <20250602134325.530389669@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a0fb50718daef..98d5e566e0582 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1751,7 +1751,7 @@ static int set_kcfg_value_str(struct extern_desc *ext, char *ext_val,
 	}
 
 	len = strlen(value);
-	if (value[len - 1] != '"') {
+	if (len < 2 || value[len - 1] != '"') {
 		pr_warn("extern (kcfg) '%s': invalid string config '%s'\n",
 			ext->name, value);
 		return -EINVAL;
-- 
2.39.5



