Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C88C2288C2;
	Thu, 12 Dec 2024 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019202; cv=none; b=Afpsb92HYSF1QPBth6NHYfQ94miCG62AoYGIWnPINPoTC/z7nuv1vlPwAOcLSZdyjNktdO/LDnJvn+KSQwI2AmH5e+mF0M4djZ9nq5HOQ1icMFhwcY9ku2teAlBgu9/UF9WScUsFGzUDB7mSlt3xJYaH5LaHmOP70PGky+/jT3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019202; c=relaxed/simple;
	bh=OdSHhfloaplDCHfL2Qyrve5IZk0Noe9iIal7wsNiIFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeLpYR+SxHvJfJwUdTPL2C9zQJX4I4UEsGCz7eYTYYanwD8tzZWaGeYCWpzyKOzpnOsB43RAQVw/OwkGZPaoMnq2oZJx1MCtlCORD5XDdfxGoDhphArDq6gVJV8p/czEgwLh3pdgtAXwFhUIIxTIiv7N+4sqcrizhfhXaHRAR6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/1Yxd1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/1Yxd1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F61CC4CECE;
	Thu, 12 Dec 2024 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019202;
	bh=OdSHhfloaplDCHfL2Qyrve5IZk0Noe9iIal7wsNiIFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/1Yxd1dLnpoLwTTDTj34RV4ArVWv+11Uv1CtHXJGvjrMS9K8RFm25/6Fl1CzIcys
	 PXACUTfbZ9XAAjboyRZHSve6+ax2owzMJlgQx19tT4wqVacUCSlvZJU8MMJrYXfYU3
	 CaLBd3W6RY1toherNPmC1uywHwAZRoneW/G1IPSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/772] libbpf: Fix output .symtab byte-order during linking
Date: Thu, 12 Dec 2024 15:51:30 +0100
Message-ID: <20241212144355.927793224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a7cb830bff14..7d28f21b007fc 100644
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



