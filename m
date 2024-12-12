Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B4D215764;
	Thu, 12 Dec 2024 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022156; cv=none; b=k1ZzcZupUeZqDmbMK3YTcZ8uJ7jYB1Jx+M+iX3VA0KiBduBIpIbJniSuxe8l1hHaYaXwlrBnniZBwdZMEbu7y5WoD5ucLD+QOWlnhnzHLX0MyaG8+/swn1gso3ens3YCSbj7SJwx5zMYEMWDvErZvGcpaSkG3WYFyimxMuwzD0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022156; c=relaxed/simple;
	bh=B91lwocSpDfF6JN/47P6fYhxWvhHF3Okyd130h0q6o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2cqEgee00G6IflZo39o+pJMOAg0OrxpdTrEaQn56sUngIRjup1FR3SmHeD75pNN6a7AkcbsCDphwP18BOW0gMf+iW8CaeXMDyTaAz8MiOfeAEBUmU6UxR7mjgLAOwDOOZlusS5Rx4IWUkwios/3y8Q3NLe4ELESetsHQVYuRW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guFI5mRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guFI5mRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D92C4CECE;
	Thu, 12 Dec 2024 16:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022156;
	bh=B91lwocSpDfF6JN/47P6fYhxWvhHF3Okyd130h0q6o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guFI5mRxsI3wDvhGkpuAMWQOGx4JJ4FIRnHlpxL9GRt/i7A3GazRmuG/5gRnxE4/h
	 g1HYU7Qp5AvS/nL5/Pg97qWepFJpyDX0EooXCOJMIE+GoxRR564fhOAbWt004yM4Ri
	 lwB0qUGRn3yfeBQeZkNRtPIzYgr8R7UQs3i+e2X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/565] libbpf: Fix output .symtab byte-order during linking
Date: Thu, 12 Dec 2024 15:55:59 +0100
Message-ID: <20241212144317.960273788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bfe0c30841b9b..8907d4238818c 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -397,6 +397,8 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
 		pr_warn_elf("failed to create SYMTAB data");
 		return -EINVAL;
 	}
+	/* Ensure libelf translates byte-order of symbol records */
+	sec->data->d_type = ELF_T_SYM;
 
 	str_off = strset__add_str(linker->strtab_strs, sec->sec_name);
 	if (str_off < 0)
-- 
2.43.0



