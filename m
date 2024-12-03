Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A143A1DDC24;
	Tue,  3 Dec 2024 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240735; cv=none; b=mid3BtSwYpuTeNkkgMnh58V42C9+2T+6hRpV5lnxPLbW3q7JtT88eJlr47XuRG0HZCQ8yjSU2FLr1eRkJxQE2dg6yyn0e1jaJ6w1Y0LXyPn1WudfWO9f7geO1wEE9Hz7/jmPUp9/AjIhDn3lK/8scR3a+aBoVOi5Ot0RGLM3Vc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240735; c=relaxed/simple;
	bh=TWbcTLqV12K8Lj+m0MNkO5eOAnFVq9QXWT1NuS5//+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8H5xV3XbrRmeEyc12xgznijc0uoKFPIFFpbJ3nM+3V21qQ2TKUbFRZ/n7+OZj8esMEqL9tlsCxQqKw3zjYrnA6m5V64Z1BY6udiKoLQowm4kRD31iCdbBEBGr7qC4IjCkVJZ0xcVhDEM/CA82krfVtpwIF5qpC0iK/pIg+iVtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNBMwalO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNBMwalO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C006EC4CED6;
	Tue,  3 Dec 2024 15:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240735;
	bh=TWbcTLqV12K8Lj+m0MNkO5eOAnFVq9QXWT1NuS5//+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNBMwalOQfHHujZpjUctDpmg16hZtWFfrgw9Tnn5j6f2Qbk33RtzECOAT0ax3jltZ
	 A3qrf1fm7xBK3NXW0WwjSgpnYzCIJf+cUvWbwXf3NIHs5q6jBkwE3cbjy41wCQwpBy
	 dEkfy+HmpuCB7BWRfG0ITwtRFGYvf1ZSezfyYaUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/826] libbpf: Fix output .symtab byte-order during linking
Date: Tue,  3 Dec 2024 15:39:07 +0100
Message-ID: <20241203144752.321383354@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e0005c6ade88a..6985ab0f1ca9e 100644
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



