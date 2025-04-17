Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA7F2571DC;
	Thu, 17 Apr 2025 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916152; cv=none; b=jugijHlaQ6UR1Kfc81uEQqB2yO7vIUfD47qRvpuWV2/W1WvdKcm9kmkB/khEhjBvWU8FlJUzE+jCL7nYX6f9LL2O/u8+VZpy70jfsM3AqGPrfaCQZ+JzmS+EaHSHC5qGbEFylVylmYfY3T5A13rdYCAFHJdeN213WoqHCCnOwJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916152; c=relaxed/simple;
	bh=1qFspwgA0zb7GlKqXH223ITDiyVKjy0eBKgRBqluiFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql4WE8JWc15PBThQF58T2YXpyMpYBLVBUiCdkqQWWbjbsE3MWT4+qqBtKXW8mapfqGH6ouMJ8dCwLIlhuOuXHFFKvYIVJhmsxNpWLo/eWRMg+P5BoAmstff/IcjPpug3sT8+Fj0+fVfXo/o3ZNPDG7iZNL7bql/MHMKvdT6PHw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYwnl4A1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYwnl4A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EC2C4CEE7;
	Thu, 17 Apr 2025 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916152;
	bh=1qFspwgA0zb7GlKqXH223ITDiyVKjy0eBKgRBqluiFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYwnl4A1Dk4Ojmj0CpAfVuSTgxU24s86JcDuzKDM5cX0B59XcNacuGbmNZYygEkwh
	 BINY7nrZe8PkC+31+zULseraYm+IWxorKIjgd6GTJuni+6nUt+w4co79bai/odbBdM
	 eXCqK0IEz3dkJZ+8/olnq+b4/FPI+YA4VJtroHXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 361/393] of/irq: Fix device node refcount leakages in of_irq_init()
Date: Thu, 17 Apr 2025 19:52:50 +0200
Message-ID: <20250417175122.116057737@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 708124d9e6e7ac5ebf927830760679136b23fdf0 upstream.

of_irq_init() will leak interrupt controller device node refcounts
in two places as explained below:

1) Leak refcounts of both @desc->dev and @desc->interrupt_parent when
   suffers @desc->irq_init_cb() failure.
2) Leak refcount of @desc->interrupt_parent when cleans up list
   @intc_desc_list in the end.

Refcounts of both @desc->dev and @desc->interrupt_parent were got in
the first loop, but of_irq_init() does not put them before kfree(@desc)
in places mentioned above, so causes refcount leakages.

Fix by putting refcounts involved before kfree(@desc).

Fixes: 8363ccb917c6 ("of/irq: add missing of_node_put")
Fixes: c71a54b08201 ("of/irq: introduce of_irq_init")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-7-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -632,6 +632,8 @@ void __init of_irq_init(const struct of_
 				       __func__, desc->dev, desc->dev,
 				       desc->interrupt_parent);
 				of_node_clear_flag(desc->dev, OF_POPULATED);
+				of_node_put(desc->interrupt_parent);
+				of_node_put(desc->dev);
 				kfree(desc);
 				continue;
 			}
@@ -662,6 +664,7 @@ void __init of_irq_init(const struct of_
 err:
 	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
 		list_del(&desc->list);
+		of_node_put(desc->interrupt_parent);
 		of_node_put(desc->dev);
 		kfree(desc);
 	}


