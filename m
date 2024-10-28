Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BEE2AF07;
	Mon, 28 Oct 2024 06:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098500; cv=none; b=mS/2Gs5GzwBhxGOSD6OrH1jcgT1/0GCqLWfespEHDenxQ8fuVXwu4fvO70DBJeIiN9PFsSRjjWbHfUsuFYPR5G2aYTQneSspQfkMT2yMvcYQ8Lyui8gVr2OKUTB1TNFSLrKNeMeMb/n5IE5sWv0e4DHXgYst1lvYEBMEgqOtTXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098500; c=relaxed/simple;
	bh=Y6vRBI1Io89n40zrnJSPg2n2wJH4P68Pg7KuI5a9LIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dni7pdnC2aX6EGIrz868nceVmNXQU5cUtBTYrNnDQOV28MrnbwOqemRpuU3ZtACDAGo51BQVwJelPi6hl4ph8aV9/KYLBzYgdXpd10KcmFyzLbWlpIK8nR7y4ZWgJwRE9ZsrucCWrV3gluarH1DfUv51S/kuuE/caTZmUl7yxx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWMoueCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWMoueCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1551EC4CEC3;
	Mon, 28 Oct 2024 06:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098500;
	bh=Y6vRBI1Io89n40zrnJSPg2n2wJH4P68Pg7KuI5a9LIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWMoueCSvukaoUudke3ClTRe/Ry6TNGWwFOKr0254QbdGHhmMKhMJk7N143bF0wKJ
	 +v3cMQmZCywYrGxxR7l/WvDKF4NXXrV6Z9MHFcT1+6YM9Hd68fsGmAQv1Uoy2Kuxen
	 Q5l1EsQyYavMVzTNAHaDH6DW3xWkrZldsnbt5F0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.11 217/261] openat2: explicitly return -E2BIG for (usize > PAGE_SIZE)
Date: Mon, 28 Oct 2024 07:25:59 +0100
Message-ID: <20241028062317.539562888@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Sarai <cyphar@cyphar.com>

commit f92f0a1b05698340836229d791b3ffecc71b265a upstream.

While we do currently return -EFAULT in this case, it seems prudent to
follow the behaviour of other syscalls like clone3. It seems quite
unlikely that anyone depends on this error code being EFAULT, but we can
always revert this if it turns out to be an issue.

Cc: stable@vger.kernel.org # v5.6+
Fixes: fddb5d430ad9 ("open: introduce openat2(2) syscall")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Link: https://lore.kernel.org/r/20241010-extensible-structs-check_fields-v3-3-d2833dfe6edd@cyphar.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/open.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/open.c
+++ b/fs/open.c
@@ -1458,6 +1458,8 @@ SYSCALL_DEFINE4(openat2, int, dfd, const
 
 	if (unlikely(usize < OPEN_HOW_SIZE_VER0))
 		return -EINVAL;
+	if (unlikely(usize > PAGE_SIZE))
+		return -E2BIG;
 
 	err = copy_struct_from_user(&tmp, sizeof(tmp), how, usize);
 	if (err)


