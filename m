Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B33D149E0E;
	Fri,  6 Dec 2024 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496115; cv=none; b=XywTAZmVryhsstQkKhJx9avnQQuENXMwO8JEUbiYMXxWibnHR4FwnINy65oODcVBRUO8fpcpVrI9R32sNezV99h62YLxHNpwIyqYHy/h738YsSUNqYAKouYpYuAIoIze3GfyhNNx9uZK6MjUu0Qu0cu8kyD+Xt7jUgKMB49Lz8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496115; c=relaxed/simple;
	bh=AGnIY03fMP3QsDIEE0/AujMjU6MGCg+ujhfKDTRkZMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrzqvBR3M1ekCJGEaPO15m2pcSMLQIKiFAMFMBwETSIOEk/6pAIAdyfV9IYmQWBP6A92zxo2Szo/R050+YGXmz61hDBRIuX/0b0LAcMDyCO6gJlwhHmHjOHNJKFM5VTY/lNtkWyWeUlcGhxxrdOIFtUel22eJ/ydEXtMfFE6uyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGksKrCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGksKrCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE7CC4CED1;
	Fri,  6 Dec 2024 14:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496115;
	bh=AGnIY03fMP3QsDIEE0/AujMjU6MGCg+ujhfKDTRkZMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGksKrCipfcMY69o1c71lxKIRfrEE3hRZaHq0muM7bgbpNVqkwoIJbEr+/xo2ZBwZ
	 00Mc1qmV92Pf87YguVJdQeNnVIwS9B5wQBBn+954e0AcOXhYmevXuzjEk9jLS30AYA
	 z8UCaF2GcUTxrHx3cD59lWKlWxh7U3gksTDpbIOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Marek Vasut <marex@denx.de>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.12 056/146] nvmem: core: Check read_only flag for force_ro in bin_attr_nvmem_write()
Date: Fri,  6 Dec 2024 15:36:27 +0100
Message-ID: <20241206143529.819143720@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit da9596955c05966768364ab1cad2f43fcddc6f06 upstream.

The bin_attr_nvmem_write() must check the read_only flag and block
writes on read-only devices, now that a nvmem device can be switched
between read-write and read-only mode at runtime using the force_ro
attribute. Add the missing check.

Fixes: 9d7eb234ac7a ("nvmem: core: Implement force_ro sysfs attribute")
Cc: Stable@vger.kernel.org
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20241030140253.40445-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -267,7 +267,7 @@ static ssize_t bin_attr_nvmem_write(stru
 
 	count = round_down(count, nvmem->word_size);
 
-	if (!nvmem->reg_write)
+	if (!nvmem->reg_write || nvmem->read_only)
 		return -EPERM;
 
 	rc = nvmem_reg_write(nvmem, pos, buf, count);


