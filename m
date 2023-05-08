Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E638A168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4844CC433D2;
	Mon,  8 May 2023 10:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540405;
	bh=WEAmJZGfFKqctGT2vUqWC3klLrFDB7+B8pLgO0w/uAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBS/eBLuRONddjCIIox6FGbNWox3hD4h4obHNe/nzMvN6DjkcT0k/Z0eClzVbd0l0
	 4aAI8su1qg+Ca0Jad7UQLIHTHRQm2SZUVv0c43XFk04KTHQRafeEuje6QgstSfCL7S
	 s1/6MqFF+/SygTQMHG/xz9HL1QVmgftvah1a/Gno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 311/611] wifi: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_reg()
Date: Mon,  8 May 2023 11:42:33 +0200
Message-Id: <20230508094432.547134556@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit 5dbe1f8eb8c5ac69394400a5b86fd81775e96c43 ]

If there is a failure during copy_from_user or user-provided data buffer is
invalid, rtl_debugfs_set_write_reg should return negative error code instead
of a positive value count.

Fix this bug by returning correct error code. Moreover, the check of buffer
against null is removed since it will be handled by copy_from_user.

Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230326054217.93492-1-harperchen1110@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 602717928887d..9eb26dfe4ca92 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -278,8 +278,8 @@ static ssize_t rtl_debugfs_set_write_reg(struct file *filp,
 
 	tmp_len = (count > sizeof(tmp) - 1 ? sizeof(tmp) - 1 : count);
 
-	if (!buffer || copy_from_user(tmp, buffer, tmp_len))
-		return count;
+	if (copy_from_user(tmp, buffer, tmp_len))
+		return -EFAULT;
 
 	tmp[tmp_len] = '\0';
 
@@ -287,7 +287,7 @@ static ssize_t rtl_debugfs_set_write_reg(struct file *filp,
 	num = sscanf(tmp, "%x %x %x", &addr, &val, &len);
 
 	if (num !=  3)
-		return count;
+		return -EINVAL;
 
 	switch (len) {
 	case 1:
-- 
2.39.2



