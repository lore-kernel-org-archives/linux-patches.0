Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A94386C39;
	Tue, 21 Jul 2026 19:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662471; cv=none; b=Ivys9b6OaRDCLMVWbZZqbnOSFWikYz8oXQjhEuGx6wSB9I/g9O52zQ7kBGssdmkBMxfksiXGckIMgIflP5WK5M1vNbI8zXF7jNSqlinpQK4v+jBnU5D1SDKAFalPT6nLgJUbsOgynZG6FOBKSKl/Ru7NPrf1W2dnSsA19I75Jew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662471; c=relaxed/simple;
	bh=XiyoqZEKJX5UAi8bpzdcrcV3OAkXgZFxhgGuP4N/CBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GW6WHAkmR8uP/lyb40oTRDl1nuZKA3Q0u6xvBGjfywnHvvw+2MUQQahy1Qzzepr4CLC5GItc7d9E4oyuMceqIRQO800OPKNueNyebNGJT7AticHeJvwWsOjxiJI6L/Bf8b4aIMAN7aDiw/EkpJJITOmxT9VaTnqUm5Q2JUOl630=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxxOc2kD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxxOc2kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887BF1F000E9;
	Tue, 21 Jul 2026 19:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662470;
	bh=AK/M4nyDHiEhG8EmvH9TW0b8A4BdALojacVDZD2Zk1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxxOc2kDvENK0IMtTI7iVsUU0g9YXmTDKQfjXkYfpeqcxf7iyQVFYQedBHebYYllg
	 Lsqs/hyxfTuiBeUclfTXqiy0ybX/9KraJVi0WWni3W0Oki5NGaDHNaH3aI4lC2OxZx
	 zsJPgo27VIJLmWWTYyZ9Ke2iZPdXt/Jnq71fJZEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0455/1276] thunderbolt: debugfs: Fix margining error counter buffer leak
Date: Tue, 21 Jul 2026 17:14:58 +0200
Message-ID: <20260721152456.285960305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 350310bd0feea7..e2178fe368d46e 100644
--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -797,7 +797,9 @@ margining_error_counter_write(struct file *file, const char __user *user_buf,
 	else if (!strcmp(buf, "stop"))
 		error_counter = USB4_MARGIN_SW_ERROR_COUNTER_STOP;
 	else
-		return -EINVAL;
+		goto err_free;
+
+	free_page((unsigned long)buf);
 
 	scoped_cond_guard(mutex_intr, return -ERESTARTSYS, &tb->lock) {
 		if (!margining->software)
@@ -807,6 +809,10 @@ margining_error_counter_write(struct file *file, const char __user *user_buf,
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



