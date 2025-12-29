Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4943321D9;
	Mon, 29 Dec 2025 16:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025854; cv=none; b=UXB6MQTbQkBxK82VVm4FpiDjRbw3GqrnOnUkxRvnGhbr5jREJtymNyuRB6xsjUfQKus5+RHupJzSbOKkLSq2Ks/7YmPTW6E1U3x7Hk8WHG1+yxzxhE1Cdl6XGG1a+9RFvoKY1Dn6mi/UWNkB081xsKfX19pmIbLp8EbLwGXWaOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025854; c=relaxed/simple;
	bh=wHS6+THisiIIOgFgq4n9sKCd29zHdNB1yP0wVn6WfpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrKNI8P7dIjnN2O+JdroAklkKvBOk89TX0jNIq8nIAsL4S/Fzwh8OV6LxH9r8/N1xLx+7mI+oUWec66MLeZ0v5qduxoGDWYOQ8ysujwGOFq2rRo0KpwEOuyb6o2mAKsFdj3HNEoo3RbVxIpKZD9RR9gx6wKFasvI2c69gMaetmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/61Vs4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/61Vs4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFED2C4CEF7;
	Mon, 29 Dec 2025 16:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025854;
	bh=wHS6+THisiIIOgFgq4n9sKCd29zHdNB1yP0wVn6WfpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/61Vs4BSW33cQ6pTYgOnxot3x3/5Az/XIy9lImcQ0gAy+Nglxn3oVDY6q8OSK2Wn
	 YS6/90gGCZZYYQYiPE1Ge0f8TwQDtYJBk3e5aCmPAh6NiSkfgjwPThiGUfrIAm09bp
	 f9mQltKOEBWcDUoqejVBzCzWFewltkkAeitShSzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Khrustalev <Yury.Khrustalev@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Yury Khrustalev <yury.khrustalev@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 361/430] arm64/gcs: Flush the GCS locking state on exec
Date: Mon, 29 Dec 2025 17:12:43 +0100
Message-ID: <20251229160737.614529339@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 98a97bf41528ef738b06eb07ec2b2eb1cfde6ce6 upstream.

When we exec a new task we forget to flush the set of locked GCS mode bits.
Since we do flush the rest of the state this means that if GCS is locked
the new task will be unable to enable GCS, it will be locked as being
disabled. Add the expected flush.

Fixes: fc84bc5378a8 ("arm64/gcs: Context switch GCS state for EL0")
Cc: <stable@vger.kernel.org> # 6.13.x
Reported-by: Yury Khrustalev <Yury.Khrustalev@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Tested-by: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/process.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -292,6 +292,7 @@ static void flush_gcs(void)
 	current->thread.gcs_base = 0;
 	current->thread.gcs_size = 0;
 	current->thread.gcs_el0_mode = 0;
+	current->thread.gcs_el0_locked = 0;
 	write_sysreg_s(GCSCRE0_EL1_nTR, SYS_GCSCRE0_EL1);
 	write_sysreg_s(0, SYS_GCSPR_EL0);
 }


