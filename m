Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92D946444;
	Tue, 10 Sep 2024 09:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961902; cv=none; b=otGALy7O0/Ie6n1O3gu0trRbSVPxVZ0IJlJ9Ypz+9WzuZGo069S+9AFs17XyCyyRAm2eWHOMO124S5xEpnAht6Z/7sY1eV84K3C+YN8kWM5JAHYhcC3YVbZg9yQzFZy+HmwKYr2cfM+ODMLBdSZPVSZ0pRkF6wVuIyydEqhJv+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961902; c=relaxed/simple;
	bh=sK0iNmQP+wRgN+zy8jL5MGfOF26I6S2GuL2vdJd44iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mf3LgssZccaEaYn2s5inhv+kI9+CENHibWBce/OaVuWSBbp7PEMp3INPKWy3/a+FqwzJAU7mS1B2NImqSdu8zfjtXII7nQfd4DVMx/p4Vkim1D1qxgYAHuXNLhnPYhVcsOCpVUQhDB4b9xCDmNKD+s+Nvjq+0/X/jIzzvoJJMdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmySJCGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmySJCGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE14C4CEC3;
	Tue, 10 Sep 2024 09:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961902;
	bh=sK0iNmQP+wRgN+zy8jL5MGfOF26I6S2GuL2vdJd44iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmySJCGe5VFMctkrE2oNJCpVmojFlj+CH6B29JGlCi0QHXDwa+LA3N+HS5ZW4x7IQ
	 UC9/QRzokNMt0eQvbuClaUeZQwrHh9/3vSck+hmQ5Ssgx/ApTlAjB1M4yKpe6Grt2U
	 /0TxdZqduM27nEh1QU8a6GMvV+ya70lnGSB6vt/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 190/375] bpf: add check for invalid name in btf_name_valid_section()
Date: Tue, 10 Sep 2024 11:29:47 +0200
Message-ID: <20240910092628.875900536@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit bb6705c3f93bed2af03d43691743d4c43e3c8e6f ]

If the length of the name string is 1 and the value of name[0] is NULL
byte, an OOB vulnerability occurs in btf_name_valid_section() and the
return value is true, so the invalid name passes the check.

To solve this, you need to check if the first position is NULL byte and
if the first character is printable.

Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Fixes: bd70a8fb7ca4 ("bpf: Allow all printable characters in BTF DATASEC names")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://lore.kernel.org/r/20240831054702.364455-1-aha310510@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index fe360b5b211d..2f157ffbc67c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -817,9 +817,11 @@ static bool btf_name_valid_section(const struct btf *btf, u32 offset)
 	const char *src = btf_str_by_offset(btf, offset);
 	const char *src_limit;
 
+	if (!*src)
+		return false;
+
 	/* set a limit on identifier length */
 	src_limit = src + KSYM_NAME_LEN;
-	src++;
 	while (*src && src < src_limit) {
 		if (!isprint(*src))
 			return false;
-- 
2.43.0



