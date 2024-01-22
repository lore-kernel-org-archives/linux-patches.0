Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4A656B68;
	Tue, 23 Jan 2024 00:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970023; cv=none; b=gS9pnYq0vDIOtTD5z/FkvUd83TFYrcvMpeXGoCs5YcW8yfr4KLpsfy6vc/fD2v4cGGBCmqVJHlYaXLWC5ABnP3CoofFeJImfLZ7rVgs07KDBVvQx2Fn6hU+sRDCXgXFGyzc9dEbw1IZD8SUFcsyWrd2c5nM7bmIsIUiZaRUMzp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970023; c=relaxed/simple;
	bh=MGFNuJiwz/kSfgt9kjrTOZTKUMW8dQI1YnTfeGIdyA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4YcdR9K+lKkigoBjIo72RlT54HSm6gfvdGz169BDVDI4VJ1GE5sdQb956FnuwHU4xLNTdJds1lGwpkwV1JZAtrTDKJ0lnsgTOkK2JaIpj1rr3LqZZX3wr/pg13twNj0inSqYMTP8odChlN5QjbtKWpU0s0aGBRd9Wbd0DW1nbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9mYgvLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9mYgvLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279BFC433F1;
	Tue, 23 Jan 2024 00:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970023;
	bh=MGFNuJiwz/kSfgt9kjrTOZTKUMW8dQI1YnTfeGIdyA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9mYgvLDxq2QgpIFtXJjXTviXkZxrfe6OyYvt1+xTzQ/MY8wD+uVILqJMk86OJfLV
	 nEc9cmWbLR9rBjRl0rZ8cJmn+ShOyAQ9HB5tux1FsZkH4zQqrlFCRvUUdg+DK5wH9R
	 J25K8+OqtknSmMl2mooMwagD1xRXGNFCIajW5H2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 566/641] cdx: Unlock on error path in rescan_store()
Date: Mon, 22 Jan 2024 15:57:50 -0800
Message-ID: <20240122235835.872971768@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1960932eef9183e2dab662fe75126f7fa46e0e6d ]

We added locking to this function but these two error paths were
accidentally overlooked.

Fixes: f0af81683466 ("cdx: Introduce lock to protect controller ops")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
Link: https://lore.kernel.org/r/a7994b47-6f78-4e2c-a30a-ee5995d428ec@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdx/cdx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cdx/cdx.c b/drivers/cdx/cdx.c
index 40035dd2e299..7c1c1f82a326 100644
--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -575,7 +575,8 @@ static ssize_t rescan_store(const struct bus_type *bus,
 		pd = of_find_device_by_node(np);
 		if (!pd) {
 			of_node_put(np);
-			return -EINVAL;
+			count = -EINVAL;
+			goto unlock;
 		}
 
 		cdx = platform_get_drvdata(pd);
@@ -585,6 +586,7 @@ static ssize_t rescan_store(const struct bus_type *bus,
 		put_device(&pd->dev);
 	}
 
+unlock:
 	mutex_unlock(&cdx_controller_lock);
 
 	return count;
-- 
2.43.0



