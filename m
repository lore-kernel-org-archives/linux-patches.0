Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508D4223E80;
	Thu, 12 Dec 2024 16:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020995; cv=none; b=K3P7XFtm/0Amz0eXkMYMQlyjklKAg7vtBH9m0HYFI3YQpbkksci9JbrXMixjkTYH4yjnmMILrejw2YLoRYxxqbTFSjj3GytY9/WbO1S/2tu6rhDLy2SXgUB2QwjNZcrJSZE714FzCe+ZrcIrXlYAzXIT8Y77EWO3i8QXFO4WLtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020995; c=relaxed/simple;
	bh=lDZtU9ECmeJaMRAKk5T/gyS7IHBzONX6vkeF8lh2JDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAOkf2QBoXqO5nCCxB05apkColuwfPE3OR92r9K8snBJM2N2SjtID8oMNDxBrTAfTon1RgKbobAffbp7EPwCKeQTMKPjA/IvhkxMpP4Dp97rfsp/FyEz63XRyVBpLG9HvTeJCNje/0I8FbaifDLs1zTESoOugtLlG667AKcxJ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvyBjWXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvyBjWXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ACBC4CECE;
	Thu, 12 Dec 2024 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020995;
	bh=lDZtU9ECmeJaMRAKk5T/gyS7IHBzONX6vkeF8lh2JDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvyBjWXUMIg0+4b8SaPE8T9z5yaclaq/sHKlA0Mrkz2vKPoHUmsCFjhWra5Vw1ViP
	 wPZ92H2SAX5Oke0kssPYIwWss5m2995huYpOREn9fe12fvqyRDpf7WxsbVsZOb1JqF
	 pozku/6oF0TNkZK9d8EW7G0NiJ5ui1+n23Jkc/js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Mohammadi <amiremohamadi@yahoo.com>,
	Quentin Monnet <qmo@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 587/772] bpftool: fix potential NULL pointer dereferencing in prog_dump()
Date: Thu, 12 Dec 2024 15:58:52 +0100
Message-ID: <20241212144414.195109509@linuxfoundation.org>
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

From: Amir Mohammadi <amirmohammadi1999.am@gmail.com>

[ Upstream commit ef3ba8c258ee368a5343fa9329df85b4bcb9e8b5 ]

A NULL pointer dereference could occur if ksyms
is not properly checked before usage in the prog_dump() function.

Fixes: b053b439b72a ("bpf: libbpf: bpftool: Print bpf_line_info during prog dump")
Signed-off-by: Amir Mohammadi <amiremohamadi@yahoo.com>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20241121083413.7214-1-amiremohamadi@yahoo.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 801e564b055a0..1c3dc1dae23f6 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -820,11 +820,18 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 					printf("%s:\n", sym_name);
 				}
 
-				if (disasm_print_insn(img, lens[i], opcodes,
-						      name, disasm_opt, btf,
-						      prog_linfo, ksyms[i], i,
-						      linum))
-					goto exit_free;
+				if (ksyms) {
+					if (disasm_print_insn(img, lens[i], opcodes,
+							      name, disasm_opt, btf,
+							      prog_linfo, ksyms[i], i,
+							      linum))
+						goto exit_free;
+				} else {
+					if (disasm_print_insn(img, lens[i], opcodes,
+							      name, disasm_opt, btf,
+							      NULL, 0, 0, false))
+						goto exit_free;
+				}
 
 				img += lens[i];
 
-- 
2.43.0



