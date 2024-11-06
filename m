Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3779F1DF24A;
	Wed,  6 Nov 2024 12:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895606; cv=none; b=ftAK8E7HQjtRye7JxqoUnpc5cR+WQ6PAckDAD9XG5mGX5pYMP2yHCbZs+a0ylAVzCryvlIZpv5T23GPx+f91H+4fkBMhyYeRmVZ39eevf3XAvv5SnrY2Or8/T6CFzjCLtzmZPsZsjEMvtlF3LKMZlePfPcoMp0GeSHAB7j+0LrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895606; c=relaxed/simple;
	bh=J3wAds+0M4hgUMg4EfKqHRavPoii5ZG1MbCkNcNWYyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txuITSYFQgMY8V5DmvB72zHuBE7O8g7mD494IyLgszyLESt5omFL/KMD2nrcWNU/RL5Q7BlSwtHEFlPtafYmh5sPzpsOLLlhga76QbcqwTdPb3rKulD6/8KgnTAT5sjAzccMhQBae8ka+Ncsq4KXiWtq4Dcy9Cv8yAroXAQQFKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pX3U6cz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pX3U6cz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2840C4CECD;
	Wed,  6 Nov 2024 12:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895606;
	bh=J3wAds+0M4hgUMg4EfKqHRavPoii5ZG1MbCkNcNWYyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pX3U6cz15oaSSUOTiem9DhsAyXSWJSwx/PgoK0PTWBCBP+3AoCm9IsSV2z2DslIrD
	 UW7yudGsXWTKTPeGMrD9u8aYE+EWrku8+/QLPHLLzKeInRKKMHrUxxeJgzVwMd2UBt
	 Gnc9651nUbZWCyvi9bf5916ummYPw05pAqJ2LOjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Bruno VERNAY <bruno.vernay@se.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 4.19 274/350] net: dsa: mv88e6xxx: Fix out-of-bound access
Date: Wed,  6 Nov 2024 13:03:22 +0100
Message-ID: <20241106120327.643219600@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Huang <Joseph.Huang@garmin.com>

commit 528876d867a23b5198022baf2e388052ca67c952 upstream.

If an ATU violation was caused by a CPU Load operation, the SPID could
be larger than DSA_MAX_PORTS (the size of mv88e6xxx_chip.ports[] array).

Fixes: 75c05a74e745 ("net: dsa: mv88e6xxx: Fix counting of ATU violations")
Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240819235251.1331763-1-Joseph.Huang@garmin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Bruno VERNAY <bruno.vernay@se.com>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/global1_atu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -363,7 +363,8 @@ static irqreturn_t mv88e6xxx_g1_atu_prob
 		dev_err_ratelimited(chip->dev,
 				    "ATU full violation for %pM portvec %x spid %d\n",
 				    entry.mac, entry.portvec, spid);
-		chip->ports[spid].atu_full_violation++;
+		if (spid < ARRAY_SIZE(chip->ports))
+			chip->ports[spid].atu_full_violation++;
 	}
 	mutex_unlock(&chip->reg_lock);
 


