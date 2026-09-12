Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96A8372EDE;
	Sat, 12 Sep 2026 07:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199239; cv=none; b=FfvhTjEGcZrXifAUzZ14iWXfuV3sDF9Qi1yCcMj6Vn9YIFJGr58E7LjkKNlLqYoVpbIH8gZE6T75wd4dLzE9YbgOr8MWBKXejVYn1cBOQN8LyO1dbo4Mqb/OhzN0G0J3u0mj7HUENZo3iDumBe7LyB0MnzQdGvnmBSuFtZrR2eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199239; c=relaxed/simple;
	bh=cGmKA44sA/0A/VmGIeqQm8AiI99vUU8kDZjiQj9Smqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmV1kYfhrMK1m9czZFj+/4b70iWOnOxdC6XUj6FQWJeFtcgkwRHpgP1jTqWXrgE5yA8j10iBK683WG10UGSm0fX5DPRo8MLXDQ9HFCdOL4etTP/JYCrDwLWjV27o3uo9oiF9twqtbAzdkeSw+x2+ZSc648aan473heHsLnO+WoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWqH+mMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWqH+mMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E161F000FF;
	Sat, 12 Sep 2026 07:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199238;
	bh=tZP3y/4QtnpG8pymXHwD6ZI/EQdxlnNt8kc3LFhNHdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MWqH+mMRp8GCPtyRMG+6ZdWXIzRkjFegPgGTr2uLOi5u5cfyFbH9rXQP26gJ6qOX5
	 sx1kjyJZIxdpf7KsXCrMsHB2EyMW+LeEZsoxcH9EG0pCAQ/5svO1STj+u/JhZxHqhs
	 NxjLA2Y1UaZ3lk17iwNS875qhCfoh0wIsi40vYqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0542/1815] RDMA/core: Add ib_no_udata_io() helper
Date: Sat, 12 Sep 2026 08:38:12 +0200
Message-ID: <20260912065701.607738600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit a833ce42d05624f27ac9b32e939df9caa7b06af3 ]

In many cases, a driver op accepts no input data and provides
no response. This helper can be used in those handlers to
adhere to the uAPI forward/backward compat rules by failing
early if invalid udata is provided (whether input or output).

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260702170652.4159201-2-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: d38c835925d4 ("RDMA/bnxt_re: Validate udata before executing commands")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/rdma/uverbs_ioctl.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 24fd362130233..80f3ba6663d06 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -1151,4 +1151,24 @@ static inline int ib_respond_empty_udata(struct ib_udata *udata)
 	return 0;
 }
 
+/**
+ * ib_no_udata_io - Ensure no input data and zero fill the response buffer
+ * @udata: The system call's ib_udata struct
+ *
+ * Driver ops which do not accept any input data and do not provide any response
+ * data may call this at the beginning of their handler to fully adhere to the
+ * uAPI forward/backward compatibility rules.
+ *
+ * Return: Negative failure code if the op should be denied, 0 otherwise.
+ */
+static inline int ib_no_udata_io(struct ib_udata *udata)
+{
+	int ret = ib_is_udata_in_empty(udata);
+
+	if (ret)
+		return ret;
+
+	return ib_respond_empty_udata(udata);
+}
+
 #endif
-- 
2.53.0



