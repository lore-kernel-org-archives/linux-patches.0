Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43D7583AC3;
	Wed,  9 Sep 2026 14:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963502; cv=none; b=NSUSOmmFaTgmR7eAumon0NKSSbCgNT0vJ2d6sfsV6OkCn2AgKIuDzQEV+4lqN5SvVorxaXZpv2hEWt5WVqkzwh2DmxBNa8O9gzUGQE0lmvxR/ZSyIva7xMzgCdvPm11Yrt0+2d8GKxZsyTKPPXnT/YXHQOCxCqvkcZuDJ00zLyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963502; c=relaxed/simple;
	bh=L9esb8OmubAwHJPsuzh3f3iZtQLi4Ey0cuc5AFsBXtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO0xGXmt71aOc+Uod5EgnN+YLSeuTP3XUKI50tkeOQ1E7fPNEPMGne7Lq+eGr0ztdKUsM0Ud7uau9FoJe+ouP0zvewWgeXZhMwd45OMbEFXW8NbU+VbtvlW5HqPSuO1qtki7dFxL7H6K3PrXNAtVgs2nug7QH1TGiNB/aTG3cpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrPaBuOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrPaBuOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9581F00A3A;
	Wed,  9 Sep 2026 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963500;
	bh=6Zm5+N4xi8gr+MWd3k8qPzo2OGycKHbiW+XX2d3ZcwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrPaBuOYzZxZkiZFu9CS6jB1IyfSwQmXZtE6KxdKSw/xEebuWM1TkWKj4k1k7xvbs
	 P4cvFH788vlO0IKw2koBFUGSfAXlTaca6SS/W1TIND2xuBeTbC9rHYsJIh8F81lp/2
	 FboJuL1T3m3ttT9ULm2rOVTCoBCQeg0fhZk7Yui4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Peter Rosin <peda@lysator.liu.se>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 100/583] i2c: mux: Fix channel node leak on adapter add failure
Date: Wed,  9 Sep 2026 15:36:25 +0200
Message-ID: <20260909134241.593230323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Ahmad Byagowi <ahmadexp@gmail.com>

commit 385c7af4e3b95d0769fd211831674e83b16a2ebf upstream.

i2c_mux_add_adapter() takes a reference to the Device Tree channel node
before registering the new adapter. If adapter registration fails, the
error path frees the private data without dropping that reference.

Release the channel node before freeing the private data.

Fixes: bc45449b1444 ("i2c/of: Automatically populate i2c mux busses from device tree data.")
Signed-off-by: Ahmad Byagowi <ahmadexp@gmail.com>
Cc: <stable@vger.kernel.org> # v3.5+
Acked-by: Peter Rosin <peda@lysator.liu.se>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/b3e46bbee781b3cb4029aca9a71316cc5e36dc17.1787502619.git.ahmadexp@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-mux.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -408,6 +408,7 @@ int i2c_mux_add_adapter(struct i2c_mux_c
 	return 0;
 
 err_free_priv:
+	of_node_put(priv->adap.dev.of_node);
 	kfree(priv);
 	return ret;
 }


