Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B241FAEFC;
	Wed,  6 Nov 2024 12:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896711; cv=none; b=RuJenGRG8UPAG0Bgz5qqOWigdLQt47HP77kEjdHSSnqSofUZipVFztiq85GOaxD0bYu3MJu7A6cjFKBKQF9bF38x8WAxOZsvqwYXoO7mFQk4XxEEDmprVqM0E8TbRVFr/9wFGuYZTmoskApXiKsRdwi4YSzSwvG0YVIQpowvqG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896711; c=relaxed/simple;
	bh=Ybxs+/ZJeH3hZrZVgI2r+SoYkZha3CpfnpprRjfGugI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIwTmX3Xg9gRHhi3BHMUUsrl5v3286Gk8wkq5oIAwSYALawa8betKLFTQbw57+KqQFop+EJsvMfFgQf8uivPLkQHSATuUufXVlJXTueAcWAaARXXmIHFxSiKIdrR+goK2oYWRGkK9b5oQIU3LBjEMoqxF86VkgBaZgH4gV8ksPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSNVnLUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSNVnLUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123ACC4CED6;
	Wed,  6 Nov 2024 12:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896711;
	bh=Ybxs+/ZJeH3hZrZVgI2r+SoYkZha3CpfnpprRjfGugI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSNVnLUGuy1gLKCPTpUxEyVGBBMTJQzmDJfFxPKboat0l/4m/PfEgP9U161VhJ+cp
	 RoxZYi8TWAvIm3YuscIt5h+DEtPJ3E4x34fsJAr3D0treEdh5j2y98Ads/Lv/TAY1U
	 3potk0eusPit7yR/bA897z1Qap7y7usGFtjLQrpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 047/110] openat2: explicitly return -E2BIG for (usize > PAGE_SIZE)
Date: Wed,  6 Nov 2024 13:04:13 +0100
Message-ID: <20241106120304.502928439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1270,6 +1270,8 @@ SYSCALL_DEFINE4(openat2, int, dfd, const
 
 	if (unlikely(usize < OPEN_HOW_SIZE_VER0))
 		return -EINVAL;
+	if (unlikely(usize > PAGE_SIZE))
+		return -E2BIG;
 
 	err = copy_struct_from_user(&tmp, sizeof(tmp), how, usize);
 	if (err)


