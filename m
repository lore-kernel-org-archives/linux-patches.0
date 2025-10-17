Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EF02F12CF;
	Fri, 17 Oct 2025 15:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713738; cv=none; b=CkkIgpEk/6qo/sDMPRQY8ZMlWxoYRQznbyZ1g5T1dDytpdSaoTahshOd34iZSEAGTjwGqWe3bNQz3m3Z5nGGM5yaMY55oqw8cwdPCCnFaN1yEQf6WPWgU+1IKZeyMlFEvU28C/IY0cr/kG9m5GlBCX2k5HoFbyKx99qFQijimhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713738; c=relaxed/simple;
	bh=fL6FuuMvOCJJ7UodCKlCl9NlEfoobFOfv5X8KSxyNOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqs14ZB8EEui8u1oO26QBOmcUrRkznfne1FDDADC1d06oKUDKXvFITxC9DvBC+9isUDxkzXdaBIIaLNhhDCYopYNfWR3YOwb3hUYx+9eNNH5oY9G6LXRObRwdjRb5+BgDYJ/jbE19GiZEwYSZRQFDNFwProXHQrKuOFnhxTfIAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzLBoEDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzLBoEDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2F2C4CEE7;
	Fri, 17 Oct 2025 15:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713738;
	bh=fL6FuuMvOCJJ7UodCKlCl9NlEfoobFOfv5X8KSxyNOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzLBoEDKOmB/POAUeU9i2v7Xe5VDtMUF+XNfJrcgkZpBYGMG6neHYV+QLUOonc3C6
	 wxhrTw1cyVVkPrpxdl2Ps/teqPKF0qxeAHcnEk6skdaITFPJdaPk/rXlGx7aapphdI
	 haeDz7RcBQD1vnRXqSdue2n8mbH62tAdEHHCe9lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 102/201] of: unittest: Fix device reference count leak in of_unittest_pci_node_verify
Date: Fri, 17 Oct 2025 16:52:43 +0200
Message-ID: <20251017145138.495482537@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit a8de554774ae48efbe48ace79f8badae2daa2bf1 upstream.

In of_unittest_pci_node_verify(), when the add parameter is false,
device_find_any_child() obtains a reference to a child device. This
function implicitly calls get_device() to increment the device's
reference count before returning the pointer. However, the caller
fails to properly release this reference by calling put_device(),
leading to a device reference count leak. Add put_device() in the else
branch immediately after child_dev is no longer needed.

As the comment of device_find_any_child states: "NOTE: you will need
to drop the reference with put_device() after use".

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 26409dd04589 ("of: unittest: Add pci_dt_testdrv pci driver")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/unittest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -3957,6 +3957,7 @@ static int of_unittest_pci_node_verify(s
 		unittest(!np, "Child device tree node is not removed\n");
 		child_dev = device_find_any_child(&pdev->dev);
 		unittest(!child_dev, "Child device is not removed\n");
+		put_device(child_dev);
 	}
 
 failed:


