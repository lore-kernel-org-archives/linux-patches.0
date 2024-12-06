Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2B91FA279;
	Fri,  6 Dec 2024 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497074; cv=none; b=UIdo7VD/Vj33QgbE0fhBSfa95SxWeYGCWeaOO+V3Qovp7GoOlBKaWaSs8s6adg3LCU//tfhMcsbq8jFmhepC5w+mV5E9hE4sdQtTX0V6VDhx3idfUbpYCs4sF6djrYlBPAlwbu/ZmXrp4nTKfXCDgAsbGhdQ6VLIEhlgPXc3RPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497074; c=relaxed/simple;
	bh=0fJ48oRbW10nfnMO6MaEZIaSkoITF/9XU8ztRnUjmgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+p3eJtjTsQqz0JrbnvwZjmgsTmWluVWOepEbM35FSP0qYuGqWae0u8uqCdY4gM7BgIbpEjPVoADeqn7ytCnqDtn5gBtxzBVnA5c2cGZswwJ5ckoSRNFhJXTkrJpXZJgmw+dGaqIeViNBUg7rUHWcjDFCrL8buceIBkth1RP1GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZ2XPtI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZ2XPtI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F75AC4CED1;
	Fri,  6 Dec 2024 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497073;
	bh=0fJ48oRbW10nfnMO6MaEZIaSkoITF/9XU8ztRnUjmgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZ2XPtI6EMvXVIqr8RGK1IT8W6PWbV2Cu2nHYwchAXHZ+QlfGEOlyZz3zwroni6D/
	 yxCV2zS+dmcIKcVoTr5GyFz/GAwrDq33lFPxeJAQvu7P9CK+0WFby/eq/F95bvlVJ7
	 RSVMV/y74Io2rXCQTkovk8E5XbB2dL5/DgKgfRvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/676] libbpf: Fix output .symtab byte-order during linking
Date: Fri,  6 Dec 2024 15:30:06 +0100
Message-ID: <20241206143700.653128201@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b311bb91f672e..88cc7236f1220 100644
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



