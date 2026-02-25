Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCE331A7E4;
	Wed, 25 Feb 2026 06:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002767; cv=none; b=pkjzGaHNiN6foAIONU7ATlhSWk3tjCs+qE3C9xjrn263xwwVEyiNdw+E+Jg7ulnjSuKxmeBBsS68PzuxSQcFIiq0y69Gd3TZQk3yLNpE+NVfsQ9grxUlDf87LZltxRRADA1CH9nXJjFW94SGLydFesVQatl8K7C0Yi0tbNzeJHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002767; c=relaxed/simple;
	bh=d/iBEatOCu5Xeh3V+FzStCv18L1snQ9/6J6srgzEfNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMLUlPZi5O62Vws6yYRfHjtYrXPSkykJf4yjre9wZv792XatXPCdbtTKs4toHmgGyG0zW9Npym+WBckUh7OJeG8YHQP5T6OyHe7TwNoesJeQs8wB8eLWiDFVhK/z95KCPQKNngAVCQ6Ctgk5AocgEGnMX9v1ofeasi6HpDoJgpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDH9ZIr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDH9ZIr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052C4C116D0;
	Wed, 25 Feb 2026 06:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002767;
	bh=d/iBEatOCu5Xeh3V+FzStCv18L1snQ9/6J6srgzEfNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDH9ZIr9c5yMKCoxsEvVFmuORD0+g38YhHWCv+nb3Q/xOypircZlPgE9oDKUWtB8o
	 ZB3ZlliTH1g8mqfKn0pJSc6Z6fouVRTZq7C9Hdvivvn4QTFbQ7EVml/B6rATQHKdu4
	 Cjc/jueY21nN5sD4kMvu/x7ZwLW8prUwldYO/6Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 570/641] apparmor: account for in_atomic removal in common_file_perm
Date: Tue, 24 Feb 2026 17:24:56 -0800
Message-ID: <20260225012402.332736246@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Ryan Lee <ryan.lee@canonical.com>

[ Upstream commit 9b829c0aa96e9385b1e9a308d3eb054b95fbeda2 ]

If we are not in an atomic context in common_file_perm, then we don't have
to use the atomic versions, resulting in improved performance outside of
atomic contexts.

Signed-off-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 4e44bd5bf1d91..5fc99fe8d38a4 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -523,15 +523,14 @@ static int common_file_perm(const char *op, struct file *file, u32 mask)
 {
 	struct aa_label *label;
 	int error = 0;
-	bool needput;
 
 	/* don't reaudit files closed during inheritance */
 	if (unlikely(file->f_path.dentry == aa_null.dentry))
 		return -EACCES;
 
-	label = __begin_current_label_crit_section(&needput);
+	label = begin_current_label_crit_section();
 	error = aa_file_perm(op, current_cred(), label, file, mask, false);
-	__end_current_label_crit_section(label, needput);
+	end_current_label_crit_section(label);
 
 	return error;
 }
-- 
2.51.0



