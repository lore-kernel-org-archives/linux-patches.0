Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7CD33B6CC;
	Tue, 12 May 2026 18:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609581; cv=none; b=qusG/6AJ9Gz+aBzHwZtnywTZRA8Qv9mDAkt/9E6RVoWFsZO21NlZHZCvjByluLKslSheDKGzRbFyUumGvAHiJ/2B+7CVAgGUZZ/yq8xSZmmJvck1w3jU43mMWoXPFLHaDPeaBnkDfHtSg9F0Os6ANbv3fcckrCUy1D6z7do4Cqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609581; c=relaxed/simple;
	bh=Epy4zm65tUQbG/pyiF/AT+y47c0qMwcy4f33Bn4op8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDlLi/NDZSqRRy9XSei/+ZxnGFIEdOrLDVI4Uon88yU9S4s1wpLD6sej++8CatlLAebTJf78i3ZZxBMCP2Be6zH/IhwVRWqeBwUF31W+VdmxD1FgkOvEo2gfdbLTorRPkkKAwk1Va8ARODSqleikHlNloASMj9P8731zQ9ZN6aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HZj+H4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HZj+H4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774F6C2BCF5;
	Tue, 12 May 2026 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609581;
	bh=Epy4zm65tUQbG/pyiF/AT+y47c0qMwcy4f33Bn4op8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HZj+H4kKCK0IIZXS/mLqS7aM5yB+AkW0Hm751L10/0uZ9Z7T+rLTzd8b0qNuoVdu
	 Qx7G11Lj8akgMcPa/qq1mZuV9jOmokiDEzOB+xZ9rrjPXugwX/W26ObMbQlLisDoO1
	 x+qJJ++MopPPu6r6KAe26f8xWUnol2uGdGpl3FgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 7.0 209/307] s390/debug: Reject zero-length input before trimming a newline
Date: Tue, 12 May 2026 19:40:04 +0200
Message-ID: <20260512173944.528971997@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit c366a7b5ed7564e41345c380285bd3f6cb98971b upstream.

debug_get_user_string() duplicates the userspace buffer with
memdup_user_nul() and then unconditionally looks at buffer[user_len - 1]
to strip a trailing newline.

A zero-length write reaches this helper unchanged, so the newline trim
reads before the start of the allocated buffer.

Reject empty writes before accessing the last input byte.

Fixes: 66a464dbc8e0 ("[PATCH] s390: debug feature changes")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20260417073530.96002-1-pengpeng@iscas.ac.cn
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/debug.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -1414,6 +1414,9 @@ static inline char *debug_get_user_strin
 {
 	char *buffer;
 
+	if (!user_len)
+		return ERR_PTR(-EINVAL);
+
 	buffer = memdup_user_nul(user_buf, user_len);
 	if (IS_ERR(buffer))
 		return buffer;


