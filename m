Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9C7321F4C;
	Mon, 18 Aug 2025 13:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523002; cv=none; b=e8VcL2yBzlBietKMCKyvWmBwUAJTd/NPLO008sP3SNdow+NpUCTJ02RrosW2QJ/5J0Lm1ksMDK4+xOopi0FLLt7LeGCdbKjvwXzufK8CTzpZ+a2an22uxGAiXcWzt8CpM26rMhwA1Zqs1LFlKP/qhTkmeuue0BNLglsP4kaRPPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523002; c=relaxed/simple;
	bh=LxBhDTf0sdMxIqlSD8VnQEmChA94TRxC7QiNlx4s4cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GY4F56Vn3m45srlld9zgJw9ScgIx+k1FsHWbsyMXbKG5Txz/rIgAC6iAw0kkX6NR7jd+dVBGfZqO3/RBWiMOUe6oqPTMq3AVW9xS74raRce4T68IwhwKvVdGJ1sVAiEO6+nF0lWASVpo8HgmL/902GOmRe4GpXu9CWTXzu30hqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVPWlAWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVPWlAWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491DBC4CEEB;
	Mon, 18 Aug 2025 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523002;
	bh=LxBhDTf0sdMxIqlSD8VnQEmChA94TRxC7QiNlx4s4cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVPWlAWtC+tq+kY9pL4I8eyiF5AcKHZABNbVWtcSC4rL7r5Da7HCC4B8mC4qfnUT6
	 CAgi5DWHjDfTzJNcuC8Jpt3HtvYicidaEHOk1xXANS9a3kK9V4k4CgQrDf3pCVdFMN
	 I45W2hjQP2DhALTNS39aQSFeWxvhWi/xXZeS/8DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 039/515] sunvdc: Balance device refcount in vdc_port_mpgroup_check
Date: Mon, 18 Aug 2025 14:40:25 +0200
Message-ID: <20250818124459.943674239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 63ce53724637e2e7ba51fe3a4f78351715049905 upstream.

Using device_find_child() to locate a probed virtual-device-port node
causes a device refcount imbalance, as device_find_child() internally
calls get_device() to increment the device’s reference count before
returning its pointer. vdc_port_mpgroup_check() directly returns true
upon finding a matching device without releasing the reference via
put_device(). We should call put_device() to decrement refcount.

As comment of device_find_child() says, 'NOTE: you will need to drop
the reference with put_device() after use'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 3ee70591d6c4 ("sunvdc: prevent sunvdc panic when mpgroup disk added to guest domain")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://lore.kernel.org/r/20250719075856.3447953-1-make24@iscas.ac.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/sunvdc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -957,8 +957,10 @@ static bool vdc_port_mpgroup_check(struc
 	dev = device_find_child(vdev->dev.parent, &port_data,
 				vdc_device_probed);
 
-	if (dev)
+	if (dev) {
+		put_device(dev);
 		return true;
+	}
 
 	return false;
 }


