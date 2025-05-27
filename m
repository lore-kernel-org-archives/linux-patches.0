Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2335D3C01;
	Tue, 27 May 2025 17:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367268; cv=none; b=AC8z5pWhxZYHSL8EzyWsHe0lGZCs7r8xH5X4ErsdQY70gZ7uV8w8Dkbcb5hCCPowGO/nYOU49YMPgs+Yof56EJ3gyf4c1rC7yC4zXn+wvY7ZkofgKCWw8sdIHe6GOGiJuy4dlWUZxXH/kuDYrZmw78bbVtd8OBUKECLEvwSToV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367268; c=relaxed/simple;
	bh=kOTSqfuU1RBkqFXi7GTNEEpVbLpszwRccIlPFmsox3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8PxuXS6pRIGQ2mPndDs9A0QYrX1cko32fBrlgvqncY7juwuxxzY1DuMrQDo/Rg05rpCthQjCpRopW+tHlrxAzI8p0WckgtVIr8ogepbplJ0xw4my1lKkS04VaeZuOCK634IcrM0zXyFAg+8+MTh3o1XZpuipqUdtpQ8X4G1pfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RD9pzp9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RD9pzp9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9856BC4CEE9;
	Tue, 27 May 2025 17:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367268;
	bh=kOTSqfuU1RBkqFXi7GTNEEpVbLpszwRccIlPFmsox3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RD9pzp9Fbu6QTtURaGi0p/bOs1BP7ib4ts9BB8NX7FNJ90JcSu9yuVOa8Lr8Dmv4Z
	 TG3IqhAzY372rr7olIycs542tCt1Oki7xBFJgnkLPufwYoaP1S6wwIAKF3DketN48B
	 Kh3zDEf5fRwRaTdNHLgQ3eYSxt/prHSY0t+4ZW0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 332/783] driver core: faux: only create the device if probe() succeeds
Date: Tue, 27 May 2025 18:22:09 +0200
Message-ID: <20250527162526.581186954@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 21b0dc55bed6d9b5dd5d1ad22b75d9d1c7426bbc ]

It's really hard to know if a faux device properly passes the callback
to probe() without having to poke around in the faux_device structure
and then clean up.  Instead of having to have every user of the api do
this logic, just do it in the faux device core itself.

This makes the use of a custom probe() callback for a faux device much
simpler overall.

Suggested-by: Kurt Borja <kuurtb@gmail.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Reviewed-by: Kurt Borja <kuurtb@gmail.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/2025022545-unroasted-common-fa0e@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/faux.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/base/faux.c b/drivers/base/faux.c
index 531e9d789ee04..407c1d1aad50b 100644
--- a/drivers/base/faux.c
+++ b/drivers/base/faux.c
@@ -102,7 +102,9 @@ static void faux_device_release(struct device *dev)
  *
  * Note, when this function is called, the functions specified in struct
  * faux_ops can be called before the function returns, so be prepared for
- * everything to be properly initialized before that point in time.
+ * everything to be properly initialized before that point in time.  If the
+ * probe callback (if one is present) does NOT succeed, the creation of the
+ * device will fail and NULL will be returned.
  *
  * Return:
  * * NULL if an error happened with creating the device
@@ -147,6 +149,17 @@ struct faux_device *faux_device_create_with_groups(const char *name,
 		return NULL;
 	}
 
+	/*
+	 * Verify that we did bind the driver to the device (i.e. probe worked),
+	 * if not, let's fail the creation as trying to guess if probe was
+	 * successful is almost impossible to determine by the caller.
+	 */
+	if (!dev->driver) {
+		dev_err(dev, "probe did not succeed, tearing down the device\n");
+		faux_device_destroy(faux_dev);
+		faux_dev = NULL;
+	}
+
 	return faux_dev;
 }
 EXPORT_SYMBOL_GPL(faux_device_create_with_groups);
-- 
2.39.5



