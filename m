Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB5A7DA6A;
	Wed,  5 Feb 2025 14:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766104; cv=none; b=U11IcunBPHPAur791FApBp900InD0d/yG3m9+m1bl3Ttgo11ZZJKfHrs9HZRzlUR2uQZz1C8tOf5dEO7sECJGlZVYvULX02TxDcpL4iaHBGwcM5g18/+FQ4asQ4LFtl2Fdaf674P4pVivRS9gPf4HlnAQyKIOkmm6qYIGK5C4tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766104; c=relaxed/simple;
	bh=LVaivByUdPMCBOZcvbd1Cb2SKSaDmYUulbvWQHwv7Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGNjons6K0PYFGoABTzErE5Yrsg68aTltNRL8PRBnlT41xrLsGP4HCupzmsglNzmdFUpVGskFJT98NvpaVCCzjZYarXL2EBhsv+46VvMsm+tH3/9hNtsNrUTpCp7s2NCeOex9OsEKEx9EIGe+HqoZ/cKlJvDgH+twHdPO9HmtJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pn5o9bt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pn5o9bt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAE6C4CED6;
	Wed,  5 Feb 2025 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766103;
	bh=LVaivByUdPMCBOZcvbd1Cb2SKSaDmYUulbvWQHwv7Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pn5o9bt7D7s/usEphIe5E7JCRerL37WVAiGUOmFRAj1etSQAGnWjykk1EOnfWvVlE
	 le95aSTov7+PgLshj+nGEjX7ddxFm55NqFxlGmfylzqHmzO37PYagSFTnEG9PwNtKL
	 DrTInlIKMMXBkhtn7UeR/8HZ8+p9zfzYeQaUrmMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 287/590] libbpf: Fix return zero when elf_begin failed
Date: Wed,  5 Feb 2025 14:40:42 +0100
Message-ID: <20250205134506.256934088@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 5436a54332c19df0acbef2b87cbf9f7cba56f2dd ]

The error number of elf_begin is omitted when encapsulating the
btf_find_elf_sections function.

Fixes: c86f180ffc99 ("libbpf: Make btf_parse_elf process .BTF.base transparently")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250115100241.4171581-2-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3c131039c5232..27e7bfae953bd 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1185,6 +1185,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 
 	elf = elf_begin(fd, ELF_C_READ, NULL);
 	if (!elf) {
+		err = -LIBBPF_ERRNO__FORMAT;
 		pr_warn("failed to open %s as ELF file\n", path);
 		goto done;
 	}
-- 
2.39.5



