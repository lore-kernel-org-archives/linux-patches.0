Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46C41F55E3;
	Tue, 21 Jan 2025 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483104; cv=none; b=AvJgNXR2vwhYq1NpCdDPw0ny9h/ln14nu0QVu89Aqz8h2rFKstXfkC715R8UdGqYOC/coChIEeUyqizcIB58JrjAyk9MmqKL37/c7NcaAafg24jxM2hitab/QPuU/uhFhJ1wZAoOKnR0ZUqPedjlvjxLx+AnKhiWMzl8ICzEpac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483104; c=relaxed/simple;
	bh=DsmB++5QrzVLYj/5pEQvrpQkWy8P2HzUq8xDSBg+li0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJ/p970IrvlOAfqlzeBv1WtWOKExsbSGyUTriWjy3q8l6wnK+2biziWh9SLb/thA/ZOp5lz9D5lEW1TP1M2XdRWBloNyf1BPAAC5TQsPL58CfGZlb2oE7B0B+9SA9zp9OFjDhkHAUWw2kBEnDKQ5HPrq11t4X/cgIeUczV5YuGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufDsJ9Cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufDsJ9Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4729FC4CEDF;
	Tue, 21 Jan 2025 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483104;
	bh=DsmB++5QrzVLYj/5pEQvrpQkWy8P2HzUq8xDSBg+li0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufDsJ9CdUdaouwwPZezQhjV98KGdGWXN7v6llvikwBzJKxvB/74CPkNt7HcBG7h15
	 n54SsvGOfg/uLVv+K9JiOteS30GVUIPDAhLA1MAbvLuVmO8sYX2SxJZo6cRyLQ8me+
	 BhhAhHEtsxI6781icUESSJhKqa9NeBn6tJXDwL2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Bin Lan <lanbincn@qq.com>
Subject: [PATCH 5.15 118/127] iio: adc: rockchip_saradc: fix information leak in triggered buffer
Date: Tue, 21 Jan 2025 18:53:10 +0100
Message-ID: <20250121174534.190817480@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


