Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E42010A13;
	Sat,  3 Feb 2024 04:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933764; cv=none; b=DWMeCeXoISM+tfR5AF+I9bZiZ/7o8kDVzVfOux2vZps3pYb8p4sORaiuMI6TqQXRUCAZFi4DmKfLJzdpXTcnAIQxY2kzhkmS64lN3I0A4Bh209uB+Jq4b16iUpIRPuRYPCY2tJYBfohkhxFMfuyYyXRXpGZodATNAckxXZ90aOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933764; c=relaxed/simple;
	bh=RkYPKPKt4BqTl/K6NE5f3w/RkT8pglKJaCbYyrX/poI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLdZgAIb6kiLWdVM6rrQS3YCtkhp17Fv6ISv7AfOyJ3+rA0ok7UKz1y44ekMHRzobppB2i0PYsPWVeKy/9EBvpybcTLxVLsXYoeNUuOQkxcUgUgh6wyr0Gde2SU31+sW9s+al8/Y9LgWcZ02JVriEYENOEZZZC+DE6w9bhZtTgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vv8UTQgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vv8UTQgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36482C433A6;
	Sat,  3 Feb 2024 04:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933764;
	bh=RkYPKPKt4BqTl/K6NE5f3w/RkT8pglKJaCbYyrX/poI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vv8UTQgDu6oS4vAwqnADeIG5iQwx2YlkwD6XajL1bST8P3E+yugOfm7TK0bV6rovW
	 fd/G772WtnxC55X2qZ6HxwJGqDwBHtYoK7I7e9a6r10koPBbrOTasiGxKlNR5pIWzT
	 /XnnCQK4oToLig7dTZNiCJVhbYCMuobtesVfoBe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 028/353] OPP: The level field is always of unsigned int type
Date: Fri,  2 Feb 2024 20:02:26 -0800
Message-ID: <20240203035404.666361360@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit ba367479c7ad0b870461024cd5ae7a1ea6e1e3db ]

By mistake, dev_pm_opp_find_level_floor() used the level parameter as
unsigned long instead of unsigned int. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c     | 9 +++++++--
 include/linux/pm_opp.h | 4 ++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index b2971dd95335..f1e54a3a15c7 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -832,9 +832,14 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_level_ceil);
  * use.
  */
 struct dev_pm_opp *dev_pm_opp_find_level_floor(struct device *dev,
-					       unsigned long *level)
+					       unsigned int *level)
 {
-	return _find_key_floor(dev, level, 0, true, _read_level, NULL);
+	unsigned long temp = *level;
+	struct dev_pm_opp *opp;
+
+	opp = _find_key_floor(dev, &temp, 0, true, _read_level, NULL);
+	*level = temp;
+	return opp;
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_level_floor);
 
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index ccd97bcef269..18a102174c4f 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -157,7 +157,7 @@ struct dev_pm_opp *dev_pm_opp_find_level_ceil(struct device *dev,
 					      unsigned int *level);
 
 struct dev_pm_opp *dev_pm_opp_find_level_floor(struct device *dev,
-					       unsigned long *level);
+					       unsigned int *level);
 
 struct dev_pm_opp *dev_pm_opp_find_bw_ceil(struct device *dev,
 					   unsigned int *bw, int index);
@@ -324,7 +324,7 @@ static inline struct dev_pm_opp *dev_pm_opp_find_level_ceil(struct device *dev,
 }
 
 static inline struct dev_pm_opp *dev_pm_opp_find_level_floor(struct device *dev,
-							     unsigned long *level)
+							     unsigned int *level)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
-- 
2.43.0



