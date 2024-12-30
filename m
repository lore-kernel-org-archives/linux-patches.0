Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AAB15E8B;
	Mon, 30 Dec 2024 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574257; cv=none; b=a0U6K5hD81bVkROP7y3l665pw0ohafWTu2iUmtcj26X5/eAvxP+28mWX37s07E5TgHi5yhxboltPSnT0DZNCU9W7jIYhBSYpMu1AdTAeVFnfb8AU+ezhPr69w7L6V8IDVO+KAbtWoo48n7Q6+HFn4ZkG8pPEMPyKxGdjSaZQp5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574257; c=relaxed/simple;
	bh=w1CJyqOlAW48HwMZSrf5m5Ji5d89fNB5/Z0f0AummUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id1foYentW38f5hPFImHGwFO8LxWDb7bt09vm4zj7AvdBmuNpFrzXAIuf3hyVCgg00syR5WbC/h6NM/THmxpuhOsEY5hqtuYBauqB0ALg2KhE6T0eS5GYnbQtL53kI2e/0UvdD/1sD35NcO5WKx8+kMGcbX68Ccmp5j9vzzBRdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/3AuRIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/3AuRIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6BAC4CED2;
	Mon, 30 Dec 2024 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574256;
	bh=w1CJyqOlAW48HwMZSrf5m5Ji5d89fNB5/Z0f0AummUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/3AuRIXDbi7s4diwt805gfx3gfnw/pd8cgHXu8KqqZM5SDmaI5IWFTXEI6m0q5V1
	 6hOE+TxuBeAPp262bZZwEM3nNqu/VUJO4b1NDqrqk4HgO4AdK7+SODuMph2adou13S
	 RlRZ4xE+1Hd8G4cJ84eWFg8YXsSvlCEn16XG+a7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chenchangcheng <chenchangcheng@kylinos.cn>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/114] objtool: Add bch2_trans_unlocked_error() to bcachefs noreturns
Date: Mon, 30 Dec 2024 16:43:18 +0100
Message-ID: <20241230154221.212843888@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: chenchangcheng <ccc194101@163.com>

[ Upstream commit 31ad36a271290648e7c2288a03d7b933d20254d6 ]

Fix the following objtool warning during build time:

    fs/bcachefs/btree_trans_commit.o: warning: objtool: bch2_trans_commit_write_locked.isra.0() falls through to next function do_bch2_trans_commit.isra.0()
    fs/bcachefs/btree_trans_commit.o: warning: objtool: .text: unexpected end of section
......
    fs/bcachefs/btree_update.o: warning: objtool: bch2_trans_update_get_key_cache() falls through to next function flush_new_cached_update()
    fs/bcachefs/btree_update.o: warning: objtool: flush_new_cached_update() falls through to next function bch2_trans_update_by_path()

bch2_trans_unlocked_error() is an Obviously Correct (tm) panic() wrapper,
add it to the list of known noreturns.

[ mingo: Improved the changelog ]

Fixes: fd104e2967b7 ("bcachefs: bch2_trans_verify_not_unlocked()")
Signed-off-by: chenchangcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20241220074847.3418134-1-ccc194101@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/noreturns.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/noreturns.h b/tools/objtool/noreturns.h
index e7da92489167..f98dc0e1c99c 100644
--- a/tools/objtool/noreturns.h
+++ b/tools/objtool/noreturns.h
@@ -20,6 +20,7 @@ NORETURN(__x64_sys_exit_group)
 NORETURN(arch_cpu_idle_dead)
 NORETURN(bch2_trans_in_restart_error)
 NORETURN(bch2_trans_restart_error)
+NORETURN(bch2_trans_unlocked_error)
 NORETURN(cpu_bringup_and_idle)
 NORETURN(cpu_startup_entry)
 NORETURN(do_exit)
-- 
2.39.5



