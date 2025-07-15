Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80B42E7181;
	Tue, 15 Jul 2025 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586017; cv=none; b=a9naps0KYOZa7HLedXqyL/NEKAvC09Y/YbbQd5NU7j3K2SyGMYTwT0U/G3/D0TIGAvJn3WCTDUDgZSmj6gFtEWOYL+OMP0gfbdg1kthODcU51rKKrZN1jWZcWHf7vcI7rnsaNlNwa8fX7oBRNiR4mBorqfX7CsZLyMKEhqXw5Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586017; c=relaxed/simple;
	bh=E4ncmwhhyrWfj1yT4sqJurHHaX8JdXhRj2BMcuARJC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyxuzJs6clox4Acm4kS3GdDN5CcfGi0tJutO+o3cOEI5iAfsJUGNereopfaKdtiHKp0tBi0dgGOsE0fjUFd54f9xYhBLTe5x7FBkUiCryZkyTBr+b3kA2ZRSSAKNJjZVUrgQN1YsYOVvs8okFh2PtUzjHTx+HCMq4s4RhaELCoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxP+NnvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxP+NnvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA34C4CEE3;
	Tue, 15 Jul 2025 13:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586017;
	bh=E4ncmwhhyrWfj1yT4sqJurHHaX8JdXhRj2BMcuARJC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxP+NnvBpcJmr7sFu6S/B+b5PYosmteAeOJWWH/JTf3dSdYbOop5WpDNIqGt066oX
	 Y7hObGitjc97jMyaPpz7hVIVCZx+mhIzbBh8z6E3v21t2zbKeja59TNX48k5AcqpEw
	 7VcLm+HE0kOsheVB+NvMAkcQbgE/PZttkM/ncXMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/109] io_uring: make fallocate be hashed work
Date: Tue, 15 Jul 2025 15:13:50 +0200
Message-ID: <20250715130802.648083769@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fengnan Chang <changfengnan@bytedance.com>

[ Upstream commit 88a80066af1617fab444776135d840467414beb6 ]

Like ftruncate and write, fallocate operations on the same file cannot
be executed in parallel, so it is better to make fallocate be hashed
work.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Link: https://lore.kernel.org/r/20250623110218.61490-1-changfengnan@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/opdef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3b9c6489b8b6d..2d0a7db940fdb 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -202,6 +202,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
+		.hash_reg_file          = 1,
 		.prep			= io_fallocate_prep,
 		.issue			= io_fallocate,
 	},
-- 
2.39.5



