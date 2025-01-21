Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D8B1F472D;
	Tue, 21 Jan 2025 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482724; cv=none; b=GtxlOrxLvHKx1NwS0F+IfZT9FSNVEj1zzDBtZfRCI4+yqSrzFwyJMt28CQhOHtqoGiJCtJpnmgPS7Rse0RWB7yvejruRQnLdY7qGyvHJXGEooONEwOO8c2Yap/Z1JeBCgF79kpOaeuFFBMeB4S/AXz1gG5sr42rxKq7TmE8Bmi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482724; c=relaxed/simple;
	bh=fLXYgzZeui2qdx7G3ydbiZCdTkEQ0Oc/4+dPAAY72t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liRH+++aqTVQJSx0KZpedpZsaf4kMHvFNyQfqIW3YPYpEaO6XcqnXtjNPTW1GQEXI7wYiqDFRKAc46wYwbKZ2EVMP/2KavwkqvGH9yqsfNU06bhLWSI5K31y2qhIi6ti74dGiM9ywl/bDavuSzScZgZA52ftn4K0ehoqYdN55Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAEy9x8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAEy9x8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6FEC4CEDF;
	Tue, 21 Jan 2025 18:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482724;
	bh=fLXYgzZeui2qdx7G3ydbiZCdTkEQ0Oc/4+dPAAY72t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAEy9x8mUjdstZxJigZhZVhokHvYcHQzgkgfqYUPwb7nB2Snrt1RawagxMuK9N3kj
	 3kUWl3FS360yxJ1RNHCWWyhAK6ZotBHoHU6WVyNiTTN7/qzv/P+NoycBJdELI+Nyk6
	 UcrUWULNhhXeBp/Bqdg8b9q1GUxccmyFhREfn7D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Bin Lan <lanbincn@qq.com>
Subject: [PATCH 6.1 51/64] iio: adc: rockchip_saradc: fix information leak in triggered buffer
Date: Tue, 21 Jan 2025 18:52:50 +0100
Message-ID: <20250121174523.496379060@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 38724591364e1e3b278b4053f102b49ea06ee17c upstream.

The 'data' local struct is used to push data to user space from a
triggered buffer, but it does not set values for inactive channels, as
it only uses iio_for_each_active_channel() to assign new values.

Initialize the struct to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: 4e130dc7b413 ("iio: adc: rockchip_saradc: Add support iio buffers")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-4-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Bin Lan <lanbincn@qq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rockchip_saradc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -270,6 +270,8 @@ static irqreturn_t rockchip_saradc_trigg
 	int ret;
 	int i, j = 0;
 
+	memset(&data, 0, sizeof(data));
+
 	mutex_lock(&i_dev->mlock);
 
 	for_each_set_bit(i, i_dev->active_scan_mask, i_dev->masklength) {


