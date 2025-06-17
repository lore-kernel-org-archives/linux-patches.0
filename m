Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061592EA161;
	Tue, 17 Jun 2025 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178565; cv=none; b=ihaaCeXThL766GC07ZgpXdPt35JEFHtCxCm0tCgFzlbQuvIWpEW6IalG/LKhJMPL/TIClkNidJyOWTTnWd7gj+g+G3EhLlaOWlnyzGdvv4EZaD/OveAlFgymJxYnf1XTbFD1uTFGLc5RPh9xsf8b7+LoeHk0OqjhR7X7Zw4TFkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178565; c=relaxed/simple;
	bh=o9IL9hfjMaDKQoNarJUgR51hqLNlwIgBd6Jmt0xkt18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoihQSWUk7iv/FVw6IJ55PbjFnIabQdanPTOxHjMgB8v8jWujnZQgPGEXvf2+PYcn0xLvR4GReQI/APpS/MfHaV54egB7KnMPHP5S8yTWmQ/+mCD2V1fXiR4nS7cxNEtdtdExmG+FjHpQBz2VBOvwEB6FG5gy7FNHfGI1RNRNHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lf0TKNDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lf0TKNDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135E2C4CEE3;
	Tue, 17 Jun 2025 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178564;
	bh=o9IL9hfjMaDKQoNarJUgR51hqLNlwIgBd6Jmt0xkt18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lf0TKNDHV9WgErP8pInlCQP+sUfTKo4NDV/mEtki9hF+Ir7sKFNsRsc3sREKBu2mI
	 zSM/nA03S3qAUhRBsMy0zPSScIAq9DUlh8elbhn2AUefJzfSSo+VnioC46Qa6HC0ry
	 aMCmeHD5T9yfi/o9VUwxX7EtFzJHHav860NJ1UWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 486/780] exportfs: require ->fh_to_parent() to encode connectable file handles
Date: Tue, 17 Jun 2025 17:23:14 +0200
Message-ID: <20250617152511.282187346@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 5402c4d4d2000a9baa30c1157c97152ec6383733 ]

When user requests a connectable file handle explicitly with the
AT_HANDLE_CONNECTABLE flag, fail the request if filesystem (e.g. nfs)
does not know how to decode a connected non-dir dentry.

Fixes: c374196b2b9f ("fs: name_to_handle_at() support for "explicit connectable" file handles")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/20250525104731.1461704-1-amir73il@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/exportfs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index fc93f0abf513c..25c4a5afbd443 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -314,6 +314,9 @@ static inline bool exportfs_can_decode_fh(const struct export_operations *nop)
 static inline bool exportfs_can_encode_fh(const struct export_operations *nop,
 					  int fh_flags)
 {
+	if (!nop)
+		return false;
+
 	/*
 	 * If a non-decodeable file handle was requested, we only need to make
 	 * sure that filesystem did not opt-out of encoding fid.
@@ -321,6 +324,13 @@ static inline bool exportfs_can_encode_fh(const struct export_operations *nop,
 	if (fh_flags & EXPORT_FH_FID)
 		return exportfs_can_encode_fid(nop);
 
+	/*
+	 * If a connectable file handle was requested, we need to make sure that
+	 * filesystem can also decode connected file handles.
+	 */
+	if ((fh_flags & EXPORT_FH_CONNECTABLE) && !nop->fh_to_parent)
+		return false;
+
 	/*
 	 * If a decodeable file handle was requested, we need to make sure that
 	 * filesystem can also decode file handles.
-- 
2.39.5



