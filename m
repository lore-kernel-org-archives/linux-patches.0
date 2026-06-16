Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0EC449EAB;
	Tue, 16 Jun 2026 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624268; cv=none; b=jzjX+LzvIJYn5Q/wL38tLqw4qo+2ahezcSuJvu3leROYKqimqMYjS5W9Hwku56WMF6g6sxi5IH5dmYtIGrI0uBQsC9RcyK4WpAwIwAAPMszIn1qRim1mgvo53KVj528pmgCqWLVu06suN0a5XkOQ0UXfeDSob8K+V0nYdfUUG+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624268; c=relaxed/simple;
	bh=58MX9IFulDpPp7EmCstPTfCn2PaWb2EkF5ym5MFW/x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9nqlGzsRr3YAl46ooc9WBGepfJWLfD8qVFMRpGIFpWUqI9XJi67JCmA8Z/L8Sinb8ezR4JyRtKhPbW8ibBeBoqk7QfbnPoAjfI5EohMtVjJRtglaW+eHg59KwF17UJzIhy13rJQC3PHu5cSeJvA1giCpTE5VoO6DUxv6L/Af7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fK0vHE9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK0vHE9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF7E1F000E9;
	Tue, 16 Jun 2026 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624267;
	bh=pXKQkHdB0ik7WvyIQcTidawjKDNq4vZ17gxjFZYNOUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fK0vHE9Zmtq8uHwoK1RclNfTG6zlyqryqCws6NxhHDim4Xm3msZlILw5M5BSs2m7E
	 GvrTAb/zM1vu56bGyPJFfyjMWWkSZNdw4EYvAxFf3BSaptyY7jhnh/hF1oavn4CDe4
	 H3t/0MT3KWj8kFVv6k7846InYmRnv+6P0b5fnmxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.0 271/378] i2c: qcom-cci: Fix NULL pointer dereference in cci_remove()
Date: Tue, 16 Jun 2026 20:28:22 +0530
Message-ID: <20260616145124.376033950@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

commit 729ac5a4b966aac42e08a94dea966f4429008548 upstream.

On all modern platforms Qualcomm CCI controller provides two I2C masters,
and on particular boards only one I2C master may be initialized, and in
such cases the device unbinding or driver removal causes a NULL pointer
dereference, because cci_halt() is called for all two I2C masters, but
a completion is initialized only for the single enabled master:

    % rmmod i2c-qcom-cci
    Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
    <snip>
    Call trace:
    __wait_for_common+0x194/0x1a8 (P)
    wait_for_completion_timeout+0x20/0x2c
    cci_remove+0xc4/0x138 [i2c_qcom_cci]
    platform_remove+0x20/0x30
    device_remove+0x4c/0x80
    device_release_driver_internal+0x1c8/0x224
    driver_detach+0x50/0x98
    bus_remove_driver+0x6c/0xbc
    driver_unregister+0x30/0x60
    platform_driver_unregister+0x14/0x20
    qcom_cci_driver_exit+0x18/0x1008 [i2c_qcom_cci]
    ....

Fixes: e517526195de ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260515234121.1607425-2-vladimir.zapolskiy@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -663,8 +663,8 @@ static void cci_remove(struct platform_d
 		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
 			of_node_put(cci->master[i].adap.dev.of_node);
+			cci_halt(cci, i);
 		}
-		cci_halt(cci, i);
 	}
 
 	disable_irq(cci->irq);


