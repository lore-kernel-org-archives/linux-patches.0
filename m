Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A0927CCF0;
	Tue, 27 May 2025 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367379; cv=none; b=rkt1u3EmCliw0yuMMed3fPg2E299dnJvRcI/cTJcCVYJqRtArXZYJlkF0+HhohZdBbgWkkXbgNYPtYRXnvUsXDhgfCETECgpf6GUCYT6veRcXjGupy8BM5EkjiUKRmXtFes1EbkYgT2+WKp/qThVXXZYSvEP16S8ksybdF4/W8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367379; c=relaxed/simple;
	bh=nqluXvKEGPkvPOCCodGnwdXU75nbWLqbkXDfZYlohsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTxitSp/Yu1XXpntO886kYyue7o4vnhoV9JjotsqF8x5brGiY64b5UJMS0pDv28zEjwt8xfijL5wdyaRcUZ7hgGrdyNW/MU9zeWnHIqYE1h6byZ/UnpBa6mvJuGLW6eBMqYTK2eVH76kQ4jPEs9EyCX9i2SLwjlV+qqQ3Dx/nDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8jwj0o+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8jwj0o+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F679C4CEEA;
	Tue, 27 May 2025 17:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367379;
	bh=nqluXvKEGPkvPOCCodGnwdXU75nbWLqbkXDfZYlohsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8jwj0o+t7LBFCkAfzTcryBP+7286oaKplUs29M8TdsV21TK0JTW8LL8YPnQQSMNC
	 sNWOdSJlsvopdMc1aerp0fwf2seoqaDHBcyR8sZOGdHR3kLdWmtpfHlHiF8u3gY0A1
	 O/WXDiJOmWhic8549PJyHhBdJXiSaG6S8Wz/b2Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandakumar Edamana <nandakumar@nandakumar.co.in>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 368/783] libbpf: Fix out-of-bound read
Date: Tue, 27 May 2025 18:22:45 +0200
Message-ID: <20250527162528.067584602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 6b436ec872b0f..1791a12b1aac5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2106,7 +2106,7 @@ static int set_kcfg_value_str(struct extern_desc *ext, char *ext_val,
 	}
 
 	len = strlen(value);
-	if (value[len - 1] != '"') {
+	if (len < 2 || value[len - 1] != '"') {
 		pr_warn("extern (kcfg) '%s': invalid string config '%s'\n",
 			ext->name, value);
 		return -EINVAL;
-- 
2.39.5



