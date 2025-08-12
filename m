Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C092FF176;
	Tue, 12 Aug 2025 19:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025879; cv=none; b=qOnGmCaEOwVrFYGYSzI0IYDfGPgO1ZMBPspVx5sM8EDLpV3EoWNSxyPEhcbs9JY3PtmxkON8T1R8WoYgbLPHFAKiF7D7bkD9F+PERjpLxdIzilbybWNzUPywDr8kTLzNNRHAxrKbEgbS23KBuJ3HsFvi8MTkaBgMexk2mxQr+m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025879; c=relaxed/simple;
	bh=8Qlasu3nFRJEs3y73bmANw3AcTbLvN79VR7t268vo14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4UUD2sCvo/WU8FVewgzUT4l78naWlX8AuBiFoWGAZVfcnE0XPp4+uk1vSj4upkZkA0sSAYO9jCym3aCd3yBnZQA9rYhoPIapYXstckFlcyG86jEc5FMYVK8PciAYEMNEpIXm48YMS+zKz8C1mpUW3kq3VSAUa5u2gU/fmIWsPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7JNTGhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7JNTGhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B291C4CEFB;
	Tue, 12 Aug 2025 19:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025879;
	bh=8Qlasu3nFRJEs3y73bmANw3AcTbLvN79VR7t268vo14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7JNTGhpQMF+w1DkvKAlREXVXP1XwdAbTUtmgi356eignjxwZ1tHMdl6foZPEssZ9
	 CmKL4w7IfjDIm/8Yl/mgONyRX1+ZC9/7eHgrFIHeMNzxRGDo3v0nGtenFu74iMXsJH
	 5XQeRP6VZd/mAnOHh9hNDKO7a7GP7enJoJau8Brw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 171/480] selftests/bpf: fix implementation of smp_mb()
Date: Tue, 12 Aug 2025 19:46:19 +0200
Message-ID: <20250812174404.569705291@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 0769857a07b4451a1dc1c3ad1f1c86a6f4ce136a ]

As BPF doesn't include any barrier instructions, smp_mb() is implemented
by doing a dummy value returning atomic operation. Such an operation
acts a full barrier as enforced by LKMM and also by the work in progress
BPF memory model.

If the returned value is not used, clang[1] can optimize the value
returning atomic instruction in to a normal atomic instruction which
provides no ordering guarantees.

Mark the variable as volatile so the above optimization is never
performed and smp_mb() works as expected.

[1] https://godbolt.org/z/qzze7bG6z

Fixes: 88d706ba7cc5 ("selftests/bpf: Introduce arena spin lock")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20250710175434.18829-2-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bpf_atomic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/bpf_atomic.h b/tools/testing/selftests/bpf/bpf_atomic.h
index a9674e544322..c550e5711967 100644
--- a/tools/testing/selftests/bpf/bpf_atomic.h
+++ b/tools/testing/selftests/bpf/bpf_atomic.h
@@ -61,7 +61,7 @@ extern bool CONFIG_X86_64 __kconfig __weak;
 
 #define smp_mb()                                 \
 	({                                       \
-		unsigned long __val;             \
+		volatile unsigned long __val;    \
 		__sync_fetch_and_add(&__val, 0); \
 	})
 
-- 
2.39.5



