Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDC43FBB6D;
	Fri, 15 May 2026 16:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861304; cv=none; b=X8rf4aKZC9dJGbcR0cuZj+9iTzpndfuPyLMrhSPDoXdlR+WTh5/TYRCcO7vLu5BUjjNzxMw5rx6uewrgq4KUFaJcH6FVSmguvyIy1bJPdHO+Kwef5x5kGaTvOioh1I/kqqkLgcFwvjpnddu+A2S/AyqYq7ELN3MSZ44qlp77wZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861304; c=relaxed/simple;
	bh=cg3eYZaT7wdpdVcF7nDYAGFive5kIKPK/aEXxzfTGT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=izZ0Yl4CkQogIEdK2U37C4c4p6qcoNzkEsXUsil6AxPENC5aYHmHBUzqGe1QvQLVgF6Gyq+pd3g+O/3NNsCnyUS9NwP930I6WAugxEcBzxmJqUq134VZ29nfg3cQUcKiNiIzJ+ldhGundh3dCPqOuuydfakMmAOS+HsPSGKWe0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZYj6a1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZYj6a1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FD1C2BCB0;
	Fri, 15 May 2026 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861304;
	bh=cg3eYZaT7wdpdVcF7nDYAGFive5kIKPK/aEXxzfTGT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZYj6a1T4jYVikeeD2H/33XZU89aavolPJrZu8I66cAjQ7fgYvHg/Z8tjjfVC95Fx
	 w4rigZziEiaEyhflQ7FOvSfeX31mSb045QLBmu2AwmYHTVtkAa8ZKxqGThMTYWsqk9
	 5fgaqXLu2DrlCpkFZnIk3I3OfO8Qw3HWr9ldrmtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 276/474] power: supply: max17042: avoid overflow when determining health
Date: Fri, 15 May 2026 17:46:25 +0200
Message-ID: <20260515154720.973962307@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 9a44949da669708f19d29141e65b3ac774d08f5a upstream.

If vmax has the default value of INT_MAX (e.g. because not specified in
DT), battery health is reported as over-voltage. This is because adding
any value to vmax (the vmax tolerance in this case) causes it to wrap
around, making it negative and smaller than the measured battery
voltage.

Avoid that by using size_add().

Fixes: edd4ab055931 ("power: max17042_battery: add HEALTH and TEMP_* properties support")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/20260302-max77759-fg-v3-6-3c5f01dbda23@linaro.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17042_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -199,7 +199,7 @@ static int max17042_get_battery_health(s
 		goto out;
 	}
 
-	if (vbatt > chip->pdata->vmax + MAX17042_VMAX_TOLERANCE) {
+	if (vbatt > size_add(chip->pdata->vmax, MAX17042_VMAX_TOLERANCE)) {
 		*health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 		goto out;
 	}


