Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF1912E1E2;
	Tue, 14 May 2024 11:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686723; cv=none; b=uFfyD7xp9/Mz21klUqcD2OU/2RHeSm+XGbvpaGkmjaC0kBtyKdu2nNll8cT3bgIOR111gOHKEM6tH28R27agnbsWGIhOFAwnCjeG+x2IaLHj78IuYWD3mn4jiW84x0Er5WLdNXYk9IpkJFb66oqK+YMs9yVhLDPwwzfU4tdMnlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686723; c=relaxed/simple;
	bh=VlPZUpQNzI8daRBkYe6QKF5ddkvbJdOzmqcrikZDDd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQObOAZDJ2lSD9NyBeHCfeLsn//yLXbiCnudK+bYNVqDjlj4poYiR5IiwYC9gA06P1ctUGzk9lkhPCF7olpKk3qvGBVYOeTfrfRjpqZ3g9FqKibKcQA34JPyemrBAsunbDrN6SqcsANeAZqRp81g6sF2apEv65Af6iayheDWO6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJ0iIQXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJ0iIQXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E7BC32782;
	Tue, 14 May 2024 11:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686722;
	bh=VlPZUpQNzI8daRBkYe6QKF5ddkvbJdOzmqcrikZDDd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJ0iIQXHeIvFSEFZiX5nLrhyhYP/vHAppEjN7Rg5jP8hJDkukV3alPOamw/R402jh
	 Z7mS1R7kpP+fgsTyfYBiPn/071FAOLjg7pJyWuafhNz1qjGYBUcg+ysZT3URQqOo0c
	 5TtrwKTWil1bE95KiHEOubBugjEr7KX8qjQh/phg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 236/236] Bluetooth: qca: fix firmware check error path
Date: Tue, 14 May 2024 12:19:58 +0200
Message-ID: <20240514101029.318712890@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 40d442f969fb1e871da6fca73d3f8aef1f888558 upstream.

A recent commit fixed the code that parses the firmware files before
downloading them to the controller but introduced a memory leak in case
the sanity checks ever fail.

Make sure to free the firmware buffer before returning on errors.

Fixes: f905ae0be4b7 ("Bluetooth: qca: add missing firmware sanity checks")
Cc: stable@vger.kernel.org      # 4.19
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -597,7 +597,7 @@ static int qca_download_firmware(struct
 
 	ret = qca_tlv_check_data(hdev, config, data, size, soc_type);
 	if (ret)
-		return ret;
+		goto out;
 
 	segment = data;
 	remain = size;


