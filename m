Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F7C223322;
	Mon,  2 Jun 2025 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872925; cv=none; b=XMEsDIcunmFKtFZ2AZn5T6LYconZxq0MOnOAoye1zK2BSBRF0tSHJOUJyZrmINw9nO++37mKCVOZF5umz3rL8Xl3NuJMPm8OQGz1ZwDJvE+wnzi8RjlfibaVpmD/G9I2qbRlOzhCGRf6mXuzkgrzqQChcKn9rR8GwKTvwVIiQX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872925; c=relaxed/simple;
	bh=JorqdC9NRfMJ1tlIqPH1bI40xnedU0sI9gfKXjRIZEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwYEuEsXRQLUhkSJqrDQSfHQcElWTY5TB7TLJdH6g093VCwirS3Zs0LjMfpIeT0gvAr66b+3ZOoBLwxBDyISY2SFJ7Fy+2rnyHVUMNfwG0jZT2ReWpqHqC9OH2N4Smn2UKtA1lKWU5xWw3W1dZHtF+DTR7wkmRTXDWYTdOsH6Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6Fe+ApT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6Fe+ApT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E13C4CEEB;
	Mon,  2 Jun 2025 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872924;
	bh=JorqdC9NRfMJ1tlIqPH1bI40xnedU0sI9gfKXjRIZEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6Fe+ApT7nS3LJecGWz6mUp5ccYgRAZy9+pCPdDQ5NvrNaiLP48whNrjIozuN9giq
	 fWjv6Dso3eqPFyZ695DnNr505JhJPedgPzLLXk1G0JV9CpC8tk8E1kPlz185pojstj
	 x/L2zb0LveyZkZmL3lV8G+Me3GgSRLRqB1tJDOmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Markus Burri <markus.burri@mt.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 40/55] gpio: virtuser: fix potential out-of-bound write
Date: Mon,  2 Jun 2025 15:47:57 +0200
Message-ID: <20250602134239.857486404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Burri <markus.burri@mt.com>

[ Upstream commit 7118be7c6072f40391923543fdd1563b8d56377c ]

If the caller wrote more characters, count is truncated to the max
available space in "simple_write_to_buffer". Check that the input
size does not exceed the buffer size. Write a zero termination
afterwards.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505091754.285hHbr2-lkp@intel.com/
Signed-off-by: Markus Burri <markus.burri@mt.com>
Link: https://lore.kernel.org/r/20250509150459.115489-1-markus.burri@mt.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-virtuser.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-virtuser.c b/drivers/gpio/gpio-virtuser.c
index e89f299f21400..dcecb7a259117 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -400,10 +400,15 @@ static ssize_t gpio_virtuser_direction_do_write(struct file *file,
 	char buf[32], *trimmed;
 	int ret, dir, val = 0;
 
-	ret = simple_write_to_buffer(buf, sizeof(buf), ppos, user_buf, count);
+	if (count >= sizeof(buf))
+		return -EINVAL;
+
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
 	if (ret < 0)
 		return ret;
 
+	buf[ret] = '\0';
+
 	trimmed = strim(buf);
 
 	if (strcmp(trimmed, "input") == 0) {
@@ -622,12 +627,15 @@ static ssize_t gpio_virtuser_consumer_write(struct file *file,
 	char buf[GPIO_VIRTUSER_NAME_BUF_LEN + 2];
 	int ret;
 
+	if (count >= sizeof(buf))
+		return -EINVAL;
+
 	ret = simple_write_to_buffer(buf, GPIO_VIRTUSER_NAME_BUF_LEN, ppos,
 				     user_buf, count);
 	if (ret < 0)
 		return ret;
 
-	buf[strlen(buf) - 1] = '\0';
+	buf[ret] = '\0';
 
 	ret = gpiod_set_consumer_name(data->ad.desc, buf);
 	if (ret)
-- 
2.39.5



