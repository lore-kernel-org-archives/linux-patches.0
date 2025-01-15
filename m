Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713981E98E0;
	Wed, 15 Jan 2025 10:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938152; cv=none; b=KNTGMp4nAAYzE/BVo8tCb29hX9k8v7NmXNwDm23B1Gs6cRY4NAngIjnnAsKeWEpsioHrd8ZrBtnGhTYpIRavmedko80C8npQzOEAmnsptn4B4dd7mRth85LSnVTD+Xy7GH61lykqD/02XSz86uxVURpiemB9zi6SQrJE8sd12dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938152; c=relaxed/simple;
	bh=H11rkKPzusFwvyKcLGZIB7L6xXBtdVzKqb8E8Rlg8y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cC7biMy/CsWyXVbHFGn5YUqgYeAhdoDZ3o3Flbca+CcPCtKT4EdRAfaERoPlFLeSkSrx1jy6WZxd6V9a1Cpxvc3ybF9KZ9CXhK84SsiDcVaO2+E8J6vKRTIYF+Pgsi5LD1mCZVyTSaCGu9ZhltsBuQCOdo79gtTlflEnnNIpk2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtaxdkRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtaxdkRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F986C4CEDF;
	Wed, 15 Jan 2025 10:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938152;
	bh=H11rkKPzusFwvyKcLGZIB7L6xXBtdVzKqb8E8Rlg8y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtaxdkRCfpFdRw+UaWK9KS21LaeLLghCOhP91dnZB4q1a+akBvFYyuLIOCfWXLfai
	 yF3cNtNGl/7v+CQf93KSLTthz8rzbZ/YgUw5gGTk2gSVwLmabqmX+zp0jSMY9fffPj
	 6fLNVbZK7EO5oVe1KhW2qai6V/8+hJXYSuwIc51o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/189] gpio: virtuser: fix handling of multiple conn_ids in lookup table
Date: Wed, 15 Jan 2025 11:36:04 +0100
Message-ID: <20250115103609.074757124@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Koichiro Den <koichiro.den@canonical.com>

[ Upstream commit 656cc2e892f128b03ea9ef19bd11d70f71d5472b ]

Creating a virtuser device via configfs with multiple conn_ids fails due
to incorrect indexing of lookup entries. Correct the indexing logic to
ensure proper functionality when multiple gpio_virtuser_lookup are
created.

Fixes: 91581c4b3f29 ("gpio: virtuser: new virtual testing driver for the GPIO API")
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Link: https://lore.kernel.org/r/20250103141829.430662-3-koichiro.den@canonical.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-virtuser.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-virtuser.c b/drivers/gpio/gpio-virtuser.c
index e89b1239b635..d6244f0d3bc7 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -1410,7 +1410,7 @@ gpio_virtuser_make_lookup_table(struct gpio_virtuser_device *dev)
 	size_t num_entries = gpio_virtuser_get_lookup_count(dev);
 	struct gpio_virtuser_lookup_entry *entry;
 	struct gpio_virtuser_lookup *lookup;
-	unsigned int i = 0;
+	unsigned int i = 0, idx;
 
 	lockdep_assert_held(&dev->lock);
 
@@ -1424,12 +1424,12 @@ gpio_virtuser_make_lookup_table(struct gpio_virtuser_device *dev)
 		return -ENOMEM;
 
 	list_for_each_entry(lookup, &dev->lookup_list, siblings) {
+		idx = 0;
 		list_for_each_entry(entry, &lookup->entry_list, siblings) {
-			table->table[i] =
+			table->table[i++] =
 				GPIO_LOOKUP_IDX(entry->key,
 						entry->offset < 0 ? U16_MAX : entry->offset,
-						lookup->con_id, i, entry->flags);
-			i++;
+						lookup->con_id, idx++, entry->flags);
 		}
 	}
 
-- 
2.39.5



