Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4304526B0BE;
	Thu, 13 Feb 2025 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459804; cv=none; b=tLJUr8DiSmWZYc0hS8HMQNjWutrHtonQyF73J/0ZFgTMX0jiDhf1KYxCmdYUmWboSe+s5+XGVUmHWIkYev2hggVonblQk8qO/75Snp3tT+sBkI8SybL3tlEEm99oiWclkrNDnh77ijwblXSkJDLtKCjCUi7cBWa1E7Ny0Sm84mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459804; c=relaxed/simple;
	bh=v5jcmLQUEY9iENr9stj54EME+7UJZOI/qGYxu7lO2hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yp+VFqmfzFj+morzZRGuQ8Tc9GZIDvZqcoKJOj9yIkM0Xo3K0LWmNw1DGHSGSy4ob0AtynxMnRtHK3uD+LSpo904vE1Z2VtfrZqeNZ6UVq4SgJkaBlxrZdboXWLLB62Qe0rKWg2G9ubXZlmIAYsKE8EVDmm5548obQ9HMBq+eDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtBJ7Z/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtBJ7Z/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A413C4CEE5;
	Thu, 13 Feb 2025 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459803;
	bh=v5jcmLQUEY9iENr9stj54EME+7UJZOI/qGYxu7lO2hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtBJ7Z/mD+9knIiPO+3k+jfwsRlruldZ5gWhdYrXBp/3pOwGViOPKzEOMKT1tiRvB
	 ZGvF135WxLMUMg86IWV/W5rxsX4xurbJ4WaDPcYsqLZm0nbguE4DIQ25wtEw9Ffj7q
	 qpdbL3GncGHBF5+qqqSFC2kGeInXpxFqHVmmM7hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 368/443] media: i2c: ds90ub960: Fix use of non-existing registers on UB9702
Date: Thu, 13 Feb 2025 15:28:53 +0100
Message-ID: <20250213142454.810935952@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 698cf6df87ffa83f259703e7443c15a4c5ceae86 upstream.

UB9702 doesn't have the registers for SP and EQ. Adjust the code in
ub960_rxport_wait_locks() to not use those registers for UB9702. As
these values are only used for a debug print here, there's no functional
change.

Cc: stable@vger.kernel.org
Fixes: afe267f2d368 ("media: i2c: add DS90UB960 driver")
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub960.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/media/i2c/ds90ub960.c
+++ b/drivers/media/i2c/ds90ub960.c
@@ -1576,16 +1576,24 @@ static int ub960_rxport_wait_locks(struc
 
 		ub960_rxport_read16(priv, nport, UB960_RR_RX_FREQ_HIGH, &v);
 
-		ret = ub960_rxport_get_strobe_pos(priv, nport, &strobe_pos);
-		if (ret)
-			return ret;
+		if (priv->hw_data->is_ub9702) {
+			dev_dbg(dev, "\trx%u: locked, freq %llu Hz\n",
+				nport, (v * 1000000ULL) >> 8);
+		} else {
+			ret = ub960_rxport_get_strobe_pos(priv, nport,
+							  &strobe_pos);
+			if (ret)
+				return ret;
 
-		ret = ub960_rxport_get_eq_level(priv, nport, &eq_level);
-		if (ret)
-			return ret;
+			ret = ub960_rxport_get_eq_level(priv, nport, &eq_level);
+			if (ret)
+				return ret;
 
-		dev_dbg(dev, "\trx%u: locked, SP: %d, EQ: %u, freq %llu Hz\n",
-			nport, strobe_pos, eq_level, (v * 1000000ULL) >> 8);
+			dev_dbg(dev,
+				"\trx%u: locked, SP: %d, EQ: %u, freq %llu Hz\n",
+				nport, strobe_pos, eq_level,
+				(v * 1000000ULL) >> 8);
+		}
 	}
 
 	return 0;


