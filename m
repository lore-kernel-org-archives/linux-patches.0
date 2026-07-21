Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C2B2DB794;
	Tue, 21 Jul 2026 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660408; cv=none; b=MlYzciY5KtC6daDalHRbsH0u/Rs7i/u9J9T24gWvOZ/Nn8zOhUc77UXaDreLp4KoUq7e3oxias6j0eCyphEqCv01SmMi7q6o6efdog1YWpAUelW3BoefU//eKy+CfQ0s5CmMWPXDu4UFRmzg8r/IkqIpkWpNJM80ApnpcYEMJzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660408; c=relaxed/simple;
	bh=8iADgWh3y089UFinpJoxPmnlkkVdXd/7YcoLz2rdH9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcU+uI6+j3wj5wJ7WS+CzXhQTjM7ZrJOcklUTfzGTU/kU5koFBTUTkKLfxh/T03drkm2UMY0PmPE8bzhapy5qcQYt5mKhAkziuLxM/B6gFxY2m7I2Helfqx39W65iJ44P1MIogecVhUf8IrDmm+4SXGaLqA8/QavL1ih75EOLuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kK0X85wa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kK0X85wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650711F000E9;
	Tue, 21 Jul 2026 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660406;
	bh=zoRlYEZPfgJp4TryTtBUK/5jOK27ltcgGRJAN+MvB/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kK0X85waiNmvoTKlTe4t0xD3zjAQIL0LuyduQ4ohxgeGAeK8DOeitHIBMGasRz9nv
	 rTOnjCygiL84wJeM5ZEPfB9fmX0Gh/c75DwRUAqOzLtAALHuQl/lHYYI2zuaGAwUY1
	 xw5HMY6WOgcmwNs79Nf6RNmVmgyGz35/unfWv7Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0924/2077] thunderbolt: debugfs: Fix margining error counter buffer leak
Date: Tue, 21 Jul 2026 17:09:57 +0200
Message-ID: <20260721152614.606725063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 042f6a0d0f7f06..25f6ea6ea09472 100644
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



