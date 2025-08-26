Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2121F1F55FA;
	Tue, 26 Aug 2025 12:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212860; cv=none; b=scyNNtrHO400eioras8FW4OYU/CqTpOzUwPZt9aFT9p843YKAarPXUk8JKDcMwMIWem+PHpNZHmK1FKkk/vIaY+J/w6T5Q5w1HH71Rxkzxnw0UxB6yoIKrGUMZ+lpH+4JnI9vyZwyRx8P9mWkA5Vs6VfP5leSvgAiyAK2ruw2TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212860; c=relaxed/simple;
	bh=W5GIl9ikaXQg3oyuz3yimndmQUuUZO603Blb12ZQWUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1JdU16uo2K4tJaoPCo8n2FQ5DzmkM2eRN72c4eMD2vklTv0JVQdBUTZAY0k0Wh0KKYHugcOfQcyy5x4GVMB1VGX2xv/EyIMrrd8qyf9EEOPiaW55BbTX6avy2FMZ1Q6cMPQUYqXOc+mPC9bktm3flPd6vR7PzeGXV1YoWkCQw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eD3Z0hW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eD3Z0hW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A341AC16AAE;
	Tue, 26 Aug 2025 12:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212860;
	bh=W5GIl9ikaXQg3oyuz3yimndmQUuUZO603Blb12ZQWUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eD3Z0hW6MUzaoP21h6c7D8I/FvKx3YDAJ3elKfhzGBoA6U7rO6IBm7a1t0IsjROE0
	 S67SDMMSRfpdRRJkazwrb3JBP3Bk6ONu6LscBP+EKp80wuzDJyPMpEwO4xHvFoBn6M
	 vEuTVS0jNjZ0k0Yzf81AYmpylqiAjzKeSgansDp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/587] x86/bugs: Avoid warning when overriding return thunk
Date: Tue, 26 Aug 2025 13:04:31 +0200
Message-ID: <20250826110956.062880229@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 9f85fdb9fc5a1bd308a10a0a7d7e34f2712ba58b ]

The purpose of the warning is to prevent an unexpected change to the return
thunk mitigation. However, there are legitimate cases where the return
thunk is intentionally set more than once. For example, ITS and SRSO both
can set the return thunk after retbleed has set it. In both the cases
retbleed is still mitigated.

Replace the warning with an info about the active return thunk.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250611-eibrs-fix-v4-3-5ff86cac6c61@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c4d5ac99c6af..332c6f24280d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -71,10 +71,9 @@ void (*x86_return_thunk)(void) __ro_after_init = __x86_return_thunk;
 
 static void __init set_return_thunk(void *thunk)
 {
-	if (x86_return_thunk != __x86_return_thunk)
-		pr_warn("x86/bugs: return thunk changed\n");
-
 	x86_return_thunk = thunk;
+
+	pr_info("active return thunk: %ps\n", thunk);
 }
 
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
-- 
2.39.5



