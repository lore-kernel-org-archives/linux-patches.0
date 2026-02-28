Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD323314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301176; cv=none; b=btuSvX0WfVPTcl12BRDrPCdobN7UEHlg1okZAvPAJYfjy9T2WNUwCtooYALfJhOL7qIdr2hWczWMCfqMSx7lEKMExPIo1Okoy3IRHG+9M7N77YjNCQurO+58dbEXnFfM4tgg3i/UoZXpd+i7+/o5GlKJa95nYr491p1mrG0LQ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301176; c=relaxed/simple;
	bh=WOfrvr/MpfE4AEwCXSdBTXFmtSK5GfREWXQjhEZsXC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPHCi218yHZgdVq+tgm15HBDuy6OhyqeSZTlCb1l58iJ2b62p6vq4VDn0MpI+WQ9jQje5M0fBfPksHINu5o/zt2TI6WGVfK4oz0hDFG0gKKz5xfGa7Oi2HHKdD/G67cBulghXs0zFOwR+BMjeHwS0T8gN8fGc22AFZP70Fc+3Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJkWGJEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJkWGJEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08855C19424;
	Sat, 28 Feb 2026 17:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301176;
	bh=WOfrvr/MpfE4AEwCXSdBTXFmtSK5GfREWXQjhEZsXC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJkWGJEm/KARoGKfTNDuTiFh/o1fmzNZNlYmBl1yzv4UYRk94IKeffncF7OZ0J/Y6
	 /+rhbhMkR/bdjQok6igglAGP/mQiKZy8OL/iFYoGslQ9xFq7UZ7TlZ51fZZr6NtRIM
	 u6J7OcZddbrtkMs/nZ39/0mCwDXjxo7KW3fOoU3qyU8vYVGYE/CjuQubi9670oPBSI
	 tbGfeaTJzWpw99jRo4qWJkz3wDQLdcF6d1zwdL6LoZD1v624eq/cOGdLVr8ub1oUHi
	 J5jyXeb5HdOXxxUBYYuLa2IpiScsZQmbUhvZ6TB9L+37fN9+4kEEhI/jt9f28P3Owh
	 SkIhjrZw/npqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Diksha Kumari <dikshakdevgan@gmail.com>,
	Mukesh Kumar Chaurasiya <mkchauras@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 344/752] staging: rtl8723bs: fix memory leak on failure path
Date: Sat, 28 Feb 2026 12:40:55 -0500
Message-ID: <20260228174750.1542406-344-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Diksha Kumari <dikshakdevgan@gmail.com>

[ Upstream commit abe850d82c8cb72d28700673678724e779b1826e ]

cfg80211_inform_bss_frame() may return NULL on failure. In that case,
the allocated buffer 'buf' is not freed and the function returns early,
leading to potential memory leak.
Fix this by ensuring that 'buf' is freed on both success and failure paths.

Signed-off-by: Diksha Kumari <dikshakdevgan@gmail.com>
Reviewed-by: Mukesh Kumar Chaurasiya <mkchauras@linux.ibm.com>
Link: https://patch.msgid.link/20260113091712.7071-1-dikshakdevgan@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 315bab3737294..5d28dbf8b50ef 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -315,9 +315,10 @@ struct cfg80211_bss *rtw_cfg80211_inform_bss(struct adapter *padapter, struct wl
 					len, notify_signal, GFP_ATOMIC);
 
 	if (unlikely(!bss))
-		goto exit;
+		goto free_buf;
 
 	cfg80211_put_bss(wiphy, bss);
+free_buf:
 	kfree(buf);
 
 exit:
-- 
2.51.0

