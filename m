Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FDC13B7A3;
	Wed, 17 Sep 2025 12:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112626; cv=none; b=GamwVzaeBaG9MKALsTfreQkZtV0YVut/n4hlNdEeyfj+QGjRCJqvJqR8DMEtjiCoupi4ZUPwj3atJtlawsrnIyzBF6dqfoS0keGA41MSOr0YCaWHcWJbPVs7JsJD9JSKh6Vt5gPKFToy5om7JTQEKFqI39QPIsl1x6yCyvqZpLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112626; c=relaxed/simple;
	bh=3m7mrtfYt8kBBAdLBxSVrDSgJOL8kbLtaMjf1yHIQcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWmxgobxswnU2l3+rb85SKOniVTTe2rRFQQaQHw9SxXABxFHcL7YWEnjD/CAbDyZeprhmMvnhP+N3sIxPGsmo1uON4REuLnH4RWZ7/vmU81g8DGk4gKrgbejp9srOf6mj0auDGlcB0XLNm4gIq0DXky19zKDGngDqD0lZkBU0ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pK/Kps98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pK/Kps98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6E3C4CEF0;
	Wed, 17 Sep 2025 12:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112626;
	bh=3m7mrtfYt8kBBAdLBxSVrDSgJOL8kbLtaMjf1yHIQcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pK/Kps983E/E0ufXHW/yM/rfSs8v1ozO66q8obooeTWWN8+Lo0u/lRxx1OFldx35J
	 EdmC2c3KusSdnC43vzMRZgAVvymjTUwqMfPyAGnwyZ/8ALqUcIXx9bSfGCcgYfk3OI
	 fEr6QZedGzNLnGz/627Q8pMvLoImdevp19ZFoMX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 027/189] ftrace/samples: Fix function size computation
Date: Wed, 17 Sep 2025 14:32:17 +0200
Message-ID: <20250917123352.518351124@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit 80d03a40837a9b26750a25122b906c052cc846c9 ]

In my_tramp1 function .size directive was placed above
ASM_RET instruction, leading to a wrong function size.

Link: https://lore.kernel.org/aK3d7vxNcO52kEmg@vova-pc
Fixes: 9d907f1ae80b ("samples/ftrace: Fix asm function ELF annotations")
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/ftrace/ftrace-direct-modify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/ftrace/ftrace-direct-modify.c b/samples/ftrace/ftrace-direct-modify.c
index cfea7a38befb0..da3a9f2091f55 100644
--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -75,8 +75,8 @@ asm (
 	CALL_DEPTH_ACCOUNT
 "	call my_direct_func1\n"
 "	leave\n"
-"	.size		my_tramp1, .-my_tramp1\n"
 	ASM_RET
+"	.size		my_tramp1, .-my_tramp1\n"
 
 "	.type		my_tramp2, @function\n"
 "	.globl		my_tramp2\n"
-- 
2.51.0



