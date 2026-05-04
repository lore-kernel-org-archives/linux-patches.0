Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1914535A3AD;
	Mon,  4 May 2026 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903740; cv=none; b=n9jBEIYQn+8J6jFO31IcOtUmhP9ye3o1ZLCvYNz8GlvkZqaXAw3LEhst7v7bX4MDqnTay0qdE2QbUtEpY0rcRoL/iB/a4rxn3O7eJJ8AldwgAFxdChlorIf3i7jBg0Pc4PwAMn8dzsaw+I0OS0BQ4yKLVSO7XzvYOS34wHRdiGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903740; c=relaxed/simple;
	bh=1wjqdvODXZ0FEgY7+hnd53hiIZwywKokvieBLntDNSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjDV8WmqU4yfagEqXmf24Zzo6+WPizljLafkJOUT9TneUoLGCmpPKufj0a106tz86BTvDhdWoW2S+nlA9zPAhWsQ39D55tpUTWnjLAfi+1xU7pPpfJKi+grgP4FYmHH48SN+H8rg8CmPHorMVM0107AEs7cm83qTS+6mI79xGCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1lW3EV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1lW3EV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96134C2BCB8;
	Mon,  4 May 2026 14:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903739;
	bh=1wjqdvODXZ0FEgY7+hnd53hiIZwywKokvieBLntDNSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1lW3EV4gkMukSS1PLh4EFlMeC9byjghVYmWWuMei/YNgaskyfHDJgRU+etbzQst3
	 O8Cw1VtC/nSp/P2GHb9hHx7Pb0gcujQAmUdBBkJJl9FChmmVzjf3iFeA9pauTma1wz
	 VRa56M5Mi2n2ThBBs58lY7AzalAnEE7K/jFxmueM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 043/275] of: unittest: fix use-after-free in testdrv_probe()
Date: Mon,  4 May 2026 15:49:43 +0200
Message-ID: <20260504135144.542518896@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 07fd339b2c253205794bea5d9b4b7548a4546c56 upstream.

The function testdrv_probe() retrieves the device_node from the PCI
device, applies an overlay, and then immediately calls of_node_put(dn).
This releases the reference held by the PCI core, potentially freeing
the node if the reference count drops to zero. Later, the same freed
pointer 'dn' is passed to of_platform_default_populate(), leading to a
use-after-free.

The reference to pdev->dev.of_node is owned by the device model and
should not be released by the driver. Remove the erroneous of_node_put()
to prevent premature freeing.

Fixes: 26409dd04589 ("of: unittest: Add pci_dt_testdrv pci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260409034859.429071-1-vulab@iscas.ac.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/unittest.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -4202,7 +4202,6 @@ static int testdrv_probe(struct pci_dev
 
 	size = info->dtbo_end - info->dtbo_begin;
 	ret = of_overlay_fdt_apply(info->dtbo_begin, size, &ovcs_id, dn);
-	of_node_put(dn);
 	if (ret)
 		return ret;
 


