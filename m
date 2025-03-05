Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1C52528E4;
	Wed,  5 Mar 2025 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198780; cv=none; b=IHm1MheEvlH0owtZxNrMdQK0hLUW8lXkvEX7kS935MgqUUOwd16ds3UNj6BsZ7hFn3dN5a+2wH9Nka0VSrEv+Hxrv+yhvNnKX1Sukoq8EGrlc2CPDCrVSCGW+IaepHV9UHwQP2kHiMjdjJ8/B5hRubHqCMlG6zGGPIXmhFALwqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198780; c=relaxed/simple;
	bh=1fKiGXu0QfU/82/XG3rZR5Um2q7mnKqPjiSUB9dAThM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz7cQo7o4Syq0jK7p8POrewc18xLQjxIknJHoEnvgaruw2nBAbe1HwWQF2izlTETiB1qcQ6Cq0DDWqXnxcKIptOw9l6cqdSl8Y2Ta8sRFdkP59RnFi80VynokYYIoSohPXNa2ugsU/0eI+507UERR1odj/Lfzp0YuaUmNhUbBy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6fS8QPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6fS8QPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BBAC4CED1;
	Wed,  5 Mar 2025 18:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198780;
	bh=1fKiGXu0QfU/82/XG3rZR5Um2q7mnKqPjiSUB9dAThM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6fS8QPXVhgx8RJkAuujM3RDcI4VQ9JUVH54fKAafZehuZVNjupD2PP42VOEqphrp
	 IYUPtX3crm0T+TpE3wl0xj/kLGXAYp4mqbK3+pomEpj4a8M/+3PQUfB8BZ3ZWcI24I
	 uxJFWVwIb5MHdD9rVLaFc4pJISoksC6pva5lMGUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Zong Li <zong.li@sifive.com>,
	Andy Chiu <AndybnAC@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.13 145/157] riscv: signal: fix signal frame size
Date: Wed,  5 Mar 2025 18:49:41 +0100
Message-ID: <20250305174511.124514150@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

commit aa49bc2ca8524186ceb0811c23a7f00c3dea6987 upstream.

The signal context of certain RISC-V extensions will be appended after
struct __riscv_extra_ext_header, which already includes an empty context
header. Therefore, there is no need to preserve a separate hdr for the
END of signal context.

Fixes: 8ee0b41898fa ("riscv: signal: Add sigcontext save/restore for vector")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Andy Chiu <AndybnAC@gmail.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241220083926.19453-2-yongxuan.wang@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/signal.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -215,12 +215,6 @@ static size_t get_rt_frame_size(bool cal
 		if (cal_all || riscv_v_vstate_query(task_pt_regs(current)))
 			total_context_size += riscv_v_sc_size;
 	}
-	/*
-	 * Preserved a __riscv_ctx_hdr for END signal context header if an
-	 * extension uses __riscv_extra_ext_header
-	 */
-	if (total_context_size)
-		total_context_size += sizeof(struct __riscv_ctx_hdr);
 
 	frame_size += total_context_size;
 


