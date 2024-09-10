Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D58218FC90;
	Tue, 10 Sep 2024 09:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961749; cv=none; b=BbPwoD1hxIbKpbOlP15/5uPpH3SDdGFJQcnzxFpMqJ6NWdQNSsB0A/KSbxyCM6vy+FVDENrgTplf1qYCGJES1BhItJeAInLdPI7+fpraxonMNixyURH3+/o9ILMalNlCB3V/mC4sV8AXBI5RnJY4gCAVdK3I3aOYPEHLVZMNa40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961749; c=relaxed/simple;
	bh=RShlGfyD45rdmpvQyba4DT/na4y2RYC2mSQO9e2U0OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5CpaEgU/6/E9DLXW5DZrehSQ2dNLX7x//rv6j1Iyrm7Exy72Ql3xEhcerjHWAnvZOLktRnYcdGfWFVitVi1cylF5FiKARivxwsKScra1/TUDuJGHrcQSSTqalr/l+P/+mhnptfRMk4nYkYjy0ygWi7Xxo14bz4HVs24/mc87Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EK+AzwOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EK+AzwOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13191C4CEC3;
	Tue, 10 Sep 2024 09:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961749;
	bh=RShlGfyD45rdmpvQyba4DT/na4y2RYC2mSQO9e2U0OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EK+AzwOFYDXc+080Y+SW2kNmiILm/ZC35ErmI8BBCyBDtvAcHyBnHm2Ub/FrXcSM9
	 Bs4BhdtHC+Xlxd7i4eo5McxtdLxoO8jOjvdjiH7os0ybKl5UqPq54XeaPscPqjwrSW
	 9SlRKEeUsfJY7oqV70D8h+y0MXOVn61eNf7foQf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 176/375] hwmon: (hp-wmi-sensors) Check if WMI event data exists
Date: Tue, 10 Sep 2024 11:29:33 +0200
Message-ID: <20240910092628.390321582@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit a54da9df75cd1b4b5028f6c60f9a211532680585 ]

The BIOS can choose to return no event data in response to a
WMI event, so the ACPI object passed to the WMI notify handler
can be NULL.

Check for such a situation and ignore the event in such a case.

Fixes: 23902f98f8d4 ("hwmon: add HP WMI Sensors driver")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Message-ID: <20240901031055.3030-2-W_Armin@gmx.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hp-wmi-sensors.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/hp-wmi-sensors.c b/drivers/hwmon/hp-wmi-sensors.c
index b5325d0e72b9..dfa1d6926dea 100644
--- a/drivers/hwmon/hp-wmi-sensors.c
+++ b/drivers/hwmon/hp-wmi-sensors.c
@@ -1637,6 +1637,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		goto out_unlock;
 
 	wobj = out.pointer;
+	if (!wobj)
+		goto out_unlock;
 
 	err = populate_event_from_wobj(dev, &event, wobj);
 	if (err) {
-- 
2.43.0



