Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9521D0492;
	Tue, 15 Oct 2024 11:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993389; cv=none; b=HeYimIW17Czis3tYNPJtMZO4HdGs10lGoPm2cBTQgr1c3q/LgvmceuBhYJX1UlwP3sMmw/X2e+cdUHIOS1Uz8uqn5UHAl5rbSMkEBB+M1X644CwfRwIngRYKbJPcziHRzW+NqTNB+pfGy5usmWE/tpBRRRBNVVagFE4pOGX9zeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993389; c=relaxed/simple;
	bh=JK3P0lcWxxbXMxiF5dk7CypeLa0p+JeLU3ah85Zl84A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngKxix4zt0vpCXt/fx4SHW/0aadQYRO6TMHcyaNEw1zspLo0ei709HP1o2n3SScShph1Dffn9WUPNtouqnCYfy5O10WRBmertKUJxnJHChRn1FAAhPXCTuNJeqptJb9Ia0ys27js+K1UF/m85j+XbHIhJeHp4oNG6kUqbk/5+2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0Tw8sJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0Tw8sJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C097C4CEC6;
	Tue, 15 Oct 2024 11:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993389;
	bh=JK3P0lcWxxbXMxiF5dk7CypeLa0p+JeLU3ah85Zl84A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0Tw8sJjpaz0dAYV2/DslF8aIiEQkSnGwjGEEjvWxVKiyU9J+RrZuBq/fmdFHvtg8
	 +U87msr6E2fGiiCyU1PqGrZlIEfopQZ6KlpwgoWI1nF+sNhOjr6XfUBxxIvWoutlu5
	 Xmu3yk5C7zXk5CiH/ICAtG/MSrkREI+qhFRVL9Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michal Simek <michal.simek@amd.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 397/691] i2c: xiic: xiic_xfer(): Fix runtime PM leak on error path
Date: Tue, 15 Oct 2024 13:25:45 +0200
Message-ID: <20241015112456.096309946@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit d663d93bb47e7ab45602b227701022d8aa16040a ]

The xiic_xfer() function gets a runtime PM reference when the function is
entered. This reference is released when the function is exited. There is
currently one error path where the function exits directly, which leads to
a leak of the runtime PM reference.

Make sure that this error path also releases the runtime PM reference.

Fixes: fdacc3c7405d ("i2c: xiic: Switch from waitqueue to completion")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 1d4a1adbed25 ("i2c: xiic: Try re-initialization on bus busy timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 3444e4d017f7f..695233db07acd 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -744,7 +744,7 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	err = xiic_start_xfer(i2c, msgs, num);
 	if (err < 0) {
 		dev_err(adap->dev.parent, "Error xiic_start_xfer\n");
-		return err;
+		goto out;
 	}
 
 	err = wait_for_completion_timeout(&i2c->completion, XIIC_XFER_TIMEOUT);
@@ -762,6 +762,8 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 		err = (i2c->state == STATE_DONE) ? num : -EIO;
 	}
 	mutex_unlock(&i2c->lock);
+
+out:
 	pm_runtime_mark_last_busy(i2c->dev);
 	pm_runtime_put_autosuspend(i2c->dev);
 	return err;
-- 
2.43.0



