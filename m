Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458704EDCA0;
	Thu, 17 Sep 2026 16:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664145; cv=none; b=GmA9T/Vgc9GKxIonBqpPhxcrz+tnys5KB6+cve1gtYxswlv+VfdS4fh44MXjsdnpPPf0i27giWF1sIHB+vDGDB2cLgD4kyhbEmrlQrRWjpk14u8ba3pnosGwRVjMJE8/9couDGxzkAtaJfB7Y0EiYNmpwxYtViF4abT939lOpm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664145; c=relaxed/simple;
	bh=WnStSYwQbMufmiow5GJ+KiWcXB+wdIoGg3nuChVwkfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6rSjvls6zuMVHQK8eugX7n53f9sHmM/ZECs4KQEjZLPa2KMnuuBReOcyQZvjIicVNmIfj04nMMxNPltV4vPebLNobzBqCQJ34B+Lz9FUHQBX3C8oxL1FzibgMZzM7IJP0Ml74FHvhcQ41fNl+pLCi3Q+qcvtn1h3gS081sa6uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLbmurDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLbmurDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989821F000FF;
	Thu, 17 Sep 2026 16:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664144;
	bh=hsszpGGPp2qaRt6blumFVqGoGCDNdvs9+kAAW4qY27M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLbmurDyyaMhciq5QIDcMN59sj71yMUhbUwzYRL4GjGpm1M+0smZ8NNVijTRlUq7v
	 n/HnqFqJKF8v7Crvm+DeaBGsJKsuJ1GbyTZMEQoPw4B3LW5AtekynE3vlEDDDkF7jd
	 oqolbRhbkh9SdG1Tj+fidVAHYiEDPbGdPYU18js4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0274/1250] libbpf: Also reset {insn,data}_cur on realloc failure
Date: Thu, 17 Sep 2026 16:01:09 +0100
Message-ID: <20260917151559.564805600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d2f7bd066ed492aeaf82864fbf1f06770f9d9f9d ]

realloc_insn_buf() as well as realloc_data_buf() free and NULL
gen->insn_start / gen->data_start on -ENOMEM but leave gen->insn_cur /
gen->data_cur pointing into the old, freed buffer. Just reset the
cursors to NULL alongside the base pointers so the freed state is
coherent.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260529094119.307264-3-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index d41defa1936d3..4e2d25e024af4 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -63,6 +63,7 @@ static int realloc_insn_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->insn_start);
 		gen->insn_start = NULL;
+		gen->insn_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->insn_start = insn_start;
@@ -86,6 +87,7 @@ static int realloc_data_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->data_start);
 		gen->data_start = NULL;
+		gen->data_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->data_start = data_start;
-- 
2.53.0



