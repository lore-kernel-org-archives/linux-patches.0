Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505EF30BB80;
	Tue, 12 May 2026 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608683; cv=none; b=jVo3UfSRSBR3Hqk13zrYmYH3oI6VLXc5mZajhlP9xneCml16vFv1XjTimKOA7wjWVescnGa/x2SQyyPR3U6p0hsUYWecDoISQvnrnuEJWrhp3nKYpxKfzX27Wscgo5nyMZmJDgRWpSuktgRdU5e7YiUKDzbjy5GXs7j9AOcXd1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608683; c=relaxed/simple;
	bh=o5dkKHgCVA0jUhF85LM4Me7kVFfvsWjezhQXu0Xe9AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isoc6oANTMRAb3cvkB90coeI3TlruRVvz/sy38kOvBFf188RrL1rLJR8t/l+nM0bFSmZDB2ZeES/Q8klbv44+eKi6krLIZOVxdfhPunQBM0CbQsfywJv3TofBaX7rYFfKBwb0QVPwbgYXSrhGQy85Fh22WC+zyJeghxlnbTOl1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD0D0FyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD0D0FyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABA4C2BCB0;
	Tue, 12 May 2026 17:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608683;
	bh=o5dkKHgCVA0jUhF85LM4Me7kVFfvsWjezhQXu0Xe9AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BD0D0FyIKueP4GtRqAfwntv7OuDQcUfG1M8evDe2s2MQiwDl9pmLS6FRMCvjjlbZm
	 metbTA8+fLXJxj/e2QizhfKEq0IHkg1hlKpvVg60uIaVQdcJV1zrtMIiO/D1O2Yn+6
	 BKFGrT9LXM3bL76uuHzkO1OOrQF/MxehkgfXmt/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.18 175/270] s390/debug: Reject zero-length input before trimming a newline
Date: Tue, 12 May 2026 19:39:36 +0200
Message-ID: <20260512173942.132573771@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -1416,6 +1416,9 @@ static inline char *debug_get_user_strin
 {
 	char *buffer;
 
+	if (!user_len)
+		return ERR_PTR(-EINVAL);
+
 	buffer = memdup_user_nul(user_buf, user_len);
 	if (IS_ERR(buffer))
 		return buffer;


