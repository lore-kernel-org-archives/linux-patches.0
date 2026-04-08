Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D060B33121F;
	Wed,  8 Apr 2026 18:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674030; cv=none; b=mtvgWjubtizcK+q6NqAW+nLNiuA79qJNFGOOlm85bGHWMbLRmo1ogIZh1hjJ+7d9IXCl0Qxl1SdP+IEggmwhVu16z2+BV+1QZFBPTP7ejBg+lvAn34whcYZztbXnfidZQtqcbY/W89VSkuXPtuKaXct1dWTq9cES9mQEgRIE6SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674030; c=relaxed/simple;
	bh=XeinvHGMEVc+MdcshZZjADbPr8QsHbwp2hCyNPVSoP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fi8ZBfkQUR0SPNa43Q+6z1nm4bPb6f8qwuwr7D3oqexOMJ5t5hTBFee3GDiyhsF7yE5m8ZIliPo0hsAnI7J/wCujdwSmAU6QuWMQ8HMGQXw9cERetx1xUQQOCobCGFYqu8FdTz5EEpGc2cvpMRKaNf5wmJZX/8pOHeEqk43htFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aey5QAQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aey5QAQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF932C19421;
	Wed,  8 Apr 2026 18:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674030;
	bh=XeinvHGMEVc+MdcshZZjADbPr8QsHbwp2hCyNPVSoP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aey5QAQ7bAa7G7H0YhsKUKqATnYZMkeWzaoaXNNxLmAZfx4HVQxBNuo75CQbdw6qi
	 malhdFED9PPtPWEWclvuL3qthfIJk8vh9djyaTjPgx0rc+zsI6cj7ObxrrqMn1gLmV
	 v4DR4QoHZxXF0dcK/NOS63DZu3JrKDGe+SO/htPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.12 183/242] counter: rz-mtu3-cnt: prevent counter from being toggled multiple times
Date: Wed,  8 Apr 2026 20:03:43 +0200
Message-ID: <20260408175933.933255522@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

commit 67c3f99bed6f422ba343d2b70a2eeeccdfd91bef upstream.

Runtime PM counter is incremented / decremented each time the sysfs
enable file is written to.

If user writes 0 to the sysfs enable file multiple times, runtime PM
usage count underflows, generating the following message.

rz-mtu3-counter rz-mtu3-counter.0: Runtime PM usage count underflow!

At the same time, hardware registers end up being accessed with clocks
off in rz_mtu3_terminate_counter() to disable an already disabled
channel.

If user writes 1 to the sysfs enable file multiple times, runtime PM
usage count will be incremented each time, requiring the same number of
0 writes to get it back to 0.

If user writes 0 to the sysfs enable file while PWM is in progress, PWM
is stopped without counter being the owner of the underlying MTU3
channel.

Check against the cached count_is_enabled value and exit if the user
is trying to set the same enable value.

Cc: stable@vger.kernel.org
Fixes: 0be8907359df ("counter: Add Renesas RZ/G2L MTU3a counter driver")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Link: https://lore.kernel.org/r/20260130122353.2263273-5-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/rz-mtu3-cnt.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/counter/rz-mtu3-cnt.c
+++ b/drivers/counter/rz-mtu3-cnt.c
@@ -499,21 +499,25 @@ static int rz_mtu3_count_enable_write(st
 	struct rz_mtu3_cnt *const priv = counter_priv(counter);
 	int ret = 0;
 
+	mutex_lock(&priv->lock);
+
+	if (priv->count_is_enabled[count->id] == enable)
+		goto exit;
+
 	if (enable) {
-		mutex_lock(&priv->lock);
 		pm_runtime_get_sync(ch->dev);
 		ret = rz_mtu3_initialize_counter(counter, count->id);
 		if (ret == 0)
 			priv->count_is_enabled[count->id] = true;
-		mutex_unlock(&priv->lock);
 	} else {
-		mutex_lock(&priv->lock);
 		rz_mtu3_terminate_counter(counter, count->id);
 		priv->count_is_enabled[count->id] = false;
 		pm_runtime_put(ch->dev);
-		mutex_unlock(&priv->lock);
 	}
 
+exit:
+	mutex_unlock(&priv->lock);
+
 	return ret;
 }
 


