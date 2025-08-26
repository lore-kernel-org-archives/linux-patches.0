Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F2418A6C4;
	Tue, 26 Aug 2025 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214659; cv=none; b=RtpLDaZq6AVfTqAMxCbhA0ui+2N5fPlYN0Lula9VVqMECcuQhPVNQ5e+/JVD8MVpB+AktGZFihfPxjXL+FHMTK/hK4mpidwQum49e8IQqjwa3LxHODdwFIwEbxqy6q0u5B+hlsepmcTZ9OvubUczcf/qcikN8XLGAll1Cjc2EpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214659; c=relaxed/simple;
	bh=7BBsoc0FYbSDuDlnzkQgjTClQ+vnnTAwCIn/8TDd10k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWmgs7ICdPFwhrATJSEr3O/bgX4pi2oiJX/HZCiHcHroYB9hGfwAo3fsemxuPojurVqSwZ0GmXAz6ZdsDfme9tG3QNkFk5ZABLvSjXzyCh7DVM7BZDi7mGidCXbYCyJ8IvH6FhEuQk+xgi0q6PHjW/WC9+EtLWFLy9S3m9xCNUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ju+NsOrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ju+NsOrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D803C4CEF1;
	Tue, 26 Aug 2025 13:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214659;
	bh=7BBsoc0FYbSDuDlnzkQgjTClQ+vnnTAwCIn/8TDd10k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ju+NsOrW/HhkLvq9ffxaTCQbeOKGoagP6SfjyKLcrUG7itNSPGtLToJrn9FupfJnO
	 O0LZTnEevtJYJlN7DGXp7IUBf1Sm7g9jln4ghYhGxpQu0TC+OymP0SwlmaqKtP1jc7
	 h82bacWygXHvP4A/CPM65vWv6esEOfiIEeoavvEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/482] fs/orangefs: use snprintf() instead of sprintf()
Date: Tue, 26 Aug 2025 13:07:13 +0200
Message-ID: <20250826110935.254830232@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>

[ Upstream commit cdfa1304657d6f23be8fd2bb0516380a3c89034e ]

sprintf() is discouraged for use with bounded destination buffers
as it does not prevent buffer overflows when the formatted output
exceeds the destination buffer size. snprintf() is a safer
alternative as it limits the number of bytes written and ensures
NUL-termination.

Replace sprintf() with snprintf() for copying the debug string
into a temporary buffer, using ORANGEFS_MAX_DEBUG_STRING_LEN as
the maximum size to ensure safe formatting and prevent memory
corruption in edge cases.

EDIT: After this patch sat on linux-next for a few days, Dan
Carpenter saw it and suggested that I use scnprintf instead of
snprintf. I made the change and retested.

Signed-off-by: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index b57140ebfad0..cd4bfd92ebd6 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -354,7 +354,7 @@ static ssize_t orangefs_debug_read(struct file *file,
 		goto out;
 
 	mutex_lock(&orangefs_debug_lock);
-	sprintf_ret = sprintf(buf, "%s", (char *)file->private_data);
+	sprintf_ret = scnprintf(buf, ORANGEFS_MAX_DEBUG_STRING_LEN, "%s", (char *)file->private_data);
 	mutex_unlock(&orangefs_debug_lock);
 
 	read_ret = simple_read_from_buffer(ubuf, count, ppos, buf, sprintf_ret);
-- 
2.39.5



