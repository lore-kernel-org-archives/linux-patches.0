Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570953C01;
	Tue, 27 May 2025 17:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367311; cv=none; b=Zf0njgSZ41etPBcAPcYbWV81FN9ego7wgLbychTczheHUdwJzWNHbGQsA8JbTyJUKHZyA+ah5XldfmbwFRUcLXUmN+K/YC0pCDSULqkCUPw5yqNLwy0HTKtFsOXKakkcWfRX+LuK0+0QeJobUT16PGSV6LJd4thljvGv9FgvHyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367311; c=relaxed/simple;
	bh=AgisHirvke8uzbpLma0EDVsedveNuIaAHqAGu/EMrIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeEdPWFHmOcQixcI7PWoITQ/etZ5+fUrTp2FsdlDP23+919SUNtwrS+0pPk3p7dpCE2VqzFIyG5IpKmyhgenY+p5JRpAbbWfJ/9cc8I3qjPmBJ2d7upowWwPioaLQCbTxbjxroi/3eRezkxPNLawrMrnxAmOwoUa0CU3gKuWzVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TQryxja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TQryxja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AB6C4CEE9;
	Tue, 27 May 2025 17:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367311;
	bh=AgisHirvke8uzbpLma0EDVsedveNuIaAHqAGu/EMrIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TQryxjaRccy2XnWTOCXmuglcqdha9zAa8Id4/cHF2SKk6/bRueW41LzDTjnAG3Na
	 CtJCa9K9fF84IralStZ1OSVT6UvoOeeT4JsTCtLbocBu4WsdMKS1uE+CtqwlNHkh4E
	 p+ahpAuyoFDnGARMxHp+ZqT8TCRqQkTep5Lj1irg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 316/783] hwmon: (acpi_power_meter) Fix the fake power alarm reporting
Date: Tue, 27 May 2025 18:21:53 +0200
Message-ID: <20250527162525.933525103@linuxfoundation.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 0ea627381eb527a0ebd262c690c3992085b87ff4 ]

We encountered a problem that a fake power alarm is reported to
user on the platform unsupported notifications at the second step
below:
1> Query 'power1_alarm' attribute when the power capping occurs.
2> Query 'power1_alarm' attribute when the power capping is over
   and the current average power is less then power cap value.

The root cause is that the resource->power_alarm is set to true
at the first step. And power meter use this old value to show
the power alarm state instead of the current the comparison value.

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://lore.kernel.org/r/20250220030832.2976-1-lihuisong@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 44afb07409a46..f05986e4f3792 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -437,9 +437,13 @@ static ssize_t show_val(struct device *dev,
 			ret = update_cap(resource);
 			if (ret)
 				return ret;
+			resource->power_alarm = resource->power > resource->cap;
+			val = resource->power_alarm;
+		} else {
+			val = resource->power_alarm ||
+				 resource->power > resource->cap;
+			resource->power_alarm = resource->power > resource->cap;
 		}
-		val = resource->power_alarm || resource->power > resource->cap;
-		resource->power_alarm = resource->power > resource->cap;
 		break;
 	case 7:
 	case 8:
-- 
2.39.5



