Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3A143E490;
	Tue, 16 Jun 2026 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629658; cv=none; b=kkHXsf2gHmqvvxu1k5XlJoEnhvEmhEevhxQPyqW1w7YdqTUbBZx4/aT/l5EJJcsvaXhc5OnTplVYGEzgFCvZpQ7XZXKcr62pALG7rse1UQOVANVTwF39LHBvSKuoB7+uahtZOpe1zCngkmj6DryDmtt67buFAHkd4Chnf3Kan5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629658; c=relaxed/simple;
	bh=6AdZ+1/f/vl9U5HeeSRgoqN4uQ9RqOvsu992NsJEkqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJuPVInldn2wsTP98z8zvwBsH4T6jRcJF89PQInEanDx05YAH1IJrQ7HPFldFogHXpY3m5bIY5cGHhbwA3Zgt4RaF1ExjOV4fWgYvBSQ2Ul06NJnzHhDDWicZoktW66a5wVOjfo4v3EzbkmVk82zmlj0OmO8uTPIlUNHpkoQhn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6dUsuVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6dUsuVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7029B1F000E9;
	Tue, 16 Jun 2026 17:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629657;
	bh=Ok2igBy5IhTCxpmzDgsFXvjxRkg/R8jloUzMcLelNaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6dUsuVcV6syAc5ykuMGSD/isi6prHiRVhemmC7jKlDFcdCfxs91xrRPI0pAY2cY9
	 loCa6b5rHmElQ58bLjsu0uHYuop9j+9c8JT5Lpsjk3EwivsGHF7fta84HMeBAklTf8
	 BNatbfPRbl0ulwImFjLBwsEneqt5EUsMR4WRAcXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 327/452] i2c: qcom-cci: Fix NULL pointer dereference in cci_remove()
Date: Tue, 16 Jun 2026 20:29:14 +0530
Message-ID: <20260616145134.575373809@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -683,8 +683,8 @@ static void cci_remove(struct platform_d
 		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
 			of_node_put(cci->master[i].adap.dev.of_node);
+			cci_halt(cci, i);
 		}
-		cci_halt(cci, i);
 	}
 
 	disable_irq(cci->irq);


