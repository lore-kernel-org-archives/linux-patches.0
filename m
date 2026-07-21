Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1428337DE8D;
	Tue, 21 Jul 2026 20:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665168; cv=none; b=X7WEYckrWgRu2qDkU6aVWqPPSGwAhJLxy+K6Uj842bRXca8X2uZ4nIHPo4ka28mwAG9XStCu04u1P76xPQhJBRm2Mw+6g8+rywm2zy1ukB3bo0k/cj2yIfSXZFQfmGbrV571XDPAM5MxqhJw5vG+cC2cbk+aWnS9311tZ8eE5DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665168; c=relaxed/simple;
	bh=yn1el+j8198a7vlpQnFcwspD4aSyyQnQGEYL1JANDjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJn75u8hcCGZItckzPBaEyUcwbt+/p7IVqj1K1t8HNK7o1of3q+6PrV3pOqzTelRkkyNwgWIEmSmBXxc0uN0w0JyGAgX78ktyJyNVajlZfQ1XanlbnMMHzxq/wns/zlsPtoCRjD20urj90jXUjVFh+aYdnvd5p5bkxv8ij+pAx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f44JmvF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f44JmvF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7985A1F000E9;
	Tue, 21 Jul 2026 20:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665167;
	bh=oLqO8FJZLhh4uBZ4n4HQ14t7Cp4UGMv/xOZWBqzGqms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f44JmvF5uy2vu9C2SE6ZatbRbgpgnBrZon86nzk2o2Xx86kJd4SE3KM+qpX5pVctD
	 9Kwhkb7UHee7qylcJSl1ZGhr/t1PNtBB1PxLlrqCUGzgxNL6KkMlmcqTbjV9NtaRQi
	 CcgofRSusUjeImKPvSfdZxr+xxsKDVFxBeuOqeBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.6 0202/1266] OPP: of: Fix potential memory leak in opp_parse_supplies()
Date: Tue, 21 Jul 2026 17:10:39 +0200
Message-ID: <20260721152446.328287890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 69f888381d2ecbe18ed9f112c096f8fd3623db98 upstream.

The memory allocated for microvolt, microamp and microwatt is not freed
in one of the paths in opp_parse_supplies() which returns directly.
Fix that by adding a goto to the error unwind ladder.

Fixes: 2eedf62e66c2 ("OPP: decouple dt properties in opp_parse_supplies()")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/opp/of.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -710,7 +710,7 @@ static int opp_parse_supplies(struct dev
 	 */
 	if (unlikely(opp_table->regulator_count == -1)) {
 		opp_table->regulator_count = 0;
-		return 0;
+		goto free_microwatt;
 	}
 
 	for (i = 0, j = 0; i < opp_table->regulator_count; i++) {
@@ -733,6 +733,7 @@ static int opp_parse_supplies(struct dev
 			opp->supplies[i].u_watt = microwatt[i];
 	}
 
+free_microwatt:
 	kfree(microwatt);
 free_microamp:
 	kfree(microamp);


