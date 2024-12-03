Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470001F6691;
	Tue,  3 Dec 2024 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238361; cv=none; b=MAuXSv/Z+F7mnon9XstU8dGDC/BbJIGNGqzG/Pnxf0zel91TObFitdfuog/1la6xAzWY3AUjr1kzu6DCkxJGOF2kHEN/kiEslZHA+0jpAt5crhI7XrdHm9qhcmnJOslaASpWqNftbm1n4JTC9BpIPSkyyajiF6Q8jcWn9+ZjuUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238361; c=relaxed/simple;
	bh=U2hfuiPedwIiQdbcuXod6SQeqNmZqhnySR7Wwf7op/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOrtUkTN32qCn+5GBMwI1mcal1A2yWRzWgjy7kgQwRysu2dtphgximeTq16nwaZV6zHtfNW9h9D5r2iuHFDG271fJx7X0TfDbbAYvE6BEStVLv5Ubrpmr1XoSfU10kKoKeM0NRuT25CkLPt9D06pVXHqa1smxDtIIsbrLf8oI6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtbYMbcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtbYMbcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95BEC4CECF;
	Tue,  3 Dec 2024 15:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238361;
	bh=U2hfuiPedwIiQdbcuXod6SQeqNmZqhnySR7Wwf7op/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtbYMbcfEH1MAORTb5eFbRJaimPtgUodUyRAx9I6x7JF0Z9giOrZd/K2R+O+mA9zR
	 /nsRI4Q9KhGlAvbChYOKFZMeMhSeZNakDAdTLk+uBx3aag9gxJ76p53pcDLyIoACfv
	 Yf25imvrutXYyDvUwFT54++YUcrH0t8xW8Euse9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 253/817] libbpf: Fix output .symtab byte-order during linking
Date: Tue,  3 Dec 2024 15:37:05 +0100
Message-ID: <20241203144005.646812381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit f896b4a5399e97af0b451fcf04754ed316935674 ]

Object linking output data uses the default ELF_T_BYTE type for '.symtab'
section data, which disables any libelf-based translation. Explicitly set
the ELF_T_SYM type for output to restore libelf's byte-order conversion,
noting that input '.symtab' data is already correctly translated.

Fixes: faf6ed321cf6 ("libbpf: Add BPF static linker APIs")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/87868bfeccf3f51aec61260073f8778e9077050a.1726475448.git.tony.ambardar@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 9cd3d4109788c..7489306cd6f7f 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -396,6 +396,8 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
 		pr_warn_elf("failed to create SYMTAB data");
 		return -EINVAL;
 	}
+	/* Ensure libelf translates byte-order of symbol records */
+	sec->data->d_type = ELF_T_SYM;
 
 	str_off = strset__add_str(linker->strtab_strs, sec->sec_name);
 	if (str_off < 0)
-- 
2.43.0



