Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB0E2114;
	Tue, 23 Jan 2024 02:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975801; cv=none; b=ru1AzjN3BaZezias3sK7j1qDcH94jmb9QzU0M3zyk3MLPlgRUThtIp8uprkm/BCJyzCN18JNxD4pG5fZwxiq5qUV4lUcYAkeQpnFvj0r0IMFM25gY5oMJ8BQmaxA68tZeJ/bLJ0YKzm9l5ahtVAPIY4lIdGuiFlhVUqJa/yw9/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975801; c=relaxed/simple;
	bh=LJAfSZjEuriNuJhpYqFDtRQgaieivjR2nic9tA+nxIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlbvX1c+oQ8dwOqrIXsiLwD+K5bo1dcYv40Mxv3piZfZyWFAnOFzdt7Co0Gt/d/zNEOgUDXYZEHdLiP6aFye/yDpfyiSxtoGJecDpbhsM4O1/qd4J5k66k1y4Hny0wdAnylDJrYC4HGZPJcLGqMNp2x2D1EKK0GMFRAVG8kroIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9vfdN19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9vfdN19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5712CC433F1;
	Tue, 23 Jan 2024 02:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975801;
	bh=LJAfSZjEuriNuJhpYqFDtRQgaieivjR2nic9tA+nxIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9vfdN19Oy5xS0ddqxpUGeWsasSd9wb7MTe7Q+wm3VCxbHqWoa/vbaoGBWto/Qef1
	 CFlMhQcsbQP5kOg9wlGpa9nU0CqqXwT9RdtVm2Wlej60EADTjD0ECZM5c7M4Or+at4
	 BsMVVuZzUTxhMXnZqzmsteZHtby6DnoNrs111xKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+afb726d49f84c8d95ee1@syzkaller.appspotmail.com,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 583/583] riscv: Fix wrong usage of lm_alias() when splitting a huge linear mapping
Date: Mon, 22 Jan 2024 16:00:34 -0800
Message-ID: <20240122235830.065122899@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit c29fc621e1a49949a14c7fa031dd4760087bfb29 upstream.

lm_alias() can only be used on kernel mappings since it explicitly uses
__pa_symbol(), so simply fix this by checking where the address belongs
to before.

Fixes: 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX() by splitting huge linear mappings")
Reported-by: syzbot+afb726d49f84c8d95ee1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-riscv/000000000000620dd0060c02c5e1@google.com/
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20231212195400.128457-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/pageattr.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -305,8 +305,13 @@ static int __set_memory(unsigned long ad
 				goto unlock;
 		}
 	} else if (is_kernel_mapping(start) || is_linear_mapping(start)) {
-		lm_start = (unsigned long)lm_alias(start);
-		lm_end = (unsigned long)lm_alias(end);
+		if (is_kernel_mapping(start)) {
+			lm_start = (unsigned long)lm_alias(start);
+			lm_end = (unsigned long)lm_alias(end);
+		} else {
+			lm_start = start;
+			lm_end = end;
+		}
 
 		ret = split_linear_mapping(lm_start, lm_end);
 		if (ret)


