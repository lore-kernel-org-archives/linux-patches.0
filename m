Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D99408026;
	Tue, 21 Jul 2026 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657085; cv=none; b=hcNYYwJOAmTiGSLxkIIQlrR6ck3GtBseYYRI2GZK6xVRS/T1zWTU/eU0LOtUQ9B8rptgNsDi2J86QAgGE2e8ynBJnJ6OLAv1KZPWvmMM2HWTABcgtF7iPXFn6mSCv0mcssOCa8zqtZAL9alGpqUyioa2UliB7W744eWz+KTqd4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657085; c=relaxed/simple;
	bh=Yc3CMy+QXgMIpwA7TH058DPm9dIm3otPR8+d3ORklyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roMH9c19ClJxpfOpY+EX+9ou+Xmkra1mPaBQKHXB4Q+SMjjQhQvCbT1XPB6n59bFgxNZK8e6jJsK+CcInWIkaw3NsKhUm9Nu2YJTdmJtJfJNrxUoH8Ql+eGopT74x6E/hn/44/Xqy/J5lGd3KmMmcckZB2ZR0sW9S0YYOyGBSNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoewdpER; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoewdpER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22F31F000E9;
	Tue, 21 Jul 2026 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657084;
	bh=pOV+8wQYTSCgO8alt3AB0S/bgH1Q9qPTj52q+F2k9TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoewdpERQLL+X6JACfylpD6Q/zzB5Ji3PY/TP7wRIMnGrLTIqte61l31kglJB7ibi
	 et8Sff0hRDW9RxPgIQMfcf4QbJYhZTnJw4MrDqn/YlfEaZxULjH9EQn50Wj7Li7tka
	 ZoOhpcMF/zqJ6QqSX34sZWLVPotri06m8LbO5n2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0631/1611] thunderbolt: debugfs: Fix margining error counter buffer leak
Date: Tue, 21 Jul 2026 17:12:27 +0200
Message-ID: <20260721152529.582557952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 503c5ae1e72aa9ed91925dafa3d82ee2e992747f ]

When USB4 lane margining debugfs write support is enabled,
margining_error_counter_write() copies the user input with
validate_and_copy_from_user(). This allocates a temporary page that is
only needed while parsing the requested error counter mode.

The function currently returns without freeing that page. This leaks one
page per write to the error_counter debugfs file, including successful
writes and writes that later fail while taking the domain lock or because
software margining is not enabled.

Free the temporary page once parsing has completed, and also before
returning from the invalid-input path.

Fixes: 10904df3f20c ("thunderbolt: Improve software receiver lane margining")
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/debugfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/debugfs.c b/drivers/thunderbolt/debugfs.c
index 46a2a3550be71e..71c9833563c709 100644
--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -956,7 +956,9 @@ margining_error_counter_write(struct file *file, const char __user *user_buf,
 	else if (!strcmp(buf, "stop"))
 		error_counter = USB4_MARGIN_SW_ERROR_COUNTER_STOP;
 	else
-		return -EINVAL;
+		goto err_free;
+
+	free_page((unsigned long)buf);
 
 	scoped_cond_guard(mutex_intr, return -ERESTARTSYS, &tb->lock) {
 		if (!margining->software)
@@ -966,6 +968,10 @@ margining_error_counter_write(struct file *file, const char __user *user_buf,
 	}
 
 	return count;
+
+err_free:
+	free_page((unsigned long)buf);
+	return -EINVAL;
 }
 
 static int margining_error_counter_show(struct seq_file *s, void *not_used)
-- 
2.53.0



