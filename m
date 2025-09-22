Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CAB2DEA79;
	Mon, 22 Sep 2025 19:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570123; cv=none; b=jvNfMUMe0AR99S7+IN34wMJpYDPv36DK4yG4lYVp5qlpxRZzi5y7JbbsAgLNwvGUD+vjqaEHF2NmVu5AG3BW9iKPvaRKBcNMhgD4MyDA2Xk3WqC7FIAJPqvdL42dYnuCetJ/gM1+oM77ZjBIOi73xeprdicKgb63MGgdiDxk3UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570123; c=relaxed/simple;
	bh=0BGNSIHv8Ptf0/PjpWTAu6EoxP0+u9G684ayMzV0ezE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYUuW/cYjgcD3wGoX6D9NwSt45/SDhNpWoGa4Ouktr8+aQOc+0iBCqsertsrmfWVdN0R5hT/smbHVPpTJdJZERJJvp+F3Nee+2W2Atflg6lpubmZnUFqaem1eM+hDgvFFjRFOfFgc0SfTSxn654KuNHvO6bDb3kftyBzZzeoY+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMrUHVCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMrUHVCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE22C4CEF0;
	Mon, 22 Sep 2025 19:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570123;
	bh=0BGNSIHv8Ptf0/PjpWTAu6EoxP0+u9G684ayMzV0ezE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMrUHVCUaU/52M13tG+EHHhmoob8HLFoWcXHXNvqQRa4/1O3b5JmFYp951ZO5Qlnz
	 BSSAK9dfY/Vvg73HZBdP8WWtZ6jprYJzn/IJ71rJmz4cmMT+rkNnkhIRVQpUm69lCl
	 o8zyPxI9uNgaLDaX9YeKdhFz+dDFZMaLPsB7KNh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 014/149] um: Fix FD copy size in os_rcv_fd_msg()
Date: Mon, 22 Sep 2025 21:28:34 +0200
Message-ID: <20250922192413.245369268@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit df447a3b4a4b961c9979b4b3ffb74317394b9b40 ]

When copying FDs, the copy size should not include the control
message header (cmsghdr). Fix it.

Fixes: 5cde6096a4dd ("um: generalize os_rcv_fd")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index 617886d1fb1e9..21f0e50fb1df9 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -535,7 +535,7 @@ ssize_t os_rcv_fd_msg(int fd, int *fds, unsigned int n_fds,
 	    cmsg->cmsg_type != SCM_RIGHTS)
 		return n;
 
-	memcpy(fds, CMSG_DATA(cmsg), cmsg->cmsg_len);
+	memcpy(fds, CMSG_DATA(cmsg), cmsg->cmsg_len - CMSG_LEN(0));
 	return n;
 }
 
-- 
2.51.0



