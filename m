Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A512B3C3F41;
	Sat, 17 Oct 2026 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259207; cv=none; b=DZpYOsln4g6tXKwkJRteIWu8eY3DgcziU5b11vLH88wINFp5ZU3foHTZ/ZV5OgGGl79M62IZKI5xpoXsurRV7I4I4Gr2g/RQ8sdrfGMHk3CUuL7mo91T/Viwwcnhmuz7+0Boe2IF0vO9scfzBx8n1IOfywjkVVbtWlVSseoTyl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259207; c=relaxed/simple;
	bh=YgXYnkkFTMFHZSNkXxS6ZO+mCDXoSrNHfBYPedCPCcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOOlvUzEQZN1HWO/6QvRs9irddjPpEXHK8u9o8XRE5ew1R/fEUMUHxKOFdxzAIGgPcXP14WlXudT7Y9QpNEEiGT6uy9B1nc8PQw7fKMma7TSy47QdYhcE0TUdLxZcXXH+SvlJMrIn+X1kfvvQygowwcRQqliYZgjDcbsBY8DEgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAXBN2Wf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAXBN2Wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088CA1F000C4;
	Sat, 17 Oct 2026 17:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259206;
	bh=iKBHOBfn5OfrucietlrmPeWn4gyHVYZUfIzk50OA9So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAXBN2WfjHXNqERgFng8apRfzooC5wiMR/Pi0kIAnogIj7b3xyzpoZpab5h2oIH6g
	 nHEauKDlWKrt/V3utyf4h93t6Qqjeo7mFgExZNf/Loxi1IEv6k7auyOhwekMFPEPTH
	 lqJ1nGe5m/UQvGgym/PsZdaciN5eHmHjhqjGPgq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1136/1674] hwmon: (pmbus/core) honor vrm_version in pmbus_data2reg_vid()
Date: Sat, 17 Oct 2026 17:56:48 +0200
Message-ID: <20261017160500.319921533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 828cd614e2af053ca5e1d6da767bbd8a1b5cabfb ]

pmbus_data2reg_vid() hardcoded the VR11 encoding regardless of the
vrm_version configured by the driver, while pmbus_reg2data_vid()
already switched on it. Any driver that selects a non-VR11 VID mode
and exposes a regulator (or hwmon vout setter) sent dangerously
wrong codes to PMBUS_VOUT_COMMAND -- e.g. an nvidia195mv part asked
for 200 mV got the VR11 clamp to 500 mV encoded as 0xB2, which the
chip interprets as 1080 mV.

Mirror pmbus_reg2data_vid() so writes round-trip with reads.

Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Assisted-by: Claude:claude-opus-4-7 [Claude Code]
Link: https://lore.kernel.org/r/20260620-pmbus-data2reg-vid-v1-1-5518030432c4@nexthop.ai
Fixes: 068c227056b92 ("hwmon: (pmbus) Add support for VR12")
Fixes: d4977c083aeb2 ("hwmon: (pmbus) Add support for Intel VID protocol VR13")
Fixes: 9d72340b6ade9 ("hwmon: (pmbus/core) Add support for Intel IMVP9 and AMD 6.25mV modes")
Fixes: 969a4ec86ca5f ("hwmon: (pmbus/core) Add support for NVIDIA nvidia195mv mode")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 4be4c396b9006..e763ecf2f3c1e 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1023,9 +1023,24 @@ static u16 pmbus_data2reg_direct(struct pmbus_data *data,
 static u16 pmbus_data2reg_vid(struct pmbus_data *data,
 			      struct pmbus_sensor *sensor, s64 val)
 {
-	val = clamp_val(val, 500, 1600);
-
-	return 2 + DIV_ROUND_CLOSEST_ULL((1600LL - val) * 100LL, 625);
+	switch (data->info->vrm_version[sensor->page]) {
+	case vr12:
+		val = clamp_val(val, 250, 1520);
+		return 1 + DIV_ROUND_CLOSEST_ULL(val - 250, 5);
+	case vr13:
+		val = clamp_val(val, 500, 3040);
+		return 1 + DIV_ROUND_CLOSEST_ULL(val - 500, 10);
+	case imvp9:
+		val = clamp_val(val, 200, 2740);
+		return 1 + DIV_ROUND_CLOSEST_ULL(val - 200, 10);
+	case amd625mv:
+		val = clamp_val(val, 200, 1550);
+		return DIV_ROUND_CLOSEST_ULL((1550LL - val) * 100LL, 625);
+	case vr11:
+	default:
+		val = clamp_val(val, 500, 1600);
+		return 2 + DIV_ROUND_CLOSEST_ULL((1600LL - val) * 100LL, 625);
+	}
 }
 
 static u16 pmbus_data2reg(struct pmbus_data *data,
-- 
2.53.0



