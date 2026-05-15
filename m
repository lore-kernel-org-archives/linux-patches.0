Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A28D305689;
	Fri, 15 May 2026 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860658; cv=none; b=cJHRCAw4OSqoNbgtn7T1O6qxDLcPLArWf9gGtdDDN69s06Jam1yBIMgFnq76UO1WT4Givx1x+/gYMSwik/XxzaRQzRIO+qsNK+GP0+7mO7PdaFRcW+xU0dr4hZEtsD29LEMuRnwUbzNqMkK6v6+kxYUykRYrbF3bthcyO14AGjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860658; c=relaxed/simple;
	bh=djga6KUnhJ1LPz+6Z3MMVCD7g++8osPA2AlZAoJsbuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOBbUo9sgC0iuDPTSb013bq7HGwLQ3FjdlYRezN/ReS/o4MU8exyd/eQJvz3SZXs5TMF0E+AVZ3v+tcf7rQIxQ3y/lMqmZqNi6LzMnmkffjGHz/zCS0pn63SPF97Ymxr3D0SOMSa8yD4aRHYApe/WTvjDRfu/JfZkfCohQXaQRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YM6PkozR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YM6PkozR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5433C2BCC7;
	Fri, 15 May 2026 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860658;
	bh=djga6KUnhJ1LPz+6Z3MMVCD7g++8osPA2AlZAoJsbuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YM6PkozR20+YbYnBTwAycF3YDfD6bWRpwVJ/rtSHbpdIw2h75MsWLAdhpEUmiA4Ww
	 wkdOeeqa/ecMz5uEkzb6qPLCc3TaP4wtBo1UZ3ixGtiJ35TtjYjMyLls3EliiZbuPZ
	 64gpRDLXg3IQeJrE9N/q3f7379b9LJYWKoGe9Has=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 030/474] of: unittest: fix use-after-free in testdrv_probe()
Date: Fri, 15 May 2026 17:42:19 +0200
Message-ID: <20260515154715.702159093@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -3862,7 +3862,6 @@ static int testdrv_probe(struct pci_dev
 
 	size = info->dtbo_end - info->dtbo_begin;
 	ret = of_overlay_fdt_apply(info->dtbo_begin, size, &ovcs_id, dn);
-	of_node_put(dn);
 	if (ret)
 		return ret;
 


